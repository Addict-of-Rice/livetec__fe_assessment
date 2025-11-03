import { DateCalendar, PickersDay } from '@mui/x-date-pickers';
import type { Dayjs } from 'dayjs';
import type { Dispatch, FC, SetStateAction } from 'react';
import { appColors } from '../../constants/colors';
import { CALENDAR_MIN_DATE, DATE_RANGE_LIMIT } from '../../constants/config';

type Props = {
  dateRange: { start: Dayjs; end?: Dayjs };
  setDateRange: Dispatch<SetStateAction<{ start: Dayjs; end?: Dayjs }>>;
};

const CustomDateCalendar: FC<Props> = ({ dateRange, setDateRange }) => {
  return (
    <DateCalendar
      minDate={CALENDAR_MIN_DATE}
      value={dateRange.end || dateRange.start || null}
      onChange={(newDate) => {
        if (!newDate) return;

        if (
          !dateRange.start ||
          (dateRange.start && dateRange.end) ||
          newDate.isBefore(dateRange.start) ||
          (newDate.isAfter(dateRange.start) &&
            newDate.diff(dateRange.start, 'day') > DATE_RANGE_LIMIT)
        ) {
          setDateRange({ start: newDate, end: undefined });
        } else {
          setDateRange({ start: dateRange.start, end: newDate });
        }
      }}
      sx={{
        backgroundColor: appColors.primary,
        borderRadius: '8px',
        margin: 0,
        '& .MuiPickersCalendarHeader-label': { color: appColors.background },
        '& .MuiSvgIcon-root': { color: appColors.background },
        '& .MuiTypography-root': { color: appColors.background },
        '& .MuiPickersDay-root': { color: `${appColors.background} !important` },
        '& .MuiPickersCalendar-weekContainer': {
          backgroundColor: appColors.primary,
        },
        '& .MuiPickersDay-root.Mui-selected': { backgroundColor: 'transparent' },
      }}
      slots={{
        day: (props) => {
          const { day } = props;
          const isSelected =
            (dateRange.start && day.isSame(dateRange.start, 'day')) ||
            (dateRange.end && day.isSame(dateRange.end, 'day'));

          const isInRange =
            dateRange.start &&
            dateRange.end &&
            day.isAfter(dateRange.start, 'day') &&
            day.isBefore(dateRange.end, 'day');

          return (
            <PickersDay
              {...props}
              sx={{
                borderWidth: '1px',
                borderStyle: 'solid',
                borderColor: isSelected || isInRange ? appColors.background : 'transparent',
                borderRadius: '50%',
              }}
            />
          );
        },
      }}
    />
  );
};

export default CustomDateCalendar;
