export type MarkerOptions = google.maps.marker.AdvancedMarkerElementOptions & { key: string | number };
export type CircleOptions = google.maps.CircleOptions & { key: string | number };
export type PolylineOptions = google.maps.PolylineOptions & { key: string | number };
export type PolygonOptions = google.maps.PolygonOptions & { key: string | number };

export type MapOverlay = {
  markers: Set<MarkerOptions>;
  circles: Set<CircleOptions>;
  polylines: Set<PolylineOptions>;
  polygons: Set<PolygonOptions>;
};