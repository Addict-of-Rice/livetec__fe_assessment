import type { FC } from 'react';
import Row from '../Structure/Row';
import { C_p } from '../Typography/Typography';
import { appColors } from '../../constants/colors';

type Props = {
  title: string;
  color: string;
};

const BulletPoint: FC<Props> = ({ title, color }) => {
  return (
    <Row style={{ gap: '16px', alignItems: 'center' }}>
      <div
        style={{
          borderRadius: '50%',
          backgroundColor: `${color}99`,
          borderColor: color,
          width: '12px',
          height: '12px',
        }}
      />
      <C_p color={appColors.primary}>{title}</C_p>
    </Row>
  );
};

export default BulletPoint;
