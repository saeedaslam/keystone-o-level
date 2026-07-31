"use client";

import Link from "next/link";
import { useEffect, useState } from "react";

type Paper = { id: string; paper_number: number; title: string; description: string; duration_minutes: number; total_marks: number; exam_paper_questions: { count: number }[] };

export default function MockLibrary() {
  const [papers, setPapers] = useState<Paper[]>([]);
  useEffect(() => { fetch("/api/mock-exams").then((r) => r.json()).then((payload) => setPapers(payload.papers ?? [])); }, []);
  return <main className="portal-bg"><header className="portal-nav"><Link href="/" className="portal-wordmark"><span>K</span> Keystone</Link><nav><Link href="/student">Progress</Link></nav></header><div className="portal-page"><div className="portal-title"><div><span>TIMED PRACTICE</span><h1>Mock exams</h1><p>Original, syllabus-mapped papers with a visible countdown and saved results.</p></div></div><div className="paper-grid">{papers.map((paper) => <article key={paper.id}><span>Paper {paper.paper_number}</span><h2>{paper.title}</h2><p>{paper.description}</p><div><b>{paper.duration_minutes} min</b><b>{paper.total_marks} marks</b><b>{paper.exam_paper_questions?.[0]?.count ?? 0} questions</b></div><Link href={`/mock/${paper.id}`}>Start timed exam →</Link></article>)}</div>{papers.length === 0 && <section className="empty-state"><h3>No published papers yet</h3><p>Assemble and publish a paper after the original question bank is reviewed.</p></section>}</div></main>;
}
