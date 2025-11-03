import type { FC } from 'react';
import { appColors } from '../../constants/colors';
import type { Dayjs } from 'dayjs';
import { C_s } from '../Typography/Typography';

type Props = {
  currentDate?: Dayjs;
  dateRange: { start: Dayjs; end?: Dayjs };
  onClick: () => void;
};

const DateDisplay: FC<Props> = ({ currentDate, dateRange, onClick }) => {
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'center',
        color: appColors.background,
        backgroundColor: appColors.secondary,
        width: '180px',
        padding: '4px',
        borderRadius: '16px',
        alignItems: 'center',
      }}
      onClick={onClick}
    >
      <C_s>
        {currentDate
          ? currentDate.format('MMMM DD YYYY')
          : dateRange.end
          ? `${dateRange.start.format('MMM DD YYYY')} - ${dateRange.end.format('MMM DD YYYY')}`
          : dateRange.start.format('MMMM DD YYYY')}
      </C_s>
    </div>
  );
};

export default DateDisplay;
