"""Optional printed-page audit. Requires PyMuPDF and the three user PDFs in google_drive/."""
from pathlib import Path
import hashlib, json, re
import pymupdf

books = json.loads(Path('supabase/migrations/228_planner_writing_finer_1405.sql').read_text().split('$books$')[1])
sources = {
 '10': ('negaresh-1-10-110202-1405.pdf', 'c7e8976b2cc7abcc5b8807ac7167f8ed9835f6fa3f7fbe6fcfaf13e0f5841161', -1),
 '11': ('negaresh-2-11-111202-1405.pdf', '92bc3f3f16a5d205861824dfb2b4391920ac4ccab751a88de0b5e9104ee4f50a', -1),
 '12': ('negaresh-12-112202-1405.pdf', 'd4e2d4f2c21220186fe26efa2201aca2e6699c2c18b22a55ae242434693ae3be', 0),
}
for book in books:
 name,digest,offset=sources[book['grade']]
 path=Path('google_drive')/name
 assert hashlib.sha256(path.read_bytes()).hexdigest()==digest, name
 doc=pymupdf.open(path)
 for item in book['topics']:
  for printed in {item['start'],item['end']}:
   page=doc[printed+offset]
   # Persian PDF numbers are sometimes extracted in reverse; use only footer lines.
   lines=[]
   for block in page.get_text('blocks'):
    if block[1]>page.rect.height*.82:
     lines.extend(line.strip() for line in block[4].splitlines())
   assert str(printed) in lines or str(printed)[::-1] in lines,(name,printed,item['title'],lines)
 print(f"PASS {name}: {len(book['topics'])} topic ranges and printed page numbers")
