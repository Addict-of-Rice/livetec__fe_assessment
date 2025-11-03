import type { FC, ReactNode } from 'react';
import { appColors } from '../../constants/colors';
import { C_s } from '../Typography/Typography';
import Column from '../Structure/Column';

type Props = {
  title: string;
  children: ReactNode;
};

const DataSection: FC<Props> = ({ title, children }) => {
  return (
    <Column style={{ gap: '12px' }}>
      <C_s color={appColors.primary}>{title}</C_s>
      <Column style={{ gap: '16px' }}>{children}</Column>
    </Column>
  );
};

export default DataSection;
