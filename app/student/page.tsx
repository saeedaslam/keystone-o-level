"use client";

import Link from "next/link";
import { FormEvent, useEffect, useMemo, useState } from "react";
import { createClient, Session } from "@supabase/supabase-js";

type Attempt = { id: string; mode: string; submitted_at: string; score: number; total_marks: number; exam_papers?: { title: string } | { title: string }[] | null; topics?: { name: string } | { name: string }[] | null };

export default function StudentDashboard() {
  const supabase = useMemo(() => createClient(process.env.NEXT_PUBLIC_SUPABASE_URL ?? "", process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? ""), []);
  const [session, setSession] = useState<Session | null>(null);
  const [attempts, setAttempts] = useState<Attempt[]>([]);
  const [message, setMessage] = useState("");

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setSession(data.session));
    const { data } = supabase.auth.onAuthStateChange((_event, next) => setSession(next));
    return () => data.subscription.unsubscribe();
  }, [supabase]);
  useEffect(() => {
    if (!session) return;
    fetch("/api/attempts", { headers: { authorization: `Bearer ${session.access_token}` } })
      .then((response) => response.json()).then((payload) => setAttempts(payload.attempts ?? []));
  }, [session]);

  async function authenticate(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setMessage("Working…");
    const form = new FormData(event.currentTarget), email = String(form.get("email")), password = String(form.get("password"));
    const submitter = (event.nativeEvent as SubmitEvent).submitter as HTMLButtonElement | null;
    const action = submitter?.value ?? "signin";
    const result = action === "signup" ? await supabase.auth.signUp({ email, password }) : await supabase.auth.signInWithPassword({ email, password });
    setMessage(result.error?.message ?? (action === "signup" && !result.data.session ? "Check your email to confirm your account." : "Signed in."));
  }

  if (!session) return <main className="portal-bg"><section className="portal-login"><span className="portal-logo">K</span><h1>Your Keystone account</h1><p>Sign in to save mock results and build your progress history.</p><form onSubmit={authenticate}><input name="email" type="email" placeholder="Email address" required/><input name="password" type="password" minLength={6} placeholder="Password" required/><div><button name="action" value="signin">Sign in</button><button className="secondary" name="action" value="signup">Create account</button></div></form>{message && <output>{message}</output>}<Link href="/">← Return home</Link></section></main>;

  const answered = attempts.reduce((sum, attempt) => sum + Number(attempt.total_marks || 0), 0);
  const earned = attempts.reduce((sum, attempt) => sum + Number(attempt.score || 0), 0);
  const average = answered ? Math.round((earned / answered) * 100) : 0;
  return <main className="portal-bg"><header className="portal-nav"><Link href="/" className="portal-wordmark"><span>K</span> Keystone</Link><nav><Link href="/mock">Mock exams</Link><button onClick={() => supabase.auth.signOut()}>Sign out</button></nav></header><div className="portal-page"><div className="portal-title"><div><span>STUDENT DASHBOARD</span><h1>Your progress</h1><p>{session.user.email}</p></div><Link className="primary-link" href="/mock">Take a mock exam →</Link></div><section className="dashboard-metrics"><article><span>Completed attempts</span><strong>{attempts.length}</strong></article><article><span>Average score</span><strong>{average}%</strong></article><article><span>Marks practised</span><strong>{answered}</strong></article></section><section className="history-card"><h2>Score history</h2>{attempts.length === 0 ? <div className="empty-state"><h3>No saved results yet</h3><p>Complete a mock exam to start your progress chart.</p><Link href="/mock">Browse mock exams</Link></div> : <div className="attempt-list">{attempts.map((attempt) => { const paper = Array.isArray(attempt.exam_papers) ? attempt.exam_papers[0] : attempt.exam_papers; const topic = Array.isArray(attempt.topics) ? attempt.topics[0] : attempt.topics; const percent = attempt.total_marks ? Math.round(attempt.score / attempt.total_marks * 100) : 0; return <article key={attempt.id}><div><strong>{paper?.title ?? topic?.name ?? "Practice session"}</strong><small>{new Date(attempt.submitted_at).toLocaleDateString()}</small></div><div className="score-bar"><i><em style={{ width: `${percent}%` }}/></i><b>{attempt.score}/{attempt.total_marks} · {percent}%</b></div></article>; })}</div>}</section></div></main>;
}
