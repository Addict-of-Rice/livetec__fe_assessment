import type { Dayjs } from 'dayjs';
import type { CircleOptions, PolylineOptions, PolygonOptions, MarkerOptions } from './mapOverlay';

export type MapElementCategory =
  | 'activeOutbreaks'
  | 'historicalOutbreaks'
  | 'wildbirdDeaths'
  | 'farms'
  | 'wildbirdMigrations';

export type MapElement = {
  category: MapElementCategory;
  minDate: Dayjs;
  maxDate: Dayjs;
  firstMarker: MarkerOptions | null;
  secondMarker?: MarkerOptions | null;
  circle: CircleOptions | null;
  polyline: PolylineOptions | null;
  polygons: Set<PolygonOptions> | null;
};
