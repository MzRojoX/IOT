import React, { useState, useMemo } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import '../styles/HistoryChart.css';

function HistoryChart({ eventosCarros, eventosAnimales, alertas }) {
  const [tipoSeleccionado, setTipoSeleccionado] = useState('carros');
  const [diaSeleccionado, setDiaSeleccionado] = useState(null);

  // Procesar datos: agrupar por día y luego por hora dentro de cada día
  const { datosPorDia, horasPorDiaSeleccionado } = useMemo(() => {
    const datosPorDia = {}; // { 'dd/MM/yyyy': count }
    const horasPorDia = {}; // { 'dd/MM/yyyy': { 'HH:00': count } }

    const processEvent = (evento, isAnimal = false) => {
      let date;
      if (isAnimal === 'alerta') {
        date = new Date(evento.hora);
      } else if (isAnimal) {
        date = new Date(evento.hora);
      } else {
        date = new Date(evento.hora_inicio);
      }

      // Clave por día
      const dayKey = date.toLocaleDateString('es-ES');
      datosPorDia[dayKey] = (datosPorDia[dayKey] || 0) + 1;

      // Agrupar horas por día
      if (!horasPorDia[dayKey]) {
        horasPorDia[dayKey] = {};
      }
      const hourKey = date.toLocaleTimeString('es-ES', { hour: '2-digit' }) + ':00';
      horasPorDia[dayKey][hourKey] = (horasPorDia[dayKey][hourKey] || 0) + 1;
    };

    // Procesar según el tipo seleccionado
    if (tipoSeleccionado === 'carros') {
      eventosCarros.forEach(e => processEvent(e, false));
    } else if (tipoSeleccionado === 'animales') {
      eventosAnimales.forEach(e => processEvent(e, true));
    } else if (tipoSeleccionado === 'alertas') {
      alertas.forEach(e => processEvent(e, 'alerta'));
    }

    // Ordenar días cronológicamente
    const sortedDaily = Object.entries(datosPorDia)
      .sort(([dateA], [dateB]) => new Date(dateA) - new Date(dateB))
      .map(([date, count]) => ({ date, eventos: count }));

    // Procesar horas del día seleccionado
    let horasPorDíaData = [];
    if (diaSeleccionado && horasPorDia[diaSeleccionado]) {
      horasPorDíaData = Object.entries(horasPorDia[diaSeleccionado])
        .sort(([timeA], [timeB]) => timeA.localeCompare(timeB))
        .map(([time, count]) => ({ time, eventos: count }));
    }

    return {
      datosPorDia: sortedDaily,
      horasPorDiaSeleccionado: horasPorDíaData
    };
  }, [eventosCarros, eventosAnimales, alertas, tipoSeleccionado, diaSeleccionado]);

  const getBarColor = () => {
    switch (tipoSeleccionado) {
      case 'carros': return '#ff6b6b';
      case 'animales': return '#4ecdc4';
      case 'alertas': return '#ffd93d';
      default: return '#8884d8';
    }
  };

  const getLabel = () => {
    switch (tipoSeleccionado) {
      case 'carros': return '🚗 Carros';
      case 'animales': return '🦁 Animales';
      case 'alertas': return '⚠️ Alertas';
      default: return 'Eventos';
    }
  };

  // Convertir fecha string 'dd/MM/yyyy' a formato con día de la semana
  const formatDateWithDay = (dateString) => {
    const [day, month, year] = dateString.split('/');
    const dateObj = new Date(year, month - 1, day);
    const dayNames = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
    const dayName = dayNames[dateObj.getDay()];
    return `${dayName.charAt(0).toUpperCase() + dayName.slice(1)}, ${dateString}`;
  };

  return (
    <div className="history-chart-container">
      {/* Selectores de tipo */}
      <div className="type-selector">
        <button 
          className={`selector-btn ${tipoSeleccionado === 'carros' ? 'active' : ''}`}
          onClick={() => setTipoSeleccionado('carros')}
        >
          🚗 Carros
        </button>
        <button 
          className={`selector-btn ${tipoSeleccionado === 'animales' ? 'active' : ''}`}
          onClick={() => setTipoSeleccionado('animales')}
        >
          🦁 Animales
        </button>
        <button 
          className={`selector-btn ${tipoSeleccionado === 'alertas' ? 'active' : ''}`}
          onClick={() => setTipoSeleccionado('alertas')}
        >
          ⚠️ Alertas
        </button>
      </div>

      {/* Contenedor con dos gráficas lado a lado */}
      <div className="history-charts-wrapper">
        {/* Gráfica izquierda: Por día */}
        <div className="history-chart">
          <h3>📅 Eventos por Día - {getLabel()}</h3>
          <ResponsiveContainer width="100%" height={280}>
            <BarChart data={datosPorDia} margin={{ top: 5, right: 30, left: 0, bottom: 80 }}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis 
                dataKey="date" 
                angle={-45}
                textAnchor="end"
                height={100}
                tickFormatter={(date) => formatDateWithDay(date)}
              />
              <YAxis />
              <Tooltip 
                contentStyle={{
                  backgroundColor: '#1e1e1e',
                  border: '1px solid #444',
                  borderRadius: '4px',
                  color: '#fff'
                }}
                formatter={(value) => [`${value} eventos`, getLabel()]}
              />
              <Bar 
                dataKey="eventos" 
                fill={getBarColor()} 
                name={getLabel()} 
                isAnimationActive={false}
                onClick={(data) => setDiaSeleccionado(data.date)}
              />
            </BarChart>
          </ResponsiveContainer>
          <p style={{ textAlign: 'center', marginTop: '10px', fontSize: '12px', color: '#888' }}>
            💡 Haz clic en una barra para ver el desgloce por horas
          </p>
        </div>

        {/* Gráfica derecha: Por hora del día seleccionado */}
        {diaSeleccionado ? (
          <div className="history-chart">
            <h3>⏰ Eventos por Hora</h3>
            <p style={{ fontSize: '12px', color: '#aaa', marginBottom: '10px' }}>
              📍 {formatDateWithDay(diaSeleccionado)}
            </p>
            {horasPorDiaSeleccionado.length > 0 ? (
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={horasPorDiaSeleccionado} margin={{ top: 5, right: 30, left: 0, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="time" />
                  <YAxis />
                  <Tooltip 
                    contentStyle={{
                      backgroundColor: '#1e1e1e',
                      border: '1px solid #444',
                      borderRadius: '4px',
                      color: '#fff'
                    }}
                    formatter={(value) => [`${value} eventos`, getLabel()]}
                    labelFormatter={(label) => `${label} horas`}
                  />
                  <Bar dataKey="eventos" fill={getBarColor()} name={getLabel()} isAnimationActive={false} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <p style={{ textAlign: 'center', color: '#888', marginTop: '100px' }}>
                No hay datos para este día
              </p>
            )}
            <button 
              onClick={() => setDiaSeleccionado(null)}
              style={{
                marginTop: '10px',
                width: '100%',
                padding: '8px',
                backgroundColor: '#ff6b6b',
                color: '#fff',
                border: 'none',
                borderRadius: '4px',
                cursor: 'pointer',
                fontSize: '12px'
              }}
            >
              ✕ Limpiar selección
            </button>
          </div>
        ) : (
          <div className="history-chart empty-state">
            <h3>⏰ Eventos por Hora</h3>
            <p style={{ textAlign: 'center', color: '#888', marginTop: '100px' }}>
              Selecciona un día para ver el desgloce por horas
            </p>
          </div>
        )}
      </div>
    </div>
  );
}

export default React.memo(HistoryChart);
