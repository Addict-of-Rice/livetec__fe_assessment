import { useState, type FC } from 'react';
import Column from '../Structure/Column';
import { zIndex } from '../../constants/z-index';
import MapLayersButton from './MapLayersButton';
import MapLayersPopup from './MapLayersPopup';

const MapLayers: FC = () => {
  const [isPopupOpen, setIsPopupOpen] = useState(false);

  return (
    <Column
      style={{
        position: 'absolute',
        bottom: 16,
        right: 16,
        zIndex: zIndex.section.main,
        gap: '8px',
      }}
    >
      {isPopupOpen && <MapLayersPopup onClose={() => setIsPopupOpen(false)} />}
      <MapLayersButton onClick={() => setIsPopupOpen((prev) => !prev)} />
    </Column>
  );
};

export default MapLayers;
