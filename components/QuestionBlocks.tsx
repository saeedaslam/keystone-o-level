import type { ContentBlock } from "@/lib/questions";

export function QuestionBlocks({ blocks }: { blocks: ContentBlock[] }) {
  return (
    <div className="question-blocks">
      {blocks.map((block, index) => {
        if (block.type === "paragraph") return <p key={index}>{block.text}</p>;
        if (block.type === "image") return (
          <figure key={index}>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={block.url} alt={block.alt} loading="lazy" />
            {block.caption && <figcaption>{block.caption}</figcaption>}
          </figure>
        );
        if (block.type === "table") return (
          <figure className="question-table" key={index}>
            {block.caption && <figcaption>{block.caption}</figcaption>}
            <div className="table-scroll"><table>
              <thead><tr>{block.headers.map((header) => <th key={header}>{header}</th>)}</tr></thead>
              <tbody>{block.rows.map((row, rowIndex) => <tr key={rowIndex}>{row.map((cell, cellIndex) => <td key={cellIndex}>{cell}</td>)}</tr>)}</tbody>
            </table></div>
          </figure>
        );
        if (block.type === "code") return <pre key={index}><code>{block.code}</code></pre>;
        const List = block.style === "ordered" ? "ol" : "ul";
        return <List key={index}>{block.items.map((item) => <li key={item}>{item}</li>)}</List>;
      })}
    </div>
  );
}
