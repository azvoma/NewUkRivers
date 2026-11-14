import type { RiverEditorial } from './types';
import { englandSouth } from './england-south';
import { englandNorth } from './england-north';
import { scotland } from './scotland';
import { walesNi } from './wales-ni';

export type { RiverEditorial } from './types';

export const riverContent: Record<string, RiverEditorial> = {
  ...englandSouth,
  ...englandNorth,
  ...scotland,
  ...walesNi,
};

export function getRiverContent(slug: string): RiverEditorial | undefined {
  return riverContent[slug];
}

export function editorialWordCount(slug: string): number {
  const c = riverContent[slug];
  if (!c) return 0;
  const text = [...c.overview, c.course, c.wildlife, c.outdoors, ...c.planning, ...c.facts].join(' ');
  return text.trim().split(/\s+/).filter(Boolean).length;
}
