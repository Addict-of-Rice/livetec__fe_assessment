import { useState, type FC } from 'react';
import { C_p } from '../Typography/Typography';
import Column from '../Structure/Column';
import BulletPoint from './BulletPoint';
import { appColors } from '../../constants/colors';
import { zIndex } from '../../constants/z-index';
import DataSection from './DataSection';
import Row from '../Structure/Row';
import { ExpandMore } from '@mui/icons-material';

const Legend: FC = () => {
  const [isExpanded, setIsExpanded] = useState(true);

  return (
    <Column
      style={{
        position: 'absolute',
        top: 16,
        left: 16,
        zIndex: zIndex.section.main,
        backgroundColor: appColors.background,
        width: '320px',
      }}
    >
      <Row
        style={{
          justifyContent: 'space-between',
          alignItems: 'center',
          backgroundColor: appColors.primary,
          padding: '16px',
        }}
        onClick={() => setIsExpanded((prev) => !prev)}
      >
        <C_p style={{ color: appColors.background }}>Legend</C_p>

        <div
          style={{
            transition: 'transform 0.3s ease',
            transform: isExpanded ? 'rotate(180deg)' : 'rotate(0deg)',
          }}
        >
          <ExpandMore />
        </div>
      </Row>

      <Column
        style={{
          paddingInline: '16px',
          maxHeight: isExpanded ? '500px' : '0px',
          overflow: 'hidden',
          transition: 'max-height 0.4s ease',
        }}
      >
        <Column
          style={{
            paddingTop: '16px',
            paddingBottom: '20px',
            gap: '36px',
          }}
        >
          <DataSection title='Outbreaks'>
            <BulletPoint title='Active Outbreaks' color={appColors.orangeBulletPoint} />
            <BulletPoint title='Historical Outbreaks' color={appColors.magentaBulletPoint} />
          </DataSection>

          <DataSection title='Wild Birds'>
            <BulletPoint title='Wild Bird Deaths' color={appColors.yellowBulletPoint} />
            <BulletPoint title='Wild Bird Migrations' color={appColors.azureBulletPoint} />
          </DataSection>

          <DataSection title='Farms'>
            <BulletPoint title='Farms' color={appColors.greenBulletPoint} />
          </DataSection>
        </Column>
      </Column>
    </Column>
  );
};

export default Legend;
