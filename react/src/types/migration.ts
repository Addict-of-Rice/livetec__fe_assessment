import type { LatLng } from './latLng';

export type Migration = {
  id: string;
  species: string;
  startDate: string;
  endDate: string;
  startLocation: LatLng;
  endLocation: LatLng;
};
