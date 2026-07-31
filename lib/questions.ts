export type ContentBlock =
  | { type: "paragraph"; text: string }
  | { type: "image"; url: string; alt: string; caption?: string }
  | { type: "table"; caption?: string; headers: string[]; rows: string[][] }
  | { type: "code"; language?: string; code: string }
  | { type: "list"; style?: "ordered" | "unordered"; items: string[] };

export type PracticeQuestion = {
  id?: string;
  eyebrow: string;
  blocks: ContentBlock[];
  options: string[];
  answer: number;
  explanation: string;
  questionType?: "mcq" | "structured" | "sql" | "pseudocode";
  marks?: number;
  markScheme?: Array<{ mark?: number; point?: string } | string>;
  modelAnswer?: unknown;
};
