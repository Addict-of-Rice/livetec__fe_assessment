import { Slider } from '@mui/material';
import type { Dayjs } from 'dayjs';
import type { Dispatch, FC, SetStateAction } from 'react';
import Row from '../Structure/Row';
import { appColors } from '../../constants/colors';
import Column from '../Structure/Column';
import { C_t } from '../Typography/Typography';

type Props = {
  currentDate: Dayjs | undefined;
  setCurrentDate: Dispatch<SetStateAction<Dayjs | undefined>>;
  dateRange: { start: Dayjs; end?: Dayjs };
  lastUpdate: Dayjs;
};

const RangeProgressSlider: FC<Props> = ({ currentDate, setCurrentDate, dateRange, lastUpdate }) => {
  const totalDays = dateRange.start.diff(dateRange.end);
  const elapsedDays = currentDate
    ? Math.max(0, Math.min(totalDays, currentDate.diff(dateRange.start, 'day')))
    : 0;
  const progress = totalDays > 0 ? (elapsedDays / totalDays) * 100 : 0;

  return (
    <Row
      style={{
        width: '960px',
        backgroundColor: appColors.background,
        alignItems: 'center',
        paddingInline: '36px',
        gap: '16px',
      }}
    >
      <Slider value={progress} />
      <Column style={{ width: '64px', justifyContent: 'center' }}>
        <C_t style={{ textAlign: 'right' }} color={appColors.primary}>
          Last update
        </C_t>
        <C_t style={{ textAlign: 'right' }} color={appColors.primary}>
          {lastUpdate.format('DD/MM/YY')}
        </C_t>
      </Column>
    </Row>
  );
};

export default RangeProgressSlider;
