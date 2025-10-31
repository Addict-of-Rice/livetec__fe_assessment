import React from 'react';

export default function Sidebar() {
  return (
    <aside className="sidebar">
      <div className="sidebar__section">
        <h3 className="sidebar__title">Menu</h3>
        <ul className="sidebar__list">
          <li><a href="#" className="sidebar__link">Map</a></li>
        </ul>
      </div>
      <div className="sidebar__section">
        <h3 className="sidebar__title">Shortcuts</h3>
        <ul className="sidebar__list">
          <li><a href="#" className="sidebar__link">Active Outbreaks</a></li>
          <li><a href="#" className="sidebar__link">Wildbird</a></li>
        </ul>
      </div>
    </aside>
  );
}
