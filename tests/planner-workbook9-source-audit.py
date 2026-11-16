"""Audit workbook exercise starts against the user's 1405 PDF, with PyMuPDF installed."""
import hashlib
import json
import re
from pathlib import Path
import pymupdf

root = Path(__file__).resolve().parent.parent
pdf = root / 'google_drive/ketab-kar-zaban-9-911-1405.pdf'
assert hashlib.sha256(pdf.read_bytes()).hexdigest() == 'c3a9a730e675344550538379e73f1f73d9fb0ae1bc7f258b5ddbd2ff70a888c5'
source = (root / 'supabase/migrations/169_planner_english_1405_details.sql').read_text()
book = next(b for b in json.loads(source.split('$books$')[1]) if b['grade'] == '9')
# Transcribed independently from the actual start of each numbered exercise.
matrix = [
 [8,8,9,10,11,12,14,15,16,17],
 [22,22,23,23,25,27,28,29,30,32],
 [36,37,38,39,41,42,43,45,47,48],
 [54,55,56,57,58,59,60,62,63,64],
 [68,69,70,71,72,73,73,76,78,79],
 [84,85,86,87,88,89,90,91,93,94,95],
]
doc = pymupdf.open(pdf)
for lesson, starts in enumerate(matrix, 1):
 for exercise, page_number in enumerate(starts, 1):
  p = next(x for x in book['topics'] if x['position'] == lesson * 100 + exercise + 1)
  assert p['start'] == page_number and re.search(rf'تمرین {exercise}(:|$)', p['title']), p
  page = doc[page_number - 1]
  text = page.get_text()
  assert f'Lesson {lesson}' in text, (lesson, exercise, page_number)
  # Numbers are appended to the Persian instruction by this PDF's text extractor.
  digits = str(exercise) if exercise not in (1, 2) or lesson != 1 else ('١' if exercise == 1 else '٢')
  assert re.search(r'(?<!\d)' + digits + r'(?!\d)', text), (lesson, exercise, page_number)
  assert any(str(page_number) in b[4].split() for b in page.get_text('blocks') if b[1] > page.rect.height * .8), (lesson, exercise, page_number)
print('PASS workbook 9: SHA, 61 exercise starts, lesson labels and printed footers')
