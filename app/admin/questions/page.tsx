"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { createClient, Session } from "@supabase/supabase-js";
import { QuestionBlocks } from "@/components/QuestionBlocks";
import type { ContentBlock } from "@/lib/questions";
import "./admin.css";

type Objective = { id: string; code: string; objective: string };
type Subtopic = { id: string; code: string; title: string; objectives: Objective[] };
type Topic = { id: string; number: string; name: string; subtopics: Subtopic[] };

const exampleBlocks = JSON.stringify([{ type: "paragraph", text: "Write the question here." }], null, 2);
const exampleScheme = JSON.stringify([{ mark: 1, point: "Award one mark for the correct point." }], null, 2);

export default function QuestionAdminPage() {
  const [session, setSession] = useState<Session | null>(null);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [topicId, setTopicId] = useState("");
  const [objectiveId, setObjectiveId] = useState("");
  const [kind, setKind] = useState("mcq");
  const [blocks, setBlocks] = useState(exampleBlocks);
  const [scheme, setScheme] = useState(exampleScheme);
  const [options, setOptions] = useState("Option A\nOption B\nOption C\nOption D");
  const [correct, setCorrect] = useState("1");
  const [message, setMessage] = useState("");

  const supabase = useMemo(() => createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL ?? "",
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? "",
  ), []);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setSession(data.session));
    const { data } = supabase.auth.onAuthStateChange((_event, next) => setSession(next));
    fetch("/api/syllabus").then((r) => r.json()).then((payload) => {
      setTopics(payload.topics ?? []);
      if (payload.topics?.[0]) {
        setTopicId(payload.topics[0].id);
        setObjectiveId(payload.topics[0].subtopics?.[0]?.objectives?.[0]?.id ?? "");
      }
    });
    return () => data.subscription.unsubscribe();
  }, [supabase]);

  const topic = topics.find((item) => item.id === topicId);

  async function signIn(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const values = new FormData(event.currentTarget);
    const { error } = await supabase.auth.signInWithPassword({ email: String(values.get("email")), password: String(values.get("password")) });
    setMessage(error?.message ?? "Signed in.");
  }

  async function save(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setMessage("Saving…");
    try {
      const values = new FormData(event.currentTarget);
      const response = await fetch("/api/admin/questions", {
        method: "POST", headers: { "content-type": "application/json", authorization: `Bearer ${session?.access_token}` },
        body: JSON.stringify({
          topicId, objectiveId, questionType: kind, marks: Number(values.get("marks")), difficulty: values.get("difficulty"),
          status: values.get("status"), stemBlocks: JSON.parse(blocks), markScheme: JSON.parse(scheme),
          options: options.split("\n").map((value) => value.trim()).filter(Boolean), correctAnswer: Number(correct) - 1,
          explanation: values.get("explanation"), modelAnswer: values.get("modelAnswer"),
        }),
      });
      const payload = await response.json();
      setMessage(response.ok ? `Saved question ${payload.question.id}.` : payload.error);
    } catch (error) { setMessage(error instanceof Error ? error.message : "Could not save question."); }
  }

  let preview: ContentBlock[] = [];
  try { preview = JSON.parse(blocks); } catch { /* show validation on save */ }

  if (!session) return <main className="admin-shell"><section className="admin-login"><span className="admin-brand">K</span><h1>Content studio</h1><p>Sign in with a Supabase administrator account.</p><form onSubmit={signIn}><input name="email" type="email" placeholder="Email" required/><input name="password" type="password" placeholder="Password" required/><button>Sign in</button></form>{message && <output>{message}</output>}<Link href="/">← Back to practice</Link></section></main>;

  return <main className="admin-shell"><header className="admin-top"><div><span className="admin-brand">K</span><strong>Keystone Content Studio</strong></div><div><small>{session.user.email}</small><button onClick={() => supabase.auth.signOut()}>Sign out</button></div></header><div className="admin-grid">
    <form className="author-form" onSubmit={save}><div className="form-heading"><div><span>QUESTION AUTHORING</span><h1>Create an original question</h1></div><Link href="/">Open student view →</Link></div>
      <section><h2>1. Syllabus mapping</h2><div className="field-grid"><label>Topic<select value={topicId} onChange={(e) => { const next = topics.find((item) => item.id === e.target.value); setTopicId(e.target.value); setObjectiveId(next?.subtopics[0]?.objectives[0]?.id ?? ""); }}>{topics.map((item) => <option key={item.id} value={item.id}>{item.number}. {item.name}</option>)}</select></label><label>Learning objective<select value={objectiveId} onChange={(e) => setObjectiveId(e.target.value)}>{topic?.subtopics.map((subtopic) => <optgroup key={subtopic.id} label={`${subtopic.code} ${subtopic.title}`}>{subtopic.objectives.map((item) => <option key={item.id} value={item.id}>{item.code} — {item.objective}</option>)}</optgroup>)}</select></label></div></section>
      <section><h2>2. Question settings</h2><div className="field-grid four"><label>Type<select value={kind} onChange={(e) => setKind(e.target.value)}><option value="mcq">MCQ</option><option value="structured">Structured</option><option value="sql">SQL</option><option value="pseudocode">Pseudocode</option></select></label><label>Marks<input name="marks" type="number" min="1" max="20" defaultValue="1"/></label><label>Difficulty<select name="difficulty"><option value="foundation">Foundation</option><option value="core">Core</option><option value="extended">Extended</option></select></label><label>Status<select name="status"><option value="draft">Draft</option><option value="reviewed">Reviewed</option><option value="published">Published</option></select></label></div></section>
      <section><h2>3. Content blocks</h2><p className="hint">Use ordered JSON blocks. Supported types: paragraph, table, image, code and list.</p><textarea className="json-editor" value={blocks} onChange={(e) => setBlocks(e.target.value)} spellCheck={false}/></section>
      {kind === "mcq" && <section><h2>4. Answer options</h2><label>One option per line<textarea value={options} onChange={(e) => setOptions(e.target.value)}/></label><label>Correct option number<input value={correct} onChange={(e) => setCorrect(e.target.value)} type="number" min="1"/></label></section>}
      <section><h2>{kind === "mcq" ? "5" : "4"}. Marking</h2><label>Mark scheme JSON<textarea className="json-editor short" value={scheme} onChange={(e) => setScheme(e.target.value)} spellCheck={false}/></label><label>Model answer<textarea name="modelAnswer" placeholder="A concise model answer for structured questions."/></label><label>Explanation<textarea name="explanation" placeholder="Explain why the answer is correct."/></label></section>
      <footer><output>{message}</output><button className="save-question">Save question</button></footer>
    </form>
    <aside className="preview-panel"><span>LIVE PREVIEW</span><article><small>{topic?.number} · {kind}</small><QuestionBlocks blocks={preview}/>{kind === "mcq" && options.split("\n").filter(Boolean).map((option, index) => <p className="preview-option" key={index}><b>{String.fromCharCode(65 + index)}</b>{option}</p>)}</article></aside>
  </div></main>;
}
