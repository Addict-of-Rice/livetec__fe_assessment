import type { LatLng } from './latLng';

export type Death = {
  id: string;
  date: string;
  locality: string;
  country: string;
  county: string | null;
  species: string;
  virus: string | null;
  numberOfBirdsAffected: number;
  location: LatLng;
};
