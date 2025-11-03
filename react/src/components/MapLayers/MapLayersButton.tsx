import type { FC } from 'react';
import { C_p, C_s } from '../Typography/Typography';
import Column from '../Structure/Column';
import defaultImage from '../../assets/default.png';
import { appColors } from '../../constants/colors';

type Props = {
  onClick: () => void;
};

const MapLayersButton: FC<Props> = ({ onClick }) => {
  return (
    <Column
      style={{
        alignSelf: 'flex-end',
        width: '120px',
        justifyContent: 'center',
        alignItems: 'center',
        paddingBlock: '8px',
        paddingInline: '24px',
        gap: '8px',
        backgroundColor: appColors.background,
        boxSizing: 'border-box',
        margin: 0,
      }}
      onClick={onClick}
    >
      <div
        style={{
          width: '64px',
          height: '64px',
          backgroundImage: `url(${defaultImage})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          boxShadow: '0 4px 8px rgba(0,0,0,0.3)',
        }}
      />
      <C_s color={appColors.primary}>Map Layers</C_s>
    </Column>
  );
};

export default MapLayersButton;
