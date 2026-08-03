"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { createClient, type Session } from "@supabase/supabase-js";
import { QuestionBlocks } from "@/components/QuestionBlocks";
import type { PracticeQuestion } from "@/lib/questions";

type View = "home" | "practice" | "progress";

const topics = [
  { id: "1", name: "Data representation", color: "#6558F5" },
  { id: "2", name: "Data transmission", color: "#0DAE91" },
  { id: "3", name: "Hardware", color: "#FF8A55" },
  { id: "4", name: "Software", color: "#2D8CFF" },
  { id: "5", name: "The internet", color: "#EB5B72" },
  { id: "6", name: "Automated technologies", color: "#9D68D9" },
  { id: "7", name: "Algorithm design", color: "#EAA923" },
  { id: "8", name: "Programming", color: "#18A6B7" },
  { id: "9", name: "Databases", color: "#6558F5" },
  { id: "10", name: "Boolean logic", color: "#0DAE91" },
];

const fallbackQuestions: PracticeQuestion[] = [
  {
    eyebrow: "9.2 SQL queries · 1 mark",
    blocks: [{ type: "paragraph", text: "Which SQL keyword is used to arrange query results in ascending or descending order?" }],
    options: ["GROUP BY", "ORDER BY", "SORT", "ARRANGE"],
    answer: 1,
    explanation: "ORDER BY sorts the returned records. ASC is the default order; DESC reverses it.",
  },
  {
    eyebrow: "9.1 Database concepts · 2 marks",
    blocks: [{ type: "paragraph", text: "A school stores each student in one row. What is the correct database term for a row?" }],
    options: ["Field", "Record", "Table", "Primary key"],
    answer: 1,
    explanation: "A row is a record. Each value within that record is held in a field.",
  },
  {
    eyebrow: "9.2 SQL queries · 2 marks",
    blocks: [{ type: "paragraph", text: "Which clause filters records before they are returned by a SELECT query?" }],
    options: ["FROM", "WHERE", "ORDER BY", "AS"],
    answer: 1,
    explanation: "WHERE applies a condition, so only matching records appear in the result.",
  },
];

function Icon({ name }: { name: string }) {
  const icons: Record<string, string> = {
    home: "⌂",
    practice: "✦",
    mock: "◷",
    progress: "↗",
    resources: "▤",
    search: "⌕",
    bell: "♢",
    arrow: "→",
    flame: "◆",
  };
  return <span aria-hidden="true">{icons[name]}</span>;
}

