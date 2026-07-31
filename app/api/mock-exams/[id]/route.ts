import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

export async function GET(_request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params;
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL, key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  if (!url || !key) return NextResponse.json({ error: "Supabase is not configured." }, { status: 500 });
  const supabase = createClient(url, key, { auth: { persistSession: false } });
  const { data: paper, error } = await supabase.from("exam_papers")
    .select("id, paper_number, title, description, duration_minutes, total_marks")
    .eq("id", id).eq("status", "published").single();
  if (error || !paper) return NextResponse.json({ error: "Paper not found." }, { status: 404 });
  const { data: rows, error: questionError } = await supabase.from("exam_paper_questions")
    .select("position, questions!inner(id, question_type, marks, stem_blocks, options, syllabus_objectives(code))")
    .eq("exam_paper_id", id).order("position");
  if (questionError) return NextResponse.json({ error: questionError.message }, { status: 500 });
  return NextResponse.json({ paper, questions: (rows ?? []).map((row) => ({ position: row.position, ...row.questions })) });
}
