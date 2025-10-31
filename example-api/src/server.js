const express = require('express');
const cors = require('cors');
const fs = require('fs').promises;
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const DATA_DIR = path.join(__dirname, '..', '..', 'data');

async function loadJson(filename) {
  const fullPath = path.join(DATA_DIR, filename);
  try {
    const raw = await fs.readFile(fullPath, 'utf8');
    return JSON.parse(raw);
  } catch (err) {
    // Enhance error with file path for easier debugging
    err.message = `Failed to read ${fullPath}: ${err.message}`;
    throw err;
  }
}

/**
 * Filter items by date range overlap
 * @param {Array} data - Array of items to filter
 * @param {string|null} from - Start date filter (YYYY-MM-DD)
 * @param {string|null} to - End date filter (YYYY-MM-DD)
 * @param {string} startField - Name of the start date field in the items
 * @param {string|null} endField - Name of the end date field (null for single-date items)
 * @returns {Array} Filtered array
 */
function filterByDateRange(data, from, to, startField, endField = null) {
  if (!from && !to) return data;

  const filterFrom = from ? new Date(from) : new Date('1900-01-01');
  const filterTo = to ? new Date(to) : new Date('2100-12-31');

  return data.filter(item => {
    if (!item[startField]) return false;

    const itemStart = new Date(item[startField]);
    const itemEnd = endField && item[endField] ? new Date(item[endField]) : itemStart;

    // Check if ranges overlap
    return itemStart <= filterTo && itemEnd >= filterFrom;
  });
}

/**
 * Apply generic filters to data
 * @param {Array} data - Array of items to filter
 * @param {Object} filters - Object with filter key-value pairs
 * @returns {Array} Filtered array
 */
function applyFilters(data, filters) {
  if (!filters || Object.keys(filters).length === 0) return data;

  return data.filter(item => {
    return Object.entries(filters).every(([key, value]) => {
      if (!value) return true; // Skip empty filters

      const itemValue = item[key];

      // Handle arrays (e.g., classification can be array or string)
      if (Array.isArray(itemValue)) {
        return itemValue.includes(value);
      }

      // Handle boolean values
      if (typeof itemValue === 'boolean') {
        return itemValue === (value === 'true' || value === true);
      }

      // Case-insensitive string comparison
      if (typeof itemValue === 'string') {
        return itemValue.toLowerCase() === value.toLowerCase();
      }

      return itemValue === value;
    });
  });
}

// Health and index
app.get(['/','/api'], (req, res) => {
  res.json({
    status: 'ok',
    endpoints: [
      '/api/active-outbreaks?risk=...&zone=...&from=YYYY-MM-DD&to=YYYY-MM-DD',
      '/api/historical-outbreaks?risk=...&zone=...&from=YYYY-MM-DD&to=YYYY-MM-DD',
      '/api/wildbird-deaths?species=...&from=YYYY-MM-DD&to=YYYY-MM-DD',
      '/api/wildbird-migrations?species=...&from=YYYY-MM-DD&to=YYYY-MM-DD',
      '/api/farms?&classification=...&operating=true|false'
    ]
  });
});

app.get('/api/farms', async (req, res, next) => {
  try {
    let data = await loadJson('farms.json');
    const { classification, operating } = req.query;

    // Apply categorical filters
    data = applyFilters(data, { classification, operating });

    res.json(data);
  } catch (e) { next(e); }
});

app.get('/api/active-outbreaks', async (req, res, next) => {
  try {
    let data = await loadJson('active-outbreaks.json');
    const { from, to, risk, zone } = req.query;

    // Apply date filtering
    data = filterByDateRange(data, from, to, 'started', 'ended');

    // Apply categorical filters
    data = applyFilters(data, { risk, zone });

    res.json(data);
  } catch (e) { next(e); }
});

app.get('/api/historical-outbreaks', async (req, res, next) => {
  try {
    let data = await loadJson('historical-outbreaks.json');
    const { from, to, risk, zone } = req.query;

    // Apply date filtering
    data = filterByDateRange(data, from, to, 'started', 'ended');

    // Apply categorical filters
    data = applyFilters(data, { risk, zone });

    res.json(data);
  } catch (e) { next(e); }
});

app.get('/api/wildbird-deaths', async (req, res, next) => {
  try {
    let data = await loadJson('wildbird-deaths.json');
    const { from, to, species } = req.query;

    // Apply date filtering
    data = filterByDateRange(data, from, to, 'date');

    // Apply categorical filters
    data = applyFilters(data, { species });

    res.json(data);
  } catch (e) { next(e); }
});

app.get('/api/wildbird-migrations', async (req, res, next) => {
  try {
    let data = await loadJson('wildbird-migrations.json');
    const { from, to, species } = req.query;

    // Apply date filtering
    data = filterByDateRange(data, from, to, 'startDate', 'endDate');

    // Apply categorical filters
    data = applyFilters(data, { species });

    res.json(data);
  } catch (e) { next(e); }
});

// Not found
app.use((req, res, next) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal Server Error', details: process.env.NODE_ENV === 'development' ? err.message : undefined });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API listening on http://localhost:${PORT}`);
});
