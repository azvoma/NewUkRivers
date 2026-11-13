// Trust, sourcing and answer-block helpers shared by river pages.
// Edit CONTENT_UPDATED only when river content changes substantially:
// it drives both the visible "Last updated" date and schema.org dateModified.

import type { River } from './data';

export const SITE_NAME = 'UK Rivers Directory';
export const CONTENT_UPDATED = '2026-11-13';
export const CORRECTIONS_EMAIL = 'ukrivers@anoziva.com';

export const EDITOR = {
  name: 'Andrew Zvoma',
  jobTitle: 'Founder and editor',
};

export function formatDisplayDate(iso: string): string {
  return new Date(`${iso}T00:00:00Z`).toLocaleDateString('en-GB', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    timeZone: 'UTC',
  });
}

export function correctionMailto(subject: string): string {
  return `mailto:${CORRECTIONS_EMAIL}?subject=${encodeURIComponent(subject)}`;
}

export interface Source {
  label: string;
  url: string;
}

export interface RegionGuidance {
  regulator: string;
  regulatorUrl: string;
  floodLabel: string;
  floodUrl: string;
  fishingSummary: string;
  fishingSource: Source;
}

const englandWales: Omit<RegionGuidance, 'regulator' | 'regulatorUrl' | 'floodLabel' | 'floodUrl'> = {
  fishingSummary:
    'Anglers aged 13 or over need a rod fishing licence for England and Wales to fish for salmon, trout, freshwater fish or eels with a rod and line. You also need permission from the land or fishery owner, usually a fishing permit.',
  fishingSource: { label: 'GOV.UK: Buy a rod fishing licence', url: 'https://www.gov.uk/fishing-licences' },
};

export const regionGuidance: Record<string, RegionGuidance> = {
  England: {
    regulator: 'Environment Agency',
    regulatorUrl: 'https://www.gov.uk/government/organisations/environment-agency',
    floodLabel: 'Environment Agency flood warnings',
    floodUrl: 'https://check-for-flooding.service.gov.uk/',
    ...englandWales,
  },
  Wales: {
    regulator: 'Natural Resources Wales',
    regulatorUrl: 'https://naturalresources.wales/',
    floodLabel: 'Natural Resources Wales',
    floodUrl: 'https://naturalresources.wales/',
    ...englandWales,
  },
  Scotland: {
    regulator: 'SEPA (Scottish Environment Protection Agency)',
    regulatorUrl: 'https://www.sepa.org.uk/',
    floodLabel: 'SEPA',
    floodUrl: 'https://www.sepa.org.uk/',
    fishingSummary:
      'Scotland has no licence for recreational fishing, but you must have permission from whoever holds the fishing rights, and you must follow the conditions of any permit you are given.',
    fishingSource: {
      label: 'Scottish Government: recreational fishing',
      url: 'https://www.gov.scot/policies/salmon-and-recreational-fisheries/recreational-fishing/',
    },
  },
  'Northern Ireland': {
    regulator: 'DAERA (Department of Agriculture, Environment and Rural Affairs)',
    regulatorUrl: 'https://www.daera-ni.gov.uk/',
    floodLabel: 'DAERA',
    floodUrl: 'https://www.daera-ni.gov.uk/',
    fishingSummary:
      'To fish legally in Northern Ireland you need a rod licence plus a permit or day ticket. The licence must be issued in Northern Ireland, by DAERA or, in its area, the Loughs Agency.',
    fishingSource: {
      label: 'nidirect: angling licences and permits',
      url: 'https://www.nidirect.gov.uk/articles/angling-licences-and-permits',
    },
  },
};

// The Tweed sits outside the Environment Agency rod licence system.
const tweedGuidance: Pick<RegionGuidance, 'fishingSummary' | 'fishingSource'> = {
  fishingSummary:
    'The River Tweed is excluded from the Environment Agency rod licence for England and Wales, so you do not need that licence here. You do still need permission from the owner of the fishing rights before you fish.',
  fishingSource: { label: 'GOV.UK: Buy a rod fishing licence', url: 'https://www.gov.uk/fishing-licences' },
};

export function fishingGuidanceFor(river: River): Pick<RegionGuidance, 'fishingSummary' | 'fishingSource'> {
  if (river.slug === 'river-tweed') return tweedGuidance;
  return (regionGuidance[river.region] || regionGuidance.England);
}

export function guidanceFor(region: string): RegionGuidance {
  return regionGuidance[region] || regionGuidance.England;
}

export const waterQualitySources: Source[] = [
  { label: 'The Rivers Trust Sewage Map', url: 'https://www.theriverstrust.org/key-issues/sewage-in-rivers' },
  { label: 'Surfers Against Sewage: Safer Seas & Rivers Service', url: 'https://www.sas.org.uk/safer-seas-service' },
];

export const englandClassificationSource: Source = {
  label: 'Environment Agency Catchment Data Explorer',
  url: 'https://environment.data.gov.uk/catchment-planning',
};

// ---------------------------------------------------------------------------
// Answer block: a self-contained 40-60 word answer built only from the
// river's own data fields, so nothing is invented.
// ---------------------------------------------------------------------------

