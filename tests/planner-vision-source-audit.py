"""Optional source audit: requires PyMuPDF and the user's original PDFs in google_drive/.
Checks the printed footer and every visibly lettered exercise, not correctness of answers.
"""
from pathlib import Path
import hashlib, json, re
import pymupdf

books = json.loads(Path('supabase/migrations/227_planner_vision_exercises_1405.sql').read_text().split('$books$')[1])
sources = {
 '10': ('zaban-1-10-110230-1405.pdf', 'c3c79b552efd3fec60c9b209d45ab5c5a1b490a8bd80d33bee9a40906b8b4d56', -1, 119),
 '11': ('zaban-2-11-111230-1405.pdf', '218f4ff6867cfff1f592ecb09dde853cdc9d09fb8bb6ac099048dfedeb92cec4', -1, 107),
 '12': ('english-12-112230-1405.pdf', 'cae12b86362c68fa9fc87dee6f7940c7c2a364d5444f35c825908d50b81e3e22', 0, 99),
}
for book in books:
 name, digest, offset, last = sources[book['grade']]
 path = Path('google_drive') / name
 assert hashlib.sha256(path.read_bytes()).hexdigest() == digest, name
 doc = pymupdf.open(path)
 labelled = set()
 for item in book['topics']:
  match = re.match(r'^درس (\d+) — (.*?) — ([A-H]): ', item['title'])
  if match:
   labelled.add((item['start'], match.group(3)))
  else:
   assert book['grade'] == '12' and item['start'] == 66 and item['end'] == 67
  for printed in {item['start'], item['end']}:
   page = doc[printed + offset]
   footer = [b[4].strip() for b in page.get_text('blocks') if b[1] > page.rect.height * .88]
   assert str(printed) in footer, (name, printed, footer)
 for page_number in range(17, last + 1):
  text = doc[page_number + offset].get_text()
  found = {(page_number,m.group(1)) for m in re.finditer(r'(?m)^\s*([A-H])\s*\.\s+[^\n]+', text)}
  expected = {item for item in labelled if item[0] == page_number}
  assert found == expected, (name, page_number, 'missing from seed', found-expected, 'missing from PDF', expected-found)
 print(f"PASS {name}: {len(book['topics'])} entries, lettered exercise starts and printed footers")
