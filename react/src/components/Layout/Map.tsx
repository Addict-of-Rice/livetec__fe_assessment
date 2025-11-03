import { APIProvider, Marker } from '@vis.gl/react-google-maps';
import { Map as GoogleMap } from '@vis.gl/react-google-maps';
import type { FC } from 'react';
import type { MapOverlay } from '../../types/mapOverlay'

type Props = {
  mapOverlay: MapOverlay;
};

const Map: FC<Props> = ({ mapOverlay }) => {
  return (
    <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
      <GoogleMap
        className='map-container'
        defaultCenter={{ lat: 51.5074, lng: -0.1278 }}
        defaultZoom={9}
        gestureHandling={'greedy'}
        disableDefaultUI={true}
      >
        {Array.from(mapOverlay.markers).map((marker) => (
          <Marker
            key={marker.key}
            position={marker.position}
            title={marker.title}
            // content={marker.content}
          />
        ))}
      </GoogleMap>
    </APIProvider>
  );
};

export default Map;