const wordCount = (s: string) => s.trim().split(/\s+/).filter(Boolean).length;

function joinList(items: string[]): string {
  if (items.length <= 1) return items.join('');
  return `${items.slice(0, -1).join(', ')} and ${items[items.length - 1]}`;
}

function firstSentence(text: string): string {
  const s = (text || '').trim();
  const m = s.match(/^.*?[.!?](\s|$)/);
  return (m ? m[0] : s).trim().replace(/[.!?]+$/, '');
}

export function buildAnswerBlock(river: River): string {
  const length = river.length_miles && river.length_km
    ? `${river.length_miles}-mile (${river.length_km} km) `
    : '';
  const course = river.origin && river.mouth
    ? ` It rises at ${river.origin}; its mouth is at ${river.mouth}.`
    : river.origin
    ? ` It rises at ${river.origin}.`
    : '';
  const article = river.length_miles && /^(8|11|18)/.test(String(river.length_miles)) ? 'an' : 'a';
  const s1 = `The ${river.name} is ${article} ${length}river in ${river.region}.${course}`;

  const acts = (river.activities || []).map((a) => a.toLowerCase());
  const s2 = (n: number) => acts.length ? ` Popular activities include ${joinList(acts.slice(0, n))}.` : '';

  const swim = firstSentence(river.swimming_safety);
  const s3 = swim ? ` Swimming advice: ${swim}.` : '';

  const wild = (river.wildlife || []).slice(0, 3);
  const s4 = wild.length ? ` Wildlife includes ${joinList(wild.map((w) => w.toLowerCase()))}.` : '';

  const candidates = [
    s1 + s2(4) + s3,
    s1 + s2(3) + s3,
    s1 + s2(4) + s3 + s4,
    s1 + s2(3) + s3 + s4,
    s1 + s2(2) + s3 + s4,
    s1 + s2(4) + s4,
    s1 + s3 + s4,
    s1 + s2(2) + s3,
    s1 + s2(6) + s3 + s4,
  ];

  const inRange = candidates.find((c) => {
    const w = wordCount(c);
    return w >= 40 && w <= 60;
  });
  if (inRange) return inRange;

  // Fall back to the candidate closest to the 40-60 range.
  return candidates.sort((a, b) => {
    const dist = (c: string) => {
      const w = wordCount(c);
      return w < 40 ? 40 - w : w > 60 ? w - 60 : 0;
    };
    return dist(a) - dist(b);
  })[0];
}

// ---------------------------------------------------------------------------
// Title / meta description fitting. Existing leading wording is never changed:
// short strings are extended at the tail, long ones trimmed at a word boundary.
// ---------------------------------------------------------------------------

export function fitTitle(base: string, tails: string[], min = 50, max = 60): string {
  if (base.length > max) {
    const cut = base.slice(0, max + 1);
    const idx = Math.max(cut.lastIndexOf(' | '), cut.lastIndexOf(': '), cut.lastIndexOf(' '));
    return base.slice(0, idx > 0 ? idx : max).trim();
  }
  if (base.length >= min) return base;
  for (const tail of tails) {
    const t = `${base}${tail}`;
    if (t.length >= min && t.length <= max) return t;
  }
  return base;
}

// Builds a meta description of 140-155 characters from whole sentences.
// `prefix` (the existing opening wording) is always kept as the first words.
export function fitDescription(prefix: string, body: string, fillers: string[], min = 140, max = 155): string {
  const sentences = (body || '').match(/[^.!?]+[.!?]+(\s|$)/g)?.map((x) => x.trim()) || (body ? [body.trim()] : []);

  const fill = (base: string): string | null => {
    if (base.length >= min && base.length <= max) return base;
    for (const f of fillers) {
      const t = `${base} ${f}`;
      if (t.length >= min && t.length <= max) return t;
    }
    for (const f of fillers) {
      for (const g of fillers) {
        if (f === g) continue;
        const t = `${base} ${f} ${g}`;
        if (t.length >= min && t.length <= max) return t;
      }
    }
    return null;
  };

  let text = prefix.trim();
  let used = 0;
  for (const sentence of sentences) {
    const next = `${text} ${sentence}`;
    if (next.length <= max) { text = next; used += 1; } else break;
  }

  const direct = fill(text);
  if (direct) return direct;

  // The next sentence is too long: keep a complete clause of it instead.
  const rest = sentences[used] || '';
  if (rest) {
    const room = max - text.length - 1;
    const window = rest.slice(0, room);
    const breaks = [', ', '; ', ' and ', ' to ', ' before ', ' where ', ' which ', ' with ']
      .map((b) => window.lastIndexOf(b))
      .filter((i) => i > 20);
    for (const pos of breaks.sort((x, y) => y - x)) {
      const clause = `${rest.slice(0, pos).trim().replace(/[,;]$/, '')}.`;
      const candidate = `${text} ${clause}`;
      const fitted = fill(candidate);
      if (fitted) return fitted;
    }
  }
  return text;
}
