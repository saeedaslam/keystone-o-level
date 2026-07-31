import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

function client(token: string) {
  return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL ?? "", process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? "", {
    global: { headers: { Authorization: `Bearer ${token}` } }, auth: { persistSession: false },
  });
}

export async function GET(request: NextRequest) {
  const token = request.headers.get("authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return NextResponse.json({ error: "Sign in required." }, { status: 401 });
  const supabase = client(token);
  const { data: user } = await supabase.auth.getUser(token);
  if (!user.user) return NextResponse.json({ error: "Invalid session." }, { status: 401 });
  const { data, error } = await supabase.from("attempts")
    .select("id, mode, started_at, submitted_at, score, total_marks, per_topic_breakdown, exam_papers(title, paper_number), topics(name, topic_number)")
    .eq("student_id", user.user.id).not("submitted_at", "is", null).order("submitted_at", { ascending: false }).limit(50);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ attempts: data ?? [] });
}

export async function POST(request: NextRequest) {
  const token = request.headers.get("authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return NextResponse.json({ error: "Sign in to save this result." }, { status: 401 });
  const supabase = client(token);
  const { data: user } = await supabase.auth.getUser(token);
  if (!user.user) return NextResponse.json({ error: "Invalid session." }, { status: 401 });
  const body = await request.json();
  const { data, error } = await supabase.rpc("submit_mock_attempt", {
    p_exam_paper_id: body.paperId,
    p_answers: body.answers ?? {},
    p_started_at: body.startedAt ?? new Date().toISOString(),
  }).single();
  if (error) return NextResponse.json({ error: error.message }, { status: 403 });
  return NextResponse.json({ attempt: data }, { status: 201 });
}
