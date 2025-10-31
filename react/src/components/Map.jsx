import { APIProvider } from '@vis.gl/react-google-maps';
import { Map as GoogleMap } from '@vis.gl/react-google-maps';

export default function Map() {
    return (
        <APIProvider apiKey={import.meta.env.VITE_GOOGLE_MAPS_API_KEY}>
            <GoogleMap
                className='map-container'
                defaultZoom={6}
                defaultCenter={{ lat: 54.00366, lng: -2.547855 }}
                gestureHandling={'greedy'}
                disableDefaultUI={true}
            />
        </APIProvider>
    );
}