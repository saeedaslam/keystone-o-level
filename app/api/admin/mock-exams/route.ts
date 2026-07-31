import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export async function POST(request: NextRequest) {
  const token = request.headers.get("authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL ?? "", process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? "", { global: { headers: { Authorization: `Bearer ${token}` } }, auth: { persistSession: false } });
  const { data: user } = await supabase.auth.getUser(token);
  if (!user.user) return NextResponse.json({ error: "Invalid session." }, { status: 401 });
  if (user.user.app_metadata?.role !== "admin") return NextResponse.json({ error: "Administrator role required." }, { status: 403 });
  const body = await request.json(), questionIds = [...new Set<string>(body.questionIds ?? [])];
  if (!body.title || ![1, 2].includes(Number(body.paperNumber)) || questionIds.length === 0) return NextResponse.json({ error: "Title, paper number and at least one question are required." }, { status: 400 });
  const { data: questions, error: questionError } = await supabase.from("questions").select("id, marks").in("id", questionIds).in("status", ["reviewed", "published"]);
  if (questionError || questions?.length !== questionIds.length) return NextResponse.json({ error: "One or more selected questions are unavailable." }, { status: 400 });
  const totalMarks = questions.reduce((sum, question) => sum + question.marks, 0);
  if (body.status === "published" && totalMarks !== 75) {
    return NextResponse.json({ error: `A published paper must contain exactly 75 marks; this selection has ${totalMarks}. Save it as a draft instead.` }, { status: 400 });
  }
  const { data: subject } = await supabase.from("subjects").select("id").eq("code", "2210").single();
  const { data: paper, error } = await supabase.from("exam_papers").insert({ subject_id: subject?.id, paper_number: Number(body.paperNumber), title: body.title, description: body.description || null, duration_minutes: Number(body.durationMinutes), total_marks: totalMarks, status: body.status === "published" ? "published" : "draft", created_by: user.user.id }).select("id, total_marks").single();
  if (error || !paper) return NextResponse.json({ error: error?.message ?? "Could not create paper." }, { status: 403 });
  const { error: linkError } = await supabase.from("exam_paper_questions").insert(questionIds.map((questionId, index) => ({ exam_paper_id: paper.id, question_id: questionId, position: index + 1 })));
  if (linkError) return NextResponse.json({ error: `Paper created, but questions could not be attached: ${linkError.message}` }, { status: 500 });
  return NextResponse.json({ paper }, { status: 201 });
}