export default function Home() {
  const supabase = useMemo(() => createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL ?? "",
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? "",
  ), []);
  const [session, setSession] = useState<Session | null>(null);
  const [view, setView] = useState<View>("home");
  const [practiceOpen, setPracticeOpen] = useState(false);
  const [questionIndex, setQuestionIndex] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const [checked, setChecked] = useState(false);
  const [query, setQuery] = useState("");
  const [questions, setQuestions] = useState<PracticeQuestion[]>(fallbackQuestions);
  const [activeTopic, setActiveTopic] = useState("9");
  const [writtenAnswer, setWrittenAnswer] = useState("");
  const [selfMarked, setSelfMarked] = useState<boolean | null>(null);
  const [loadingQuestions, setLoadingQuestions] = useState(false);
  const [questionError, setQuestionError] = useState("");

  useEffect(() => {
    void supabase.auth.getSession().then(({ data }) => setSession(data.session));
    const { data } = supabase.auth.onAuthStateChange((_event, nextSession) => setSession(nextSession));
    return () => data.subscription.unsubscribe();
  }, [supabase]);

  const accountRole = session?.user.app_metadata?.role === "admin"
    ? "admin"
    : session?.user.app_metadata?.role === "reviewer"
      ? "reviewer"
      : "student";
  const metadata = session?.user.user_metadata;
  const storedName = metadata?.full_name
    || [metadata?.first_name, metadata?.last_name].filter(Boolean).join(" ");
  const accountName = storedName || session?.user.email || "Student account";
  const accountInitial = accountName.charAt(0).toUpperCase() || "K";

  const loadQuestions = useCallback(async (topicId: string) => {
    setLoadingQuestions(true);
    setQuestionError("");
    try {
      const response = await fetch(`/api/questions?topic=${topicId}`);
      const payload = await response.json();
      if (!response.ok) throw new Error(payload?.error || "Questions could not be loaded.");
      setQuestions(payload?.questions ?? []);
    } catch (error) {
      setQuestions([]);
      setQuestionError(error instanceof Error ? error.message : "Questions could not be loaded.");
    } finally {
      setLoadingQuestions(false);
    }
  }, []);

  const filteredTopics = useMemo(
    () => topics.filter((topic) => topic.name.toLowerCase().includes(query.toLowerCase())),
    [query],
  );

  const startPractice = (topicId = "9") => {
    void loadQuestions(topicId);
    setActiveTopic(topicId);
    setView("practice");
    setPracticeOpen(true);
    setQuestionIndex(0);
    setSelected(null);
    setChecked(false);
    setWrittenAnswer("");
    setSelfMarked(null);
  };

  const answer = questions[questionIndex];

  const nextQuestion = () => {
    if (questionIndex < questions.length - 1) {
      setQuestionIndex((value) => value + 1);
      setSelected(null);
      setChecked(false);
      setWrittenAnswer("");
      setSelfMarked(null);
    } else {
      setPracticeOpen(false);
      setView("progress");
    }
  };

  return (
    <main className="app-shell">
      <aside className="sidebar">
        <button className="brand" onClick={() => setView("home")} aria-label="Go to home">
          <span className="brand-mark">K</span>
          <span className="brand-copy"><strong>Keystone</strong><small>O Level Prep</small></span>
        </button>
        <nav aria-label="Main navigation">
          {[
            ["home", "Home"],
            ["practice", "Practice"],
            ["mock", "Mock exams"],
            ["progress", "Progress"],
            ["resources", "Resources"],
          ].map(([id, label]) => (
            <button
              key={id}
              className={(view === id || (id === "mock" && view === "practice")) ? "active" : ""}
              onClick={() => id === "progress" ? window.location.assign("/student") : id === "mock" ? window.location.assign("/mock") : id === "practice" ? setView("practice") : setView("home")}
            >
              <Icon name={id} /><span>{label}</span>
              {id === "practice" && <em>New</em>}
            </button>
          ))}
        </nav>
        <div className="side-bottom">
          {accountRole === "admin" && session && (
            <div className="admin-shortcuts">
              <strong>Administrator</strong>
              <a href="/admin/questions">Content Studio <span>→</span></a>
              <a href="/admin/mocks">Mock Assembly <span>→</span></a>
            </div>
          )}
          <div className="session-card"><div><span>CS</span><p><strong>O Level 2210</strong><small>2026–2028 syllabus</small></p></div></div>
          <button className="profile" onClick={() => window.location.assign("/student")}>
            <span className="avatar">{accountInitial}</span>
            <span><strong>{accountName}</strong><small>{session ? `${accountRole[0].toUpperCase()}${accountRole.slice(1)} account` : "Sign in or view progress"}</small></span>
            <b>→</b>
          </button>
        </div>
      </aside>

      <section className="content">
        <header className="topbar">
          <label className="search"><Icon name="search" /><input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search topics, questions..." /></label>
          <div className="top-actions">
            <a className="points" href={accountRole === "admin" && session ? "/admin/questions" : "/student"}>
              {accountRole === "admin" && session ? "Administrator" : "Account & progress"}
            </a>
            <button className="icon-button" aria-label="Notifications"><Icon name="bell" /><i /></button>
            <span className="subject">CS <b>2210</b></span>
          </div>
        </header>

        {view === "home" && (
          <div className="page">
            <section className="welcome">
              <div>
                <span className="date">THURSDAY, 30 JULY</span>
                <h1>Welcome to Keystone.</h1>
                <p>Practise original questions mapped to the current syllabus.</p>
              </div>
              <div className="streak"><span>2210</span><p><strong>Computer Science</strong><small>Cambridge O Level</small></p></div>
            </section>

            <section className="hero-grid">
              <article className="continue-card">
                <div className="continue-top">
                  <div><span className="pill">CONTINUE PRACTISING</span><h2>Databases</h2><p>9.2 SQL queries</p></div>
                  <div className="completion"><span>47%</span><small>MASTERED</small></div>
                </div>
                <div className="lesson-progress"><i /></div>
                <div className="continue-bottom">
                  <p><span>◉</span><strong>8 min</strong><small>recommended</small></p>
                  <p><span>◇</span><strong>{questions.length || "—"}</strong><small>published questions</small></p>
                  <button onClick={() => startPractice("9")}>Continue <Icon name="arrow" /></button>
                </div>
              </article>
              <article className="mock-card">
                <span className="pill orange">UP NEXT</span>
                <h3>Paper 1: Theory</h3>
                <p>Full timed mock · 1 hr 45 min</p>
                <div className="mock-stats"><span><b>75</b><small>target marks</small></span><span><b>Draft</b><small>bank expanding</small></span><span><b>105</b><small>minutes</small></span></div>
                <button onClick={() => window.location.assign("/mock")}>View mock exam <Icon name="arrow" /></button>
              </article>
            </section>

            <section className="section-heading">
              <div><h2>Your topics</h2><p>Cambridge O Level Computer Science (2210)</p></div>
              <button onClick={() => setView("practice")}>View all topics <Icon name="arrow" /></button>
            </section>
            <div className="topic-grid">
              {filteredTopics.slice(0, 5).map((topic) => (
                <button className="topic-card" key={topic.id} onClick={() => startPractice(topic.id)}>
                  <span className="topic-number" style={{ background: topic.color }}>{topic.id}</span>
                  <span className="topic-info"><strong>{topic.name}</strong><small>Syllabus-mapped practice</small></span>
                  <span className="topic-score"><b>Open</b></span>
                </button>
              ))}
            </div>
            <section className="insight">
              <div className="insight-icon">◎</div>
              <div><span>YOUR WEEKLY INSIGHT</span><h3>You’re strongest in Boolean logic.</h3><p>Database queries need a little more attention. Two short sessions this week could lift your mastery above 60%.</p></div>
              <button onClick={() => startPractice("9")}>Practise databases <Icon name="arrow" /></button>
            </section>
          </div>
        )}

        {view === "practice" && !practiceOpen && (
          <div className="page">
            <section className="practice-head">
              <span className="date">PRACTICE LIBRARY</span><h1>Choose what to strengthen.</h1>
              <p>Fresh, original questions mapped to the Cambridge O Level Computer Science syllabus.</p>
            </section>
            <div className="all-topic-grid">
              {filteredTopics.map((topic) => (
                <button className="large-topic" key={topic.id} onClick={() => startPractice(topic.id)}>
                  <span className="topic-number" style={{ background: topic.color }}>{topic.id}</span>
                  <div><strong>{topic.name}</strong><small>Open published practice questions</small></div>
                  <span className="go">→</span>
                </button>
              ))}
            </div>
          </div>
        )}

        {view === "progress" && <div className="page"><section className="practice-head"><span className="date">YOUR PROGRESS</span><h1>Your real results live in your account.</h1><p>Sign in to view completed attempts, average score, and marks practised.</p><a className="primary-link" href="/student">Open student dashboard →</a></section></div>}

        {practiceOpen && (
          <div className="practice-overlay">
            <div className="quiz-top">
              <button onClick={() => setPracticeOpen(false)}>×</button>
              <div><strong>{topics.find((topic) => topic.id === activeTopic)?.name}</strong><span>{questions.length ? `${questionIndex + 1} of ${questions.length}` : "Topic practice"}</span></div>
              <div className="quiz-progress"><i style={{ width: `${questions.length ? ((questionIndex + 1) / questions.length) * 100 : 0}%` }} /></div>
            </div>
            {loadingQuestions ? <article className="question-card empty-practice"><h2>Loading questions…</h2></article> : questionError ? <article className="question-card empty-practice"><h2>Questions could not be loaded.</h2><p>{questionError}</p><button className="check" onClick={() => void loadQuestions(activeTopic)}>Try again</button></article> : !answer ? <article className="question-card empty-practice"><h2>No published questions yet.</h2><p>This topic is ready in the syllabus. Add original questions in the <a href="/admin/questions">Content Studio</a>, then publish them.</p></article> : <article className="question-card">
              <span>{answer.eyebrow}</span>
              <QuestionBlocks blocks={answer.blocks} />
              {(answer.questionType ?? "mcq") === "mcq" ? <div className="options">
                {answer.options.map((option, index) => (
                  <button
                    key={option}
                    className={`${selected === index ? "selected" : ""} ${checked && index === answer.answer ? "correct" : ""} ${checked && selected === index && index !== answer.answer ? "wrong" : ""}`}
                    onClick={() => !checked && setSelected(index)}
                  ><b>{String.fromCharCode(65 + index)}</b>{option}</button>
                ))}
              </div> : <div className="written-response"><label>Your answer<textarea value={writtenAnswer} onChange={(event) => setWrittenAnswer(event.target.value)} disabled={checked} placeholder="Write your answer here…" /></label></div>}
              {checked && (answer.questionType ?? "mcq") === "mcq" && <div className="feedback"><strong>{selected === answer.answer ? "That’s right." : "Not quite yet."}</strong><p>{answer.explanation}</p></div>}
              {checked && answer.questionType !== "mcq" && <div className="self-mark"><h3>Mark your response</h3>{answer.modelAnswer != null && <p><strong>Model answer:</strong> {String(answer.modelAnswer)}</p>}<ul>{answer.markScheme?.map((point, index) => <li key={index}>{typeof point === "string" ? point : point.point}</li>)}</ul><div><button className={selfMarked === true ? "chosen" : ""} onClick={() => setSelfMarked(true)}>I earned the marks</button><button className={selfMarked === false ? "chosen" : ""} onClick={() => setSelfMarked(false)}>Needs more work</button></div></div>}
              <button className="check" disabled={(!checked && ((answer.questionType ?? "mcq") === "mcq" ? selected === null : !writtenAnswer.trim())) || (checked && answer.questionType !== "mcq" && selfMarked === null)} onClick={() => checked ? nextQuestion() : setChecked(true)}>{checked ? (questionIndex === questions.length - 1 ? "Finish practice" : "Next question") : answer.questionType === "mcq" ? "Check answer" : "Show mark scheme"} <Icon name="arrow" /></button>
            </article>}
          </div>
        )}
      </section>
    </main>
  );
}
