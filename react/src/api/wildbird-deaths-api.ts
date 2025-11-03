import type { Death } from '../types/death';
import { fetchApi } from './fetch-api';
import type { Dayjs } from 'dayjs';

export const getWildbirdDeaths = (from: Dayjs, to: Dayjs, species?: string) =>
  fetchApi<Death[]>('GET', '/api/wildbird-deaths', {
    from: from.format('YYYY-MM-DD'),
    to: to.format('YYYY-MM-DD'),
    species,
  });
