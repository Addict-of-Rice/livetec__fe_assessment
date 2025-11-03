import { useState, type Dispatch, type FC, type SetStateAction } from 'react';
import Column from '../Structure/Column';
import { zIndex } from '../../constants/z-index';
import DateDisplay from './DateDisplay';
import Row from '../Structure/Row';
import SliderButtons from './SliderButtons';
import dayjs, { Dayjs } from 'dayjs';
import CustomDateCalendar from './CustomDateCalendar';
import RangeProgressSlider from './RangeProgressSlider';

type Props = {
  currentDate: Dayjs | undefined;
  setCurrentDate: Dispatch<SetStateAction<Dayjs | undefined>>;
  dateRange: { start: Dayjs; end?: Dayjs };
  setDateRange: Dispatch<SetStateAction<{ start: Dayjs; end?: Dayjs }>>;
};

const DateControls: FC<Props> = ({ currentDate, setCurrentDate, dateRange, setDateRange }) => {
  const [isCalendarOpen, setIsCalendarOpen] = useState(false);

  const [isPlaying, setIsPlaying] = useState(false);

  return (
    <Column
      style={{
        position: 'absolute',
        bottom: 16,
        left: 16,
        zIndex: zIndex.section.main,
        gap: '8px',
        justifyContent: 'flex-start',
        alignContent: 'flex-start',
        alignItems: 'flex-start',
      }}
    >
      {isCalendarOpen && <CustomDateCalendar dateRange={dateRange} setDateRange={setDateRange} />}
      <DateDisplay
        currentDate={currentDate}
        dateRange={dateRange}
        onClick={() => setIsCalendarOpen((prev) => !prev)}
      />
      <Row
        style={{
          gap: '36px',
        }}
      >
        <SliderButtons
          isPlaying={isPlaying}
          onPlay={() => {
            setIsPlaying(true);
          }}
          onPause={() => {
            setIsPlaying(false);
          }}
          onSkipPrevious={() => {
            setIsPlaying(false);
          }}
          onSkipNext={() => {
            setIsPlaying(false);
          }}
        />
        <RangeProgressSlider
          currentDate={currentDate}
          setCurrentDate={setCurrentDate}
          dateRange={dateRange}
          lastUpdate={dayjs()}
        />
      </Row>
    </Column>
  );
};

export default DateControls;
