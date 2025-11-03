import type { LatLng } from '../types/latLng';

export const formatLatLng = (value: LatLng) => {
  return { lat: value.latitude, lng: value.longitude };
};
