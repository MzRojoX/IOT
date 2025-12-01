# IoT Monitoring Frontend

Dashboard en tiempo real para monitoreo de sensores IoT.

## Características

- 📊 **Timeline interactivo** con zoom de eventos
- 📈 **Gráficas históricas** por hora y día
- 🗺️ **Sidebar** para seleccionar zonas
- 🔔 **Notificaciones** en tiempo real
- 🎨 **Diseño moderno** con tema oscuro

## Instalación

```bash
cd /home/mzrojox/IOT/frontend
npm install
```

## Desarrollo

```bash
npm start
```

Se abrirá en http://localhost:3000

## Build para producción

```bash
npm run build
```

## Requisitos

- Node.js 14+
- npm o yarn
- Backend FastAPI corriendo en http://localhost:8000

## API Endpoints Esperados

- `GET /api/zonas` - Lista de zonas
- `GET /api/eventos-carros?zona_id=1` - Eventos de carros
- `GET /api/eventos-animales?zona_id=1` - Eventos de animales
- `GET /api/alertas?zona_id=1` - Alertas
