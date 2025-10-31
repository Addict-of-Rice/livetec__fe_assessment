import React from 'react';
import Header from './components/Header.jsx';
import Sidebar from './components/Sidebar.jsx';
import Map from './components/Map.jsx';

export default function App() {
  return (
    <div className="app-root">
      <Header />
      <div className="app-body">
        <Sidebar />
        <main className="app-content">
          <Map />
        </main>
      </div>
    </div>
  );
}
