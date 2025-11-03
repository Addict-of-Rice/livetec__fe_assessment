import Header from './components/Layout/Header.js';
import Sidebar from './components/Layout/Sidebar.js';
import Map from './components/Layout/Map.js';
import ThemeProvider from './providers/ThemeProvider.js';
import Legend from './components/Legend/Legend.js';
import { LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import DateControls from './components/DateControls/DateControls.js';
import MapLayers from './components/MapLayers/MapLayers.js';
import dayjs, { Dayjs } from 'dayjs';
import { useEffect, useState } from 'react';
import type { Outbreak } from './types/outbreak.js';
import type { Farm } from './types/farm.js';
import type { Death } from './types/death.js';
import type { Migration } from './types/migration.js';
import { getActiveOutbreaks, getHistoricalOutbreaks } from './api/outbreak-api.js';
import { getWildbirdDeaths } from './api/wildbird-deaths-api.js';
import { getWildbirdMigrations } from './api/wildbird-migrations-api.js';
import { getFarms } from './api/farms-api.js';
import type { MapElement, MapElementCategory } from './types/mapElement.js';
import { formatLatLng } from './utils/latLng.js';
import { appColors } from './constants/colors.js';
import { createMarkerContent } from './utils/marker.js';
import { CALENDAR_MIN_DATE } from './constants/config.js';
import type { Classification } from './types/classification.js';
import { separateCamelCase } from './utils/string.js';
import type {
  CircleOptions,
  MapOverlay,
  MarkerOptions,
  PolygonOptions,
  PolylineOptions,
} from './types/mapOverlay.js';

export default function App() {
  const [currentDate, setCurrentDate] = useState<Dayjs>();
  const [dateRange, setDateRange] = useState<{ start: Dayjs; end?: Dayjs }>({
    start: dayjs(),
    end: undefined,
  });

  const [hiddenCategories, setHiddenCategories] = useState<MapElementCategory[]>([]);
  const [mapElementSet, setMapElementSet] = useState(new Set<MapElement>());
  const [mapOverlay, setMapOverlay] = useState<MapOverlay>({
    markers: new Set(),
    circles: new Set(),
    polylines: new Set(),
    polygons: new Set(),
  });

  useEffect(() => {
    fetchData();
  }, [dateRange]);

  const fetchData = async () => {
    const newMapElementSet = new Set<MapElement>();

    const addOutbreaks = (category: MapElementCategory, outbreaks: Outbreak[], color: string) => {
      for (const outbreak of outbreaks) {
        const polygons = new Set<PolygonOptions>();

        if (outbreak.zoneShape.length > 0) {
          for (const shape of outbreak.zoneShape) {
            polygons.add({
              key: `${outbreak.id}-${polygons.size}`,
              paths: shape,
              fillColor: color,
              fillOpacity: 0.6,
              strokeColor: color,
              strokeWeight: 1,
            });
          }
        }

        let circle: CircleOptions | null = null;
        if (outbreak.zoneDiameter > 0) {
          circle = {
            key: `${outbreak.id}-circle`,
            center: formatLatLng(outbreak.location),
            radius: outbreak.zoneDiameter,
            fillColor: color,
            fillOpacity: 0.6,
            strokeColor: color,
            strokeWeight: 1,
          };
        }

        const marker: MarkerOptions = {
          key: `${outbreak.id}-marker`,
          position: formatLatLng(outbreak.location),
          title: `${outbreak.ended == null ? 'Active' : 'Historical'} ${outbreak.type} ${
            outbreak.disease
          } Outbreak`,
          content: createMarkerContent(color),
        };

        newMapElementSet.add({
          category,
          minDate: dayjs(outbreak.started),
          maxDate: outbreak.ended ? dayjs(outbreak.ended) : dayjs(),
          firstMarker: marker,
          circle,
          polyline: null,
          polygons,
          secondMarker: null,
        });
      }
    };

    const addDeaths = (deaths: Death[], color: string) => {
      for (const death of deaths) {
        const marker: MarkerOptions = {
          key: `death-${death.id}`,
          position: formatLatLng(death.location),
          title: `${death.numberOfBirdsAffected} ${death.species} Death${
            death.numberOfBirdsAffected === 1 ? '' : 's'
          } by ${death.virus}`,
          content: createMarkerContent(color),
        };

        newMapElementSet.add({
          category: 'wildbirdDeaths',
          minDate: dayjs(death.date),
          maxDate: dayjs(death.date),
          firstMarker: marker,
          circle: null,
          polyline: null,
          polygons: null,
          secondMarker: null,
        });
      }
    };

    const addMigrations = (migrations: Migration[], color: string) => {
      for (const migration of migrations) {
        const startMarker: MarkerOptions = {
          key: `migration-${migration.id}-start`,
          position: formatLatLng(migration.startLocation),
          title: `${migration.species} Migration Start`,
          content: createMarkerContent(color),
        };
        const endMarker: MarkerOptions = {
          key: `migration-${migration.id}-end`,
          position: formatLatLng(migration.endLocation),
          title: `${migration.species} Migration End`,
          content: createMarkerContent(color),
        };
        const polyline: PolylineOptions = {
          key: `migration-${migration.id}-line`,
          path: [formatLatLng(migration.startLocation), formatLatLng(migration.endLocation)],
          strokeColor: color,
          strokeWeight: 2,
        };

        newMapElementSet.add({
          category: 'wildbirdMigrations',
          minDate: dayjs(migration.startDate),
          maxDate: dayjs(migration.endDate),
          firstMarker: startMarker,
          secondMarker: endMarker,
          polyline,
          circle: null,
          polygons: null,
        });
      }
    };

    const addFarms = (farms: Farm[], color: string) => {
      const getFarmLabel = (classificationsRaw?: Classification | Classification[]): string => {
        if (!classificationsRaw) {
          return 'Farm';
        }

        const classificationsArray: Classification[] = Array.isArray(classificationsRaw)
          ? classificationsRaw
          : [classificationsRaw];

        const classifications = classificationsArray.map(
          (classification) => separateCamelCase(classification).split(' Farm')[0]
        );
        if (classifications.length === 0) return 'Farm';
        if (classifications.length === 1) return `${classifications[0]} Farm`;
        const allButLast = classifications.slice(0, classifications.length - 1).join(', ');
        const last = classifications[classifications.length - 1];
        return `${allButLast} and ${last} Farm`;
      };

      for (const farm of farms) {
        if (farm.latitude && farm.longitude) {
          const marker: MarkerOptions = {
            key: `farm-${farm.id}`,
            position: { lat: farm.latitude, lng: farm.longitude },
            title: getFarmLabel(farm.classification),
            content: createMarkerContent(color),
          };

          newMapElementSet.add({
            category: 'farms',
            minDate: CALENDAR_MIN_DATE,
            maxDate: dayjs(),
            firstMarker: marker,
            circle: null,
            polyline: null,
            polygons: null,
            secondMarker: null,
          });
        }
      }
    };

    const activeOutbreaks = await getActiveOutbreaks(
      dateRange.start,
      dateRange.end ? dateRange.end : dateRange.start
    );
    const historicalOutbreaks = await getHistoricalOutbreaks(
      dateRange.start,
      dateRange.end ? dateRange.end : dateRange.start
    );
    const wildbirdDeaths = await getWildbirdDeaths(
      dateRange.start,
      dateRange.end ? dateRange.end : dateRange.start
    );
    const wildbirdMigrations = await getWildbirdMigrations(
      dateRange.start,
      dateRange.end ? dateRange.end : dateRange.start
    );
    const farms = await getFarms();

    addOutbreaks('activeOutbreaks', activeOutbreaks, appColors.orangeBulletPoint);
    addOutbreaks('historicalOutbreaks', historicalOutbreaks, appColors.magentaBulletPoint);
    addDeaths(wildbirdDeaths, appColors.yellowBulletPoint);
    addMigrations(wildbirdMigrations, appColors.azureBulletPoint);
    addFarms(farms, appColors.greenBulletPoint);

    setMapElementSet(newMapElementSet);
    applyFilters(newMapElementSet);
  };

  useEffect(() => applyFilters(mapElementSet), [currentDate]);

  const applyFilters = (currentMapElementSet: Set<MapElement>) => {
    const newMapOverlay: MapOverlay = {
      markers: new Set(),
      circles: new Set(),
      polylines: new Set(),
      polygons: new Set(),
    };

    for (const element of currentMapElementSet) {
      if (
        !hiddenCategories.includes(element.category) &&
        (currentDate == null ||
          ((currentDate!.isSame(element.minDate) || currentDate!.isAfter(element.minDate)) &&
            (currentDate!.isBefore(element.maxDate) || currentDate!.isSame(element.maxDate))))
      ) {
        if (element.firstMarker != null) {
          newMapOverlay.markers.add(element.firstMarker!);
        }
        if (element.circle != null) {
          newMapOverlay.circles.add(element.circle!);
        }
        if (element.polyline != null) {
          newMapOverlay.polylines.add(element.polyline!);
        }
        if (element.polygons != null) {
          for (const polygon of element.polygons!) {
            newMapOverlay.polygons.add(polygon);
          }
        }
      }
    }

    setMapOverlay(newMapOverlay);
  };

  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <ThemeProvider>
        <div className='app-root'>
          <Header />
          <div className='app-body'>
            <Sidebar />
            <main className='app-content'>
              <Legend />
              <DateControls
                currentDate={currentDate}
                setCurrentDate={setCurrentDate}
                dateRange={dateRange}
                setDateRange={setDateRange}
              />
              <MapLayers />
              <Map mapOverlay={mapOverlay} />
            </main>
          </div>
        </div>
      </ThemeProvider>
    </LocalizationProvider>
  );
}
