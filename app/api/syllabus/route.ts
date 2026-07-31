import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

export async function GET() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  if (!url || !key) return NextResponse.json({ topics: [] });
  const supabase = createClient(url, key, { auth: { persistSession: false } });
  const { data, error } = await supabase
    .from("syllabus_subtopics")
    .select("id, code, title, sort_order, topics!inner(id, topic_number, name), syllabus_objectives(id, code, objective, sort_order)")
    .order("sort_order");
  if (error) return NextResponse.json({ topics: [], error: error.message }, { status: 500 });

  type Topic = { id: string; number: string; name: string; subtopics: unknown[] };
  const grouped = new Map<string, Topic>();
  for (const row of data ?? []) {
    const topic = Array.isArray(row.topics) ? row.topics[0] : row.topics;
    if (!topic) continue;
    const current: Topic = grouped.get(topic.id) ?? { id: topic.id, number: topic.topic_number, name: topic.name, subtopics: [] };
    current.subtopics.push({ id: row.id, code: row.code, title: row.title, objectives: [...(row.syllabus_objectives ?? [])].sort((a, b) => a.sort_order - b.sort_order) });
    grouped.set(topic.id, current);
  }
  return NextResponse.json({ topics: [...grouped.values()].sort((a, b) => Number(a.number) - Number(b.number)) });
}
