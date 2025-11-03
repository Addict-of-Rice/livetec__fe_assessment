import type { Classification } from './classification';

export type Farm = {
  id: number;
  latitude: number;
  longitude: number;
  county: string | undefined;
  country: string | undefined;
  classification: Classification | Classification[];
  operating: boolean;
};
