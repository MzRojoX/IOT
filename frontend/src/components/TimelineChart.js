import React, { useState, useMemo } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { ZoomIn, ZoomOut } from 'lucide-react';
import '../styles/TimelineChart.css';

function TimelineChart({ eventosCarros, eventosAnimales, alertas }) {
  const [zoomLevel, setZoomLevel] = useState(1);
  const [tipoSeleccionado, setTipoSeleccionado] = useState('carros'); // 'carros', 'animales', 'alertas'

  // Procesar datos para cada tipo de evento
  const dataPorTipo = useMemo(() => {
    // Carros
    const carrosData = eventosCarros
      .map((evento) => {
        const date = new Date(evento.hora_inicio);
        const dateStr = date.toLocaleDateString('es-ES');
        const timeStr = date.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
        const label = `${dateStr} ${timeStr}`;
        return { label, timestamp: date.getTime(), valor: 1 };
      })
      .sort((a, b) => a.timestamp - b.timestamp);

    // Animales
    const animalesData = eventosAnimales
      .map((evento) => {
        const date = new Date(evento.hora);
        const dateStr = date.toLocaleDateString('es-ES');
        const timeStr = date.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
        const label = `${dateStr} ${timeStr}`;
        return { label, timestamp: date.getTime(), valor: 1 };
      })
      .sort((a, b) => a.timestamp - b.timestamp);

    // Alertas
    const alertasData = alertas
      .map((alerta) => {
        const date = new Date(alerta.hora);
        const dateStr = date.toLocaleDateString('es-ES');
        const timeStr = date.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
        const label = `${dateStr} ${timeStr}`;
        return { label, timestamp: date.getTime(), valor: 1 };
      })
      .sort((a, b) => a.timestamp - b.timestamp);

    return {
      carros: carrosData,
      animales: animalesData,
      alertas: alertasData
    };
  }, [eventosCarros, eventosAnimales, alertas]);

  const visibleData = useMemo(() => 
    dataPorTipo[tipoSeleccionado].slice(-Math.ceil(20 * zoomLevel)),
    [dataPorTipo, tipoSeleccionado, zoomLevel]
  );

  const handleZoomIn = () => setZoomLevel(prev => Math.min(prev + 0.5, 3));
  const handleZoomOut = () => setZoomLevel(prev => Math.max(prev - 0.5, 1));

  return (
    <div className="timeline-chart">
      <div className="chart-header">
        <h2>📊 Línea de Tiempo - Eventos</h2>
        
        <div className="type-selector">
          <button 
            className={`type-btn ${tipoSeleccionado === 'carros' ? 'active' : ''}`}
            onClick={() => setTipoSeleccionado('carros')}
          >
            🚗 Carros ({eventosCarros.length})
          </button>
          <button 
            className={`type-btn ${tipoSeleccionado === 'animales' ? 'active' : ''}`}
            onClick={() => setTipoSeleccionado('animales')}
          >
            🦁 Animales ({eventosAnimales.length})
          </button>
          <button 
            className={`type-btn ${tipoSeleccionado === 'alertas' ? 'active' : ''}`}
            onClick={() => setTipoSeleccionado('alertas')}
          >
            ⚠️ Alertas ({alertas.length})
          </button>
        </div>

        <div className="zoom-controls">
          <button onClick={handleZoomOut} title="Alejar">
            <ZoomOut size={20} /> Alejar
          </button>
          <span className="zoom-level">{Math.round(zoomLevel * 100)}%</span>
          <button onClick={handleZoomIn} title="Acercar">
            <ZoomIn size={20} /> Acercar
          </button>
        </div>
      </div>

      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={visibleData} margin={{ top: 5, right: 30, left: 0, bottom: 80 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis 
            dataKey="label" 
            angle={-45}
            textAnchor="end"
            height={100}
          />
          <YAxis />
          <Tooltip 
            contentStyle={{
              backgroundColor: '#1e1e1e',
              border: '1px solid #444',
              borderRadius: '4px',
              color: '#fff'
            }}
          />
          <Bar 
            dataKey="valor" 
            fill={tipoSeleccionado === 'carros' ? '#ff6b6b' : tipoSeleccionado === 'animales' ? '#4ecdc4' : '#ffd93d'}
            name={tipoSeleccionado.charAt(0).toUpperCase() + tipoSeleccionado.slice(1)}
          />
        </BarChart>
      </ResponsiveContainer>

      <div className="chart-stats">
        <div className="stat">
          <span className="stat-label">Total:</span>
          <span className="stat-value">{visibleData.length}</span>
        </div>
      </div>
    </div>
  );
}

export default React.memo(TimelineChart);
