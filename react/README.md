# React single-page layout with Google Map

A simple React app (Vite) with a fixed header, a sidebar menu, and a Google Maps area that fills the remaining space.

## Scripts

```powershell
# from repo root or the react folder
cd react
npm install
npm run dev    # start dev server
npm run build  # production build
npm run preview # preview production build
```

Dev server default: http://localhost:5173

## Map behavior
- Uses the Google Maps JavaScript SDK to render an interactive map.
- Requires an API key available as an environment variable named `VITE_GOOGLE_MAPS_API_KEY`.

### Set your API key
Create a `.env` file in the `react/` folder with:

```env
VITE_GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

You can obtain an API key from Google Cloud Console. Make sure the Maps JavaScript API is enabled.

### Customize map center and zoom
Update props in `src/components/Map.jsx` usage (defaults center to UK):

```jsx
<Map center={{ lat: 51.5074, lng: -0.1278 }} zoom={9} />
```
