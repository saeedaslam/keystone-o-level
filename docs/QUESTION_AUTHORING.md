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

## Image block

```json
{"type":"image","url":"https://PROJECT.supabase.co/storage/v1/object/public/question-media/2210/3/network.webp","alt":"Four computers connected to a switch and router","caption":"Network used in Question 4"}
```

## Table block

```json
{"type":"table","caption":"STUDENT table","headers":["StudentID","Name","Score"],"rows":[["S01","Amina","72"],["S02","Ben","84"]]}
```
