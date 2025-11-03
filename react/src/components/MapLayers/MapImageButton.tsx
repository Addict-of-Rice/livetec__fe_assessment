import type { CSSProperties, FC } from 'react';
import { C_t } from '../Typography/Typography';
import Column from '../Structure/Column';
import { appColors } from '../../constants/colors';

type Props = {
  title: string;
  style: CSSProperties;
  onClick: () => void;
};

const MapImageButton: FC<Props> = ({ title, style, onClick }) => {
  return (
    <Column style={{ alignItems: 'center', width: '76px', height: '76px' }} onClick={onClick}>
      <div
        style={{
          ...style,
          width: '48px',
          height: '48px',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        }}
      />
      <C_t style={{ textAlign: 'center' }} color={appColors.primary}>
        {title}
      </C_t>
    </Column>
  );
};

export default MapImageButton;
