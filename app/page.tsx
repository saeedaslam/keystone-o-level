"use client";

import { useEffect, useMemo, useState } from "react";
import { QuestionBlocks } from "@/components/QuestionBlocks";
import type { PracticeQuestion } from "@/lib/questions";

type View = "home" | "practice" | "progress";

const topics = [
  { id: "1", name: "Data representation", score: 82, questions: 34, color: "#6558F5" },
  { id: "2", name: "Data transmission", score: 71, questions: 28, color: "#0DAE91" },
  { id: "3", name: "Hardware", score: 64, questions: 42, color: "#FF8A55" },
  { id: "4", name: "Software", score: 76, questions: 31, color: "#2D8CFF" },
  { id: "5", name: "The internet", score: 58, questions: 26, color: "#EB5B72" },
  { id: "6", name: "Automated technologies", score: 0, questions: 22, color: "#9D68D9" },
  { id: "7", name: "Algorithm design", score: 68, questions: 45, color: "#EAA923" },
  { id: "8", name: "Programming", score: 73, questions: 51, color: "#18A6B7" },
  { id: "9", name: "Databases", score: 47, questions: 38, color: "#6558F5" },
  { id: "10", name: "Boolean logic", score: 90, questions: 29, color: "#0DAE91" },
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
  const [view, setView] = useState<View>("home");
  const [practiceOpen, setPracticeOpen] = useState(false);
  const [questionIndex, setQuestionIndex] = useState(0);
  const [selected, setSelected] = useState<number | null>(null);
  const [checked, setChecked] = useState(false);
  const [points, setPoints] = useState(1240);
  const [query, setQuery] = useState("");
  const [questions, setQuestions] = useState<PracticeQuestion[]>(fallbackQuestions);
  const [activeTopic, setActiveTopic] = useState("9");
  const [writtenAnswer, setWrittenAnswer] = useState("");
  const [selfMarked, setSelfMarked] = useState<boolean | null>(null);
  const [loadingQuestions, setLoadingQuestions] = useState(false);

  useEffect(() => {
    fetch(`/api/questions?topic=${activeTopic}`)
      .then((response) => response.ok ? response.json() : null)
      .then((payload) => {
        setQuestions(payload?.questions ?? []);
      })
      .catch(() => setQuestions(activeTopic === "9" ? fallbackQuestions : []))
      .finally(() => setLoadingQuestions(false));
  }, [activeTopic]);

  const filteredTopics = useMemo(
    () => topics.filter((topic) => topic.name.toLowerCase().includes(query.toLowerCase())),
    [query],
  );

  const startPractice = (topicId = "9") => {
    setLoadingQuestions(true);
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
    if (checked && (answer.questionType === "mcq" ? selected === answer.answer : selfMarked)) setPoints((value) => value + 10);
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
          <div className="session-card">
            <div><span>MJ</span><p><strong>May/June</strong><small>2027 session</small></p></div>
            <div className="session-progress"><i /></div>
            <small>286 days to go</small>
          </div>
          <button className="profile">
            <span className="avatar">AS</span>
            <span><strong>Alex Smith</strong><small>Student</small></span>
            <b>•••</b>
          </button>
        </div>
      </aside>

      <section className="content">
        <header className="topbar">
          <label className="search"><Icon name="search" /><input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search topics, questions..." /></label>
          <div className="top-actions">
            <span className="points"><Icon name="flame" /> {points.toLocaleString()} pts</span>
            <button className="icon-button" aria-label="Notifications"><Icon name="bell" /><i /></button>
            <span className="subject">CS <b>2210</b></span>
          </div>
        </header>

        {view === "home" && (
          <div className="page">
            <section className="welcome">
              <div>
                <span className="date">THURSDAY, 30 JULY</span>
                <h1>Good afternoon, Alex.</h1>
                <p>Small steps, strong results. Let’s make today count.</p>
              </div>
              <div className="streak"><span>12</span><p><strong>day streak</strong><small>Personal best: 18 days</small></p></div>
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
                  <p><span>◇</span><strong>10</strong><small>questions</small></p>
                  <button onClick={() => startPractice("9")}>Continue <Icon name="arrow" /></button>
                </div>
              </article>
              <article className="mock-card">
                <span className="pill orange">UP NEXT</span>
                <h3>Paper 1: Theory</h3>
                <p>Full timed mock · 1 hr 45 min</p>
                <div className="mock-stats"><span><b>75</b><small>marks</small></span><span><b>15</b><small>questions</small></span><span><b>Ready</b><small>difficulty</small></span></div>
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
                  <span className="topic-info"><strong>{topic.name}</strong><small>{topic.questions} original questions</small></span>
                  <span className="topic-score"><b>{topic.score ? `${topic.score}%` : "Start"}</b><i><em style={{ width: `${topic.score}%`, background: topic.color }} /></i></span>
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
                  <div><strong>{topic.name}</strong><small>{topic.questions} questions · {topic.score ? `${topic.score}% mastered` : "Not started"}</small></div>
                  <span className="go">→</span>
                </button>
              ))}
            </div>
          </div>
        )}

        {view === "progress" && (
          <div className="page">
            <section className="practice-head"><span className="date">YOUR PROGRESS</span><h1>Momentum you can see.</h1><p>Your recent practice is moving the right topics in the right direction.</p></section>
            <div className="metric-row">
              <article><span>Questions answered</span><strong>186</strong><small>↑ 28 this week</small></article>
              <article><span>Average score</span><strong>72%</strong><small>↑ 6% this month</small></article>
              <article><span>Topics mastered</span><strong>3/10</strong><small>2 close to mastery</small></article>
            </div>
            <article className="chart-card">
              <div><h2>Mastery by topic</h2><span>Last 30 days</span></div>
              {topics.slice(0, 6).map((topic) => <p key={topic.id}><label>{topic.name}</label><i><em style={{ width: `${topic.score}%`, background: topic.color }} /></i><b>{topic.score}%</b></p>)}
            </article>
          </div>
        )}

        {practiceOpen && (
          <div className="practice-overlay">
            <div className="quiz-top">
              <button onClick={() => setPracticeOpen(false)}>×</button>
              <div><strong>{topics.find((topic) => topic.id === activeTopic)?.name}</strong><span>{questions.length ? `${questionIndex + 1} of ${questions.length}` : "Topic practice"}</span></div>
              <div className="quiz-progress"><i style={{ width: `${questions.length ? ((questionIndex + 1) / questions.length) * 100 : 0}%` }} /></div>
            </div>
            {loadingQuestions ? <article className="question-card empty-practice"><h2>Loading questions…</h2></article> : !answer ? <article className="question-card empty-practice"><h2>No published questions yet.</h2><p>This topic is ready in the syllabus. Add original questions in the <a href="/admin/questions">Content Studio</a>, then publish them.</p></article> : <article className="question-card">
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
