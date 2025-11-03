import type { Classification } from '../types/classification';
import type { Farm } from '../types/farm';
import { fetchApi } from './fetch-api';

export const getFarms = (
  country?: string,
  county?: string,
  classification?: Classification,
  operating?: boolean
) =>
  fetchApi<Farm[]>('GET', '/api/farms', {
    country,
    county,
    classification,
    operating,
  });
