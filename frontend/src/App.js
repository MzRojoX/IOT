import React, { useState, useEffect, useRef, useCallback } from 'react';
import axios from 'axios';
import Sidebar from './components/Sidebar';
import TimelineChart from './components/TimelineChart';
import HistoryChart from './components/HistoryChart';
import './App.css';

const API_BASE_URL = 'http://localhost:8000/api';

function App() {
  const [selectedZona, setSelectedZona] = useState(null);
  const [zonas, setZonas] = useState([]);
  const [eventosCarros, setEventosCarros] = useState([]);
  const [eventosAnimales, setEventosAnimales] = useState([]);
  const [alertas, setAlertas] = useState([]);
  const [loading, setLoading] = useState(false);
  const [notificaciones, setNotificaciones] = useState({});
  
  const lastHashRef = useRef({});
  const pollIntervalRef = useRef(null);

  // Hash para detectar cambios sin recargar todo
  const getHash = (data) => {
    try {
      return JSON.stringify(data).substring(0, 100);
    } catch {
      return '';
    }
  };

  // Cargar zonas una sola vez
  useEffect(() => {
    const fetchZonas = async () => {
      try {
        const response = await axios.get(`${API_BASE_URL}/zonas`);
        setZonas(response.data);
        if (response.data.length > 0) {
          setSelectedZona(response.data[0].id);
        }
      } catch (error) {
        console.error('Error cargando zonas:', error);
      }
    };
    fetchZonas();
  }, []);

  // Polling para eventos de la zona seleccionada
  const fetchEventos = useCallback(async () => {
    if (!selectedZona) return;

    try {
      const [carrosRes, animalesRes, alertasRes] = await Promise.all([
        axios.get(`${API_BASE_URL}/eventos-carros?zona_id=${selectedZona}&limit=100`),
        axios.get(`${API_BASE_URL}/eventos-animales?zona_id=${selectedZona}&limit=100`),
        axios.get(`${API_BASE_URL}/alertas?zona_id=${selectedZona}&limit=100`),
      ]);

      // Solo actualizar si hay cambios
      const carrosHash = getHash(carrosRes.data);
      const animalesHash = getHash(animalesRes.data);
      const alertasHash = getHash(alertasRes.data);

      if (carrosHash !== lastHashRef.current.carros) {
        setEventosCarros(carrosRes.data);
        lastHashRef.current.carros = carrosHash;
      }

      if (animalesHash !== lastHashRef.current.animales) {
        setEventosAnimales(animalesRes.data);
        lastHashRef.current.animales = animalesHash;
      }

      if (alertasHash !== lastHashRef.current.alertas) {
        setAlertas(alertasRes.data);
        lastHashRef.current.alertas = alertasHash;
      }

      setLoading(false);
    } catch (error) {
      console.error('Error cargando eventos:', error);
      setLoading(false);
    }
  }, [selectedZona]);

  // Setup polling
  useEffect(() => {
    if (!selectedZona) return;

    setLoading(true);
    fetchEventos();

    // Polling cada 3 segundos
    pollIntervalRef.current = setInterval(fetchEventos, 3000);

    return () => {
      if (pollIntervalRef.current) {
        clearInterval(pollIntervalRef.current);
      }
    };
  }, [selectedZona, fetchEventos]);

  const handleSelectZona = useCallback((zonaId) => {
    setNotificaciones(prev => ({ ...prev, [zonaId]: false }));
    setSelectedZona(zonaId);
    lastHashRef.current = {}; // Resetear hash para nueva zona
  }, []);

  return (
    <div className="app-container">
      <Sidebar
        zonas={zonas}
        selectedZona={selectedZona}
        onSelectZona={handleSelectZona}
        notificaciones={notificaciones}
      />
      <div className="main-content">
        <header className="app-header">
          <h1>🚗 IoT Monitoring Dashboard</h1>
          {selectedZona && (
            <p className="zona-info">
              Zona Activa: <strong>{zonas.find(z => z.id === selectedZona)?.nombre}</strong>
            </p>
          )}
        </header>

        {loading && <div className="loading">Cargando...</div>}

        {selectedZona && (
          <div className="charts-container">
            <TimelineChart
              eventosCarros={eventosCarros}
              eventosAnimales={eventosAnimales}
              alertas={alertas}
            />
            <HistoryChart
              eventosCarros={eventosCarros}
              eventosAnimales={eventosAnimales}
              alertas={alertas}
            />
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
