"""Run with PyMuPDF and the original PDFs in google_drive/."""
import hashlib
import json
import re
from pathlib import Path
import pymupdf

ROOT = Path(__file__).resolve().parent.parent
DATA = json.loads((ROOT / 'supabase/migrations/230_planner_geography_skills_1405.sql').read_text().split('$topics$')[1])
BOOKS = {
    '11': ('joghrafia-2-11-111218-1405.pdf', 'dd3f33d6cf9f352d539f55293fa95f03c552d45fb88c33b07573d29e5393e4b4', 7),
    '12': ('joghrafia-12-112218-1405.pdf', '97d43525994eb3e1dfc22cb036eaaf545aa26c3d0dea48f4033a1596e82b6a29', 8),
}
# Independent anchors in extracted text; PDF extraction may reorder Persian words.
ANCHORS = {
    '11': {18: 'سوئیس', 35: 'ایزوبار', 36: '1020', 51: 'توپوگرافی', 52: 'توپوگرافی', 64: 'بیابان', 82: 'زبانی', 98: 'برنج', 112: 'اوپک', 114: 'تکفیری', 126: 'هرمز', 141: 'همسایه', 153: 'کشور'},
    '12': {59: 'پایدار', 60: 'انحراف', 61: 'ماتریس', 62: 'محموله', 63: 'زیست', 64: 'ایمنی', 65: 'بیمه', 82: 'مخاطرات', 83: 'کانون', 84: 'گسل', 85: 'ریشتر', 86: 'نگار', 87: 'هیمالیا', 88: 'ایران', 89: 'آبدهی', 90: 'سد', 92: 'سیل', 93: 'دامنه', 94: 'لغزش', 97: 'لغزش', 98: 'سالی', 99: 'سالی', 100: 'بحران', 101: 'زلزله', 102: 'ژاپن', 103: 'زمین', 104: 'سیل', 105: 'سازه', 106: 'سیل', 107: 'لغزش', 108: 'لغزش', 110: 'آبیاری', 111: 'سنجش', 114: 'فضایی'},
}
for grade, (name, digest, offset) in BOOKS.items():
    path = ROOT / 'google_drive' / name
    assert hashlib.sha256(path.read_bytes()).hexdigest() == digest, name
    doc = pymupdf.open(path)
    topics = [p for p in DATA if p['grade'] == grade]
    assert len(topics) == (18 if grade == '11' else 19)
    for page_number, marker in ANCHORS[grade].items():
        assert marker in doc[page_number + offset].get_text(), (grade, page_number, marker)
    for topic in topics:
        assert topic['start'] <= topic['end']
        for number in {topic['start'], topic['end']}:
            page = doc[number + offset]
            footer = ' '.join(block[4] for block in page.get_text('blocks') if block[1] > page.rect.height * .8)
            n = str(number)
            assert re.search(r'(?<!\d)(?:' + '|'.join([n, n[::-1], n * 2, n[::-1] * 2]) + r')(?!\d)', footer), (name, topic, number)
    print(f'PASS {name}: {len(topics)} additions, endpoint footers and independent text anchors')
