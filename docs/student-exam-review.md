# Student exam review

After an existing submitted booklet attempt, the student detail page calls `student_exam_review` with only the exam ID. The RPC derives the student from auth.uid(), verifies role, own submitted attempt, published exam and current eligibility, then returns per-question results. There is no student-ID parameter and no grading/editing client write. The exam list links completed attempts to review. Filters cover status and booklet, with explicit labels and a PDF question booklet link. Unkeyed answered questions are ungraded, never incorrectly called wrong or blank. Stored legacy grading totals are not rewritten.

## Deployment order
1. Apply additive migration 028 for preview and production compatibility.
2. Deploy the app including both counselor RPC consumers.
3. Apply migration 029 only after the new app is live. This removes an existing direct-table key exposure without breaking old counselor pages. Do NOT apply 029 during preview-only rollout.

The original app grants authenticated table-wide SELECT on exam_booklets, including key_answers. This existing access is not increased by the new feature; 029 is required for complete pre-submission key protection. New review RPC access itself is submission-gated. Existing submit/grading/timing code is unchanged.
