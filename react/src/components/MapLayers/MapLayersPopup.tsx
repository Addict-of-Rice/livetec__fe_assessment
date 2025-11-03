import type { FC } from 'react';
import Column from '../Structure/Column';
import Row from '../Structure/Row';
import { C_p } from '../Typography/Typography';
import { appColors } from '../../constants/colors';
import CloseIcon from '@mui/icons-material/Close';
import MapImageButton from './MapImageButton';
import { Divider } from '@mui/material';
import defaultImage from '../../assets/default.png';
import satelliteImage from '../../assets/satellite.png';
import terrainImage from '../../assets/terrain.png';

type Props = {
  onClose: () => void;
};

const MapLayersPopup: FC<Props> = ({ onClose }) => {
  return (
    <Column
      style={{
        width: '300px',
        backgroundColor: appColors.background,
        paddingInline: '24px',
      }}
    >
      <Row
        style={{
          alignItems: 'center',
          justifyContent: 'space-between',
          paddingBlock: '16px',
        }}
      >
        <C_p color={appColors.primary}>Map Details</C_p>
        <div onClick={onClose}>
          <CloseIcon style={{ color: 'black' }} />
        </div>
      </Row>
      <Row style={{ justifyContent: 'space-between' }}>
        <MapImageButton
          title='Active Outbreaks'
          style={{ backgroundColor: appColors.primary }}
          onClick={() => {}}
        />
        <MapImageButton
          title='Historical Outbreaks'
          style={{ backgroundColor: appColors.primary }}
          onClick={() => {}}
        />
        <MapImageButton
          title='Wild Bird Deaths'
          style={{ backgroundColor: appColors.primary }}
          onClick={() => {}}
        />
      </Row>
      <Row style={{ justifyContent: 'space-between' }}>
        <MapImageButton
          title='Wild Bird Data'
          style={{ backgroundColor: appColors.secondary }}
          onClick={() => {}}
        />
      </Row>
      <Divider />

      <Row
        style={{
          alignItems: 'center',
          justifyContent: 'space-between',
          paddingBlock: '16px',
        }}
      >
        <C_p color={appColors.primary}>Map Tools</C_p>
      </Row>
      <Row style={{ justifyContent: 'space-between' }}>
        <MapImageButton
          title='Migratory'
          style={{ backgroundColor: appColors.primary }}
          onClick={() => {}}
        />
        <MapImageButton
          title='Outbreaks'
          style={{ backgroundColor: appColors.primary }}
          onClick={() => {}}
        />
        <MapImageButton
          title='Predictability'
          style={{ backgroundColor: appColors.primary }}
          onClick={() => {}}
        />
      </Row>
      <Divider />

      <Row
        style={{
          alignItems: 'center',
          justifyContent: 'space-between',
          paddingBlock: '16px',
        }}
      >
        <C_p color={appColors.primary}>Map Type</C_p>
      </Row>
      <Row style={{ justifyContent: 'space-between' }}>
        <MapImageButton
          title='Default'
          style={{ backgroundImage: `url(${defaultImage})` }}
          onClick={() => {}}
        />
        <MapImageButton
          title='Satellite'
          style={{ backgroundImage: `url(${satelliteImage})` }}
          onClick={() => {}}
        />
        <MapImageButton
          title='Predictability'
          style={{ backgroundImage: `url(${terrainImage})` }}
          onClick={() => {}}
        />
      </Row>
    </Column>
  );
};

export default MapLayersPopup;
