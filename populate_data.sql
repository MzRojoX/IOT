-- Script SQL para poblar datos de prueba
-- Ejecutar en PostgreSQL después de haber aplicado las migraciones

-- ============================================
-- 1. CREAR ZONAS
-- ============================================
INSERT INTO zonas (nombre) VALUES
('Entrada Principal'),
('Patio Central'),
('Zona de Carga'),
('Salida Trasera');

-- ============================================
-- 2. INSERTAR MEDICIONES (sensores crudos)
-- ============================================

-- ZONA 1: Carro SIN animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, hora) VALUES
(1, 25, 40, 40, 40, false, 800, 60.0, 22.5, NOW() - INTERVAL '10 minutes'),
(1, 40, 28, 40, 40, false, 820, 59.8, 22.6, NOW() - INTERVAL '9 minutes 50 seconds'),
(1, 40, 40, 30, 40, false, 790, 60.2, 22.4, NOW() - INTERVAL '9 minutes 40 seconds'),
(1, 40, 40, 40, 25, false, 810, 59.9, 22.5, NOW() - INTERVAL '9 minutes 30 seconds');

-- ZONA 1: Carro CON animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, hora) VALUES
(1, 26, 40, 40, 40, true, 850, 61.0, 23.0, NOW() - INTERVAL '5 minutes'),
(1, 40, 29, 40, 40, true, 830, 61.2, 23.1, NOW() - INTERVAL '4 minutes 50 seconds'),
(1, 40, 40, 31, 40, true, 840, 60.9, 23.0, NOW() - INTERVAL '4 minutes 40 seconds');

-- ZONA 2: Carro SIN animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, hora) VALUES
(2, 24, 40, 40, 40, false, 750, 65.0, 21.5, NOW() - INTERVAL '8 minutes'),
(2, 40, 27, 40, 40, false, 770, 64.8, 21.6, NOW() - INTERVAL '7 minutes 50 seconds'),
(2, 40, 40, 32, 40, false, 740, 65.2, 21.4, NOW() - INTERVAL '7 minutes 40 seconds');

-- ZONA 2: Animal sin carro
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, hora) VALUES
(2, 50, 50, 50, 50, true, 780, 63.5, 21.8, NOW() - INTERVAL '3 minutes');

-- ZONA 3: Carro CON animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, hora) VALUES
(3, 35, 40, 40, 40, true, 900, 52.0, 24.0, NOW() - INTERVAL '6 minutes'),
(3, 40, 33, 40, 40, true, 920, 51.8, 24.1, NOW() - INTERVAL '5 minutes 50 seconds'),
(3, 40, 40, 34, 40, true, 910, 52.2, 24.0, NOW() - INTERVAL '5 minutes 40 seconds');

-- ZONA 4: Carro SIN animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, hora) VALUES
(4, 38, 40, 40, 40, false, 700, 60.5, 20.5, NOW() - INTERVAL '4 minutes'),
(4, 40, 36, 40, 40, false, 720, 60.3, 20.6, NOW() - INTERVAL '3 minutes 50 seconds'),
(4, 40, 40, 37, 40, false, 690, 60.7, 20.4, NOW() - INTERVAL '3 minutes 40 seconds');

-- ============================================
-- 3. VERIFICAR DATOS INSERTADOS
-- ============================================
SELECT 'Mediciones totales' as tipo, COUNT(*) as cantidad FROM mediciones
UNION ALL
SELECT 'Eventos de carros', COUNT(*) FROM eventos_carros
UNION ALL
SELECT 'Eventos de animales', COUNT(*) FROM eventos_animales
UNION ALL
SELECT 'Alertas', COUNT(*) FROM alertas
ORDER BY tipo;

-- ============================================
-- 4. VISUALIZAR DATOS PROCESADOS
-- ============================================
SELECT 'Eventos de Carros' as tipo;
SELECT ec.id, ec.sensor_inicial, ec.sensor_final, ec.estado, COUNT(m.id) as mediciones
FROM eventos_carros ec
LEFT JOIN mediciones m ON ec.id = m.evento_carro_id
GROUP BY ec.id, ec.sensor_inicial, ec.sensor_final, ec.estado;

SELECT 'Eventos de Animales' as tipo;
SELECT ea.id, ea.estado, COUNT(a.id) as alertas
FROM eventos_animales ea
LEFT JOIN alertas a ON ea.id = a.evento_animal_id
GROUP BY ea.id, ea.estado;

SELECT 'Alertas (Carro + Animal)' as tipo;
SELECT a.id, a.evento_carro_id, a.evento_animal_id, a.hora
FROM alertas a
ORDER BY a.hora DESC;
