import type { CSSProperties, FC } from 'react';
import Row from '../Structure/Row';
import { appColors } from '../../constants/colors';
import PlayArrowIcon from '@mui/icons-material/PlayArrow';
import PauseIcon from '@mui/icons-material/Pause';
import SkipPreviousIcon from '@mui/icons-material/SkipPrevious';
import SkipNextIcon from '@mui/icons-material/SkipNext';
import { RowingTwoTone } from '@mui/icons-material';

type Props = {
  isPlaying: boolean;
  onPlay: () => void;
  onPause: () => void;
  onSkipPrevious: () => void;
  onSkipNext: () => void;
};

const SliderButtons: FC<Props> = ({ isPlaying, onPlay, onPause, onSkipPrevious, onSkipNext }) => {
  const containerStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    color: appColors.primary,
    backgroundColor: appColors.primary,
    width: '64px',
    height: '64px',
  };

  const circleStyle: CSSProperties = {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: appColors.neutral,
    borderRadius: '50%',
    width: '36px',
    height: '36px',
  };

  return (
    <Row>
      <div
        style={{
          ...containerStyle,
          color: appColors.neutral,
          backgroundColor: appColors.tertiary,
          borderTopLeftRadius: '8px',
          borderBottomLeftRadius: '8px',
        }}
        onClick={isPlaying ? onPause : onPlay}
      >
        {isPlaying ? <PlayArrowIcon /> : <PauseIcon />}
      </div>
      <div style={containerStyle} onClick={onSkipPrevious}>
        <div style={circleStyle}>
          <SkipPreviousIcon />
        </div>
      </div>
      <div
        style={{
          ...containerStyle,
          borderTopRightRadius: '8px',
          borderBottomRightRadius: '8px',
        }}
        onClick={onSkipNext}
      >
        <div style={circleStyle}>
          <SkipNextIcon />
        </div>
      </div>
    </Row>
  );
};

export default SliderButtons;
