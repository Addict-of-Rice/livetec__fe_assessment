import type { Migration } from '../types/migration';
import { fetchApi } from './fetch-api';
import type { Dayjs } from 'dayjs';

export const getWildbirdMigrations = (from: Dayjs, to: Dayjs, species?: string) =>
  fetchApi<Migration[]>('GET', '/api/wildbird-migrations', {
    from: from.format('YYYY-MM-DD'),
    to: to.format('YYYY-MM-DD'),
    species,
  });
