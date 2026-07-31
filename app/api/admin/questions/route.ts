import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

const kinds = new Set(["mcq", "structured", "sql", "pseudocode"]);
const difficulties = new Set(["foundation", "core", "extended"]);
const statuses = new Set(["draft", "reviewed", "published"]);

export async function POST(request: NextRequest) {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  const token = request.headers.get("authorization")?.replace(/^Bearer\s+/i, "");
  if (!url || !key || !token) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const body = await request.json();
  if (!body.topicId || !body.objectiveId || !kinds.has(body.questionType) || !difficulties.has(body.difficulty) || !statuses.has(body.status)) {
    return NextResponse.json({ error: "Question metadata is incomplete." }, { status: 400 });
  }
  if (!Array.isArray(body.stemBlocks) || body.stemBlocks.length === 0 || !Array.isArray(body.markScheme)) {
    return NextResponse.json({ error: "At least one content block and a mark scheme are required." }, { status: 400 });
  }
  if (body.questionType === "mcq" && (!Array.isArray(body.options) || body.options.length < 2 || !Number.isInteger(body.correctAnswer))) {
    return NextResponse.json({ error: "MCQs require options and a correct option number." }, { status: 400 });
  }

  const supabase = createClient(url, key, { global: { headers: { Authorization: `Bearer ${token}` } }, auth: { persistSession: false } });
  const { data: userData, error: userError } = await supabase.auth.getUser(token);
  if (userError || !userData.user) return NextResponse.json({ error: "Invalid session." }, { status: 401 });
  if (userData.user.app_metadata?.role !== "admin") return NextResponse.json({ error: "Administrator role required." }, { status: 403 });
  const { data, error } = await supabase.from("questions").insert({
    topic_id: body.topicId, syllabus_objective_id: body.objectiveId, question_type: body.questionType,
    marks: Number(body.marks), difficulty: body.difficulty, stem_blocks: body.stemBlocks,
    options: body.questionType === "mcq" ? body.options : null,
    correct_answer: body.questionType === "mcq" ? body.correctAnswer : null,
    mark_scheme: body.markScheme, model_answer: body.modelAnswer || null,
    explanation: body.explanation || null, status: body.status, created_by: userData.user.id,
  }).select("id, status").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 403 });
  return NextResponse.json({ question: data }, { status: 201 });
}
