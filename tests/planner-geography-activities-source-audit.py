"""Optional audit against user PDFs. Requires PyMuPDF and the files in google_drive/."""
import hashlib, json, re
from pathlib import Path
import pymupdf

sql = Path('supabase/migrations/229_planner_geography_activities_1405.sql').read_text()
topics = json.loads(sql.split('$topics$')[1])
files = {
    '10': ('joghrafia-10-110218-1405.pdf', '1ec90e7ea27133725a4c6a35094f2372b43501c0e5ff320c4d41d5a3c5cc2b53', 5),
    '11': ('joghrafia-2-11-111218-1405.pdf', 'dd3f33d6cf9f352d539f55293fa95f03c552d45fb88c33b07573d29e5393e4b4', 7),
    '12': ('joghrafia-12-112218-1405.pdf', '97d43525994eb3e1dfc22cb036eaaf545aa26c3d0dea48f4033a1596e82b6a29', 8),
}
# Independent page inventory transcribed from the book, not generated from the migration.
activity_pages_12 = [3,5,6,9,16,18,20,23,24,27,29,34,35,37,40,45,47,51,55,58,61,66,70,72,73,74,76,80,88,92,96,99,103,106,110,114]
for grade, (name, digest, offset) in files.items():
    path = Path('google_drive') / name
    assert hashlib.sha256(path.read_bytes()).hexdigest() == digest, name
    doc = pymupdf.open(path)
    selected = [p for p in topics if p['grade'] == grade]
    for item in selected:
        for printed in {item['start'], item['end']}:
            page = doc[printed + offset]
            # Footer often extracts adjacent to another line and the digits may be reversed.
            footer = ' '.join(block[4] for block in page.get_text('blocks') if block[1] > page.rect.height * .80)
            def has_number(n, content):
                options = [str(n), str(n)[::-1], str(n) * 2, str(n)[::-1] * 2]
                return re.search(r'(?<!\d)(?:' + '|'.join(options) + r')(?!\d)', content)
            if (grade == '12' and printed in (20, 58)) or (grade == '11' and printed == 28):
                # Full-bleed pages have no printed footer; verify the preceding numbered page.
                previous = doc[printed + offset - 1]
                adjacent_footer = ' '.join(b[4] for b in previous.get_text('blocks') if b[1] > previous.rect.height * .80)
                assert has_number(printed - 1, adjacent_footer), (name, printed)
            else:
                assert has_number(printed, footer), (name, printed)
        text = doc[item['start'] + offset].get_text()
        if grade == '10':
            number = item['title'].split(' ')[1]
            english_number = number.translate(str.maketrans('۰۱۲۳۴۵۶۷۸۹', '0123456789'))
            pattern = '[' + number + english_number + r']\s*:\s*فعـالـیت'
            assert re.search(pattern, text), (name, item)
        else:
            assert any(block[4].strip() == 'فعـالیـت' for block in doc[item['start'] + offset].get_text('blocks')), (name, item)
    if grade == '10':
        observed = []
        for printed in range(2, 109):
            text = doc[printed + offset].get_text()
            observed.extend((printed, int(n.translate(str.maketrans('۰۱۲۳۴۵۶۷۸۹', '0123456789'))))
                            for n in re.findall(r'([0-9۰-۹]+)\s*:\s*فعـالـیت', text))
        recorded = [(p['start'], int(p['title'].split(' ')[1].translate(str.maketrans('۰۱۲۳۴۵۶۷۸۹', '0123456789')))) for p in selected]
        assert sorted(observed) == sorted(recorded) and len(observed) == 55
    if grade == '11':
        actual = [p for p in range(2, 160) for b in doc[p + offset].get_text('blocks') if b[4].strip() == 'فعـالیـت']
        recorded = [p['start'] for p in selected] + [18]  # page 17–18 is a single combined activity entry
        assert sorted(actual) == sorted(recorded)
    if grade == '12':
        actual = [p for p in range(2, 115) if any(b[4].strip() == 'فعـالیـت' for b in doc[p + offset].get_text('blocks'))]
        assert actual == activity_pages_12
        assert [p['start'] for p in selected] == activity_pages_12
    print(f'PASS {name}: {len(selected)} activity blocks, printed pages and source markers')
