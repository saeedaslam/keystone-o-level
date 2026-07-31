# Question authoring

Questions are stored as ordered `stem_blocks`, so the exam engine can render mixed content without storing unsafe HTML.

## Supported blocks

- `paragraph`: question text
- `image`: Supabase Storage URL, required alt text, and optional caption
- `table`: caption, column headers, and rows
- `code`: SQL, pseudocode, or source code
- `list`: ordered or unordered items

## Publishing workflow

1. Upload original diagrams or photos to the `question-media` Storage bucket.
2. Create the question as `draft` and assemble its blocks in reading order.
3. Add options, marking points, model answer, marks, and syllabus topic.
4. Preview it on phone and desktop.
5. A reviewer moves it to `reviewed`; an admin moves it to `published`.

Never upload Cambridge past-paper scans or copied diagrams. Recreate original, syllabus-aligned artwork and always provide useful alt text.

## Content Studio

Open `/admin/questions` to create a syllabus-mapped question. The studio provides:

- topic and learning-objective selection from the live 2026–2028 hierarchy
- MCQ, structured, SQL and pseudocode question types
- paragraph, table, image, code and list content blocks
- live preview, mark scheme, model answer and draft/review/publish status

Writers must sign in with Supabase Auth and have `{"role":"admin"}` in `app_metadata`. Set this trusted server-managed metadata in the Supabase dashboard; never use editable `user_metadata` for authorization.

The database rejects a question if its learning objective belongs to a different topic. Public users can read only published questions; administrators can read and manage the full workflow.

## Student practice

The practice library now opens every syllabus topic. MCQs are marked automatically. Structured, SQL and pseudocode questions collect a written response, reveal the model answer and marking points, and ask the student to self-mark before continuing.

## Image block

```json
{"type":"image","url":"https://PROJECT.supabase.co/storage/v1/object/public/question-media/2210/3/network.webp","alt":"Four computers connected to a switch and router","caption":"Network used in Question 4"}
```

## Table block

```json
{"type":"table","caption":"STUDENT table","headers":["StudentID","Name","Score"],"rows":[["S01","Amina","72"],["S02","Ben","84"]]}
```
