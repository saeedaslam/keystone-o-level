"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useMemo, useState } from "react";
import { createClient, Session } from "@supabase/supabase-js";
import { QuestionBlocks } from "@/components/QuestionBlocks";
import type { ContentBlock } from "@/lib/questions";

type Paper = { id: string; title: string; paper_number: number; description: string; duration_minutes: number; total_marks: number };
type ExamQuestion = { id: string; position: number; question_type: string; marks: number; stem_blocks: ContentBlock[]; options: string[]; syllabus_objectives?: { code: string } | { code: string }[] };

export default function TimedMock() {
  const id = String(useParams<{ id: string }>().id);
  const supabase = useMemo(() => createClient(process.env.NEXT_PUBLIC_SUPABASE_URL ?? "", process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? ""), []);
  const [session, setSession] = useState<Session | null>(null), [paper, setPaper] = useState<Paper | null>(null);
  const [questions, setQuestions] = useState<ExamQuestion[]>([]), [answers, setAnswers] = useState<Record<string, number | string>>({});
  const [remaining, setRemaining] = useState<number | null>(null), [startedAt, setStartedAt] = useState("");
  const [result, setResult] = useState<{ score: number; total_marks: number } | null>(null), [message, setMessage] = useState("");

  useEffect(() => { supabase.auth.getSession().then(({ data }) => setSession(data.session)); }, [supabase]);
  useEffect(() => { fetch(`/api/mock-exams/${id}`).then((r) => r.json()).then((payload) => { setPaper(payload.paper); setQuestions(payload.questions ?? []); if (payload.paper) setRemaining(payload.paper.duration_minutes * 60); }); }, [id]);

  const submitExam = useCallback(async () => {
    if (result || !session || !paper) return;
    setMessage("Submitting…");
    const response = await fetch("/api/attempts", { method: "POST", headers: { "content-type": "application/json", authorization: `Bearer ${session.access_token}` }, body: JSON.stringify({ paperId: paper.id, answers, startedAt }) });
    const payload = await response.json();
    if (response.ok) { setResult(payload.attempt); setMessage(""); } else setMessage(payload.error);
  }, [answers, paper, result, session, startedAt]);

  useEffect(() => {
    if (!startedAt || result) return;
    const timer = window.setInterval(() => setRemaining((value) => {
      if (value === null || value <= 0) return 0;
      if (value === 1) window.setTimeout(() => submitExam(), 0);
      return value - 1;
    }), 1000);
    return () => window.clearInterval(timer);
  }, [result, startedAt, submitExam]);

  if (!paper) return <main className="portal-bg"><section className="portal-login"><h1>Loading exam…</h1></section></main>;
  if (!session) return <main className="portal-bg"><section className="portal-login"><span className="portal-logo">K</span><h1>Sign in before starting</h1><p>Your timer and result need to be attached to your student account.</p><Link className="primary-link" href="/student">Sign in or create account</Link><Link href="/mock">← Back to mock exams</Link></section></main>;
  if (!startedAt) return <main className="portal-bg"><section className="exam-intro"><span>Paper {paper.paper_number}</span><h1>{paper.title}</h1><p>{paper.description}</p><div><b>{paper.duration_minutes} minutes</b><b>{questions.length} questions</b><b>{paper.total_marks} marks</b></div><ul><li>The timer cannot be paused after you begin.</li><li>Answer every question before submitting.</li><li>Your result will be saved to your dashboard.</li></ul><button onClick={() => setStartedAt(new Date().toISOString())}>Begin exam</button><Link href="/mock">Not yet — return to library</Link></section></main>;
  if (result) return <main className="portal-bg"><section className="exam-result"><span>EXAM COMPLETE</span><h1>{result.score}/{result.total_marks}</h1><p>{Math.round(result.score / result.total_marks * 100)}% — your result is saved.</p><div><Link className="primary-link" href="/student">View progress dashboard</Link><Link href="/mock">Choose another exam</Link></div></section></main>;

  const minutes = Math.floor((remaining ?? 0) / 60), seconds = (remaining ?? 0) % 60;
  return <main className="exam-shell"><header><div><Link href="/mock">×</Link><strong>{paper.title}</strong></div><time className={(remaining ?? 0) < 300 ? "urgent" : ""}>{minutes}:{String(seconds).padStart(2, "0")}</time><button onClick={submitExam}>Submit exam</button></header><div className="exam-body"><aside><span>QUESTIONS</span>{questions.map((question) => <a key={question.id} href={`#question-${question.id}`} className={answers[question.id] !== undefined ? "answered" : ""}>{question.position}</a>)}</aside><section>{questions.map((question) => { const objective = Array.isArray(question.syllabus_objectives) ? question.syllabus_objectives[0] : question.syllabus_objectives; return <article className="exam-question" id={`question-${question.id}`} key={question.id}><div><span>Question {question.position} · {objective?.code}</span><b>{question.marks} mark{question.marks === 1 ? "" : "s"}</b></div><QuestionBlocks blocks={question.stem_blocks}/>{question.question_type === "mcq" ? <div className="exam-options">{question.options.map((option, index) => <button className={answers[question.id] === index ? "selected" : ""} key={index} onClick={() => setAnswers((current) => ({ ...current, [question.id]: index }))}><b>{String.fromCharCode(65 + index)}</b>{option}</button>)}</div> : <textarea value={String(answers[question.id] ?? "")} onChange={(event) => setAnswers((current) => ({ ...current, [question.id]: event.target.value }))} placeholder="Write your answer…"/>}</article>; })}{message && <output className="exam-message">{message}</output>}</section></div></main>;
}
