import React from 'react';
import { Bell } from 'lucide-react';
import '../styles/Sidebar.css';

function Sidebar({ zonas, selectedZona, onSelectZona, notificaciones }) {
  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <h1>🗺️ Zonas</h1>
      </div>

      <div className="zonas-list">
        {zonas.map(zona => (
          <button
            key={zona.id}
            className={`zona-item ${selectedZona === zona.id ? 'active' : ''} ${notificaciones[zona.id] ? 'has-notification' : ''}`}
            onClick={() => onSelectZona(zona.id)}
          >
            <span className="zona-name">{zona.nombre}</span>
            {notificaciones[zona.id] && (
              <span className="notification-badge">
                <Bell size={16} />
              </span>
            )}
          </button>
        ))}
      </div>

      <div className="sidebar-footer">
        <p className="version">v1.0.0</p>
      </div>
    </aside>
  );
}

export default React.memo(Sidebar);
