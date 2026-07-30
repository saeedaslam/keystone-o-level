import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  if (!url || !key) return NextResponse.json({ questions: [] });

  const topic = request.nextUrl.searchParams.get("topic") ?? "9";
  const supabase = createClient(url, key, { auth: { persistSession: false } });
  const { data, error } = await supabase
    .from("questions")
    .select("id, marks, question_type, stem_blocks, options, correct_answer, explanation, topics!inner(topic_number)")
    .eq("status", "published")
    .eq("topics.topic_number", topic)
    .limit(20);

  if (error) return NextResponse.json({ questions: [], error: error.message }, { status: 500 });
  return NextResponse.json({
    questions: (data ?? []).map((question) => ({
      id: question.id,
      eyebrow: `${topic} · ${question.question_type} · ${question.marks} mark${question.marks === 1 ? "" : "s"}`,
      blocks: question.stem_blocks,
      options: Array.isArray(question.options)
        ? question.options.map((option: unknown) => typeof option === "string" ? option : String((option as { text?: string }).text ?? ""))
        : [],
      answer: Number(question.correct_answer),
      explanation: question.explanation ?? "",
    })),
  });
}
