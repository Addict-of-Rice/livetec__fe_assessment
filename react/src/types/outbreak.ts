import type { LatLng } from './latLng';
import type { Risk } from './risk';

export type Outbreak = {
  id: string;
  confNumber: string;
  title: string;
  risk: Risk;
  location: LatLng;
  type: string;
  disease: string;
  zone: string;
  zoneDiameter: number;
  zoneShape: number[][];
  started: string;
  ended: string | null;
};
