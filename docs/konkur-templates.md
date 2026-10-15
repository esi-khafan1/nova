# National entrance-exam templates

Version: `national-1404-v1`. Regular national exam only; excludes teacher-training and special nursing booklets. This deliberately versions the confirmed structure rather than assuming future exam changes.

Some secondary pages incorrectly swap physics and chemistry counts. Actual question booklets take precedence over article summaries.

## Immutable structure

| Field | Booklet | Subject ranges (inclusive) | Booklet time |
|---|---|---|---|
| Mathematics | 1 | Mathematics 1–40 | 70 min |
| Mathematics | 2 | Physics 41–75; Chemistry 76–105 | 75 min |
| Experimental sciences | 1 | Biology 1–45 | 45 min |
| Experimental sciences | 2 | Physics 46–75; Chemistry 76–110 | 75 min |
| Experimental sciences | 3 | Mathematics 111–140; Geology 141–155 | 60 min |
| Humanities | 1 | Mathematics 1–20; Persian literature 21–50; Social sciences 51–65; Psychology 66–80 | 85 min |
| Humanities | 2 | Arabic 81–100; History 101–113; Geography 114–125; Philosophy/logic 126–145; Economics 146–160 | 75 min |
| Arts | 1 | General art 1–50; General mathematics/physics 51–80; Visual creativity 81–100 | 115 min |
| Foreign languages | 1 | Selected specialized language 1–70 | 105 min |

Totals: Mathematics 105 questions / 145 min; experimental sciences 155 / 180; humanities **160**, not 175 / 160; arts 100 / 115; foreign languages 70 / 105.

Times belong to booklets, not separate subject timers. Each booklet has one PDF and one globally numbered key. A subject percentage is `(3 × correct − incorrect) × 100 / (3 × subject question count)`, rounded to two decimals. Unanswered questions have no negative mark. Canonical ranges are created by the server, never trusted from form JSON.

## Sources

- Sanjesh national-exam portal: https://sanjesh.org/fa-IR/sanjesh/4924/page/سراسری
- Report quoting IRNA/Sanjesh on the 1404 booklet composition (mathematics, humanities, arts, languages): https://www.sarpoosh.com/education-news/test-exam/test-exam1404020696.html
- Booklet time tables, cross-checked against question counts (the article's humanities total prose is inconsistent; use the actual booklet sum): https://konkursara.com/تعداد-سوالات-کنکور-۱۴۰۵
- Original Sanjesh-format mathematics PDFs mirrored by Heyva, printed year 1405; verified question 41 begins physics and question 76 begins chemistry:
  - https://dl.heyvagroup.com/admin/Files/upload/riazi1riazi.pdf
  - https://dl.heyvagroup.com/admin/Files/upload/fizikshimi2riazi.pdf
  - Index: https://www.heyvagroup.com/shownews/13394/سوالات-کنکور-ریاضی-۱۴۰۵.html
- Original humanities PDFs mirrored by Heyva, printed year 1405; verified second booklet begins Arabic at 81:
  - https://dl.heyvagroup.com/admin/Files/upload/riazi3ensani.pdf
  - https://dl.heyvagroup.com/admin/Files/upload/arabi4ensani.pdf
- Humanities 1404 original-booklet mirror and ordering: https://konkoor.co/ensani-1404-2/
- Foreign-language original booklet, printed year 1405: https://dl.heyvagroup.com/admin/Files/upload/english7zaban.pdf

Historic exams retain their original booklet layout and fallback result calculation. Do not retrofit their `exam_field` into the new template or renumber submitted answers.

Additional original 1405 booklet copies were downloaded and cross-checked for subject ordering and boundaries:
- Biology: https://dl.heyvagroup.com/admin/Files/upload/247284557zist1405.pdf
- Experimental physics/chemistry: https://dl.heyvagroup.com/admin/Files/upload/1874733952phyShimi1405.pdf
- Experimental mathematics/geology: https://dl.heyvagroup.com/admin/Files/upload/743161374RiaziZamin1405.pdf
- Arts: https://dl.heyvagroup.com/admin/Files/upload/honar6.pdf
