# Example API

Basic Express.js API that serves JSON data from the repository's `data/` folder.

## Endpoints

### Overview
- `GET /api` — index and health with available endpoints

### Data Endpoints

#### Outbreak Data
- `GET /api/active-outbreaks`
- `GET /api/historical-outbreaks`

**Filters:**
- `from=YYYY-MM-DD` — Filter by start date (inclusive)
- `to=YYYY-MM-DD` — Filter by end date (inclusive)
- `risk=string` — Filter by risk level (e.g., "Low", "Medium", "High")
- `zone=string` — Filter by zone type

**Example:**
```
/api/active-outbreaks?risk=High&from=2024-01-01
```

#### Wildbird Data
- `GET /api/wildbird-deaths`

**Filters:**
- `from=YYYY-MM-DD` — Filter by date (inclusive)
- `to=YYYY-MM-DD` — Filter by date (inclusive)
- `species=string` — Filter by bird species (e.g., "Pheasant", "Curlew")

**Example:**
```
/api/wildbird-deaths?species=Pheasant&from=2021-10-01&to=2021-12-31
```

- `GET /api/wildbird-migrations`

**Filters:**
- `from=YYYY-MM-DD` — Filter by migration start date (inclusive)
- `to=YYYY-MM-DD` — Filter by migration end date (inclusive)
- `species=string` — Filter by bird species

**Example:**
```
/api/wildbird-migrations?species=Lesser%20Black-backed%20Gull&from=2022-01-01
```

#### Farm Data
- `GET /api/farms`

**Filters:**
- `country=string` — Filter by country (e.g., "England", "Wales")
- `county=string` — Filter by county
- `classification=string` — Filter by farm classification (e.g., "DairyFarm", "IntensivePoultryFarm", "IntensivePigFarm")
- `operating=true|false` — Filter by operational status

**Example:**
```
/api/farms?country=England&classification=DairyFarm&operating=true
```

### Filter Notes
- All filters are optional and can be combined
- Date filters use range overlap logic (returns items whose date range overlaps with the filter range)
- String filters are case-insensitive
- Multiple filters work as AND conditions (all must match)

## Run locally

Prerequisites: Node.js 18+ recommended.

Install dependencies and start the server:

```powershell
# from the repo root or this folder
cd example-api
npm install
npm run start
```

Or with auto-reload during development:

```powershell
npm run dev
```

By default it listens on http://localhost:3000

Set a custom port with `PORT` env var:

```powershell
$env:PORT=4000; npm run start
```

## Notes

- Data files are read on each request from `../data/*.json`. If you add files or change their names, update `src/server.js` accordingly.
- CORS is enabled for convenience during local development.
