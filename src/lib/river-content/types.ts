// Editorial notes written for each river page. These sit alongside the
// structured fields in ../data.ts and are rendered in the "In depth" section.

export interface RiverEditorial {
  /** One or two short paragraphs on the river's character and history. */
  overview: string[];
  /** The river's journey, naming the main places it passes. */
  course: string;
  /** Wildlife the river is known for and where to see it. */
  wildlife: string;
  /** What people actually do here, with named places. */
  outdoors: string;
  /** Three practical, safety-minded tips. */
  planning: string[];
  /** Three short facts. */
  facts: string[];
  /** Main tributaries, where known. */
  tributaries?: string[];
}
