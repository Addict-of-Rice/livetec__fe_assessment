import type { Risk } from '../types/risk';
import { fetchApi } from './fetch-api';
import type { Outbreak } from '../types/outbreak';
import type { Dayjs } from 'dayjs';

const getOutbreaks = async (path: string, from: Dayjs, to: Dayjs, risk?: Risk, zone?: string) =>
  await fetchApi<Outbreak[]>('GET', path, {
    from: from.format('YYYY-MM-DD'),
    to: to.format('YYYY-MM-DD'),
    risk,
    zone,
  });

export const getActiveOutbreaks = async (from: Dayjs, to: Dayjs, risk?: Risk, zone?: string) =>
  await getOutbreaks('/api/active-outbreaks', from, to, risk, zone);

export const getHistoricalOutbreaks = async (from: Dayjs, to: Dayjs, risk?: Risk, zone?: string) =>
  await getOutbreaks('/api/historical-outbreaks', from, to, risk, zone);
