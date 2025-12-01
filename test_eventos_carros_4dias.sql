-- ============================================
-- Inserts directos en evento_carro y alerta
-- Para ZONA 1 con 4 días diferentes
-- Sin depender del procesamiento automático
-- ============================================

-- Limpiar alertas primero (por FK)
DELETE FROM alertas WHERE evento_carro_id IN (
  SELECT id FROM eventos_carros WHERE zona_id = 1 AND hora_inicio >= '2025-11-27'
);

-- Limpiar eventos_carros anteriores
DELETE FROM eventos_carros WHERE zona_id = 1 AND hora_inicio >= '2025-11-27';

-- Limpiar eventos_animales anteriores
DELETE FROM eventos_animales WHERE zona_id = 1 AND hora >= '2025-11-27';

-- ====================================
-- DÍA 1: 2025-11-27
-- ====================================

-- Evento 1: 06:00-06:05 (Carro sensor 1→2→3→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-27 06:00:00', '2025-11-27 06:05:00', 'cerrado');

-- Evento 2: 10:30-10:35 (Carro sensor 2→3)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 3, '2025-11-27 10:30:00', '2025-11-27 10:35:00', 'cerrado');

-- Evento 3: 14:15-14:18 (Carro sensor 3→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 3, 4, '2025-11-27 14:15:00', '2025-11-27 14:18:00', 'cerrado');

-- Evento 4: 18:45-18:50 (Carro sensor 1→2)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 2, '2025-11-27 18:45:00', '2025-11-27 18:50:00', 'cerrado');

-- ====================================
-- DÍA 2: 2025-11-28
-- ====================================

-- Evento 5: 07:00-07:04 (Carro sensor 1→3)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 3, '2025-11-28 07:00:00', '2025-11-28 07:04:00', 'cerrado');

-- Evento 6: 12:30-12:36 (Carro sensor 2→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 4, '2025-11-28 12:30:00', '2025-11-28 12:36:00', 'cerrado');

-- Evento 7: 16:20-16:24 (Carro sensor 1→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-28 16:20:00', '2025-11-28 16:24:00', 'cerrado');

-- Evento 8: 20:00-20:05 (Carro sensor 2→3)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 3, '2025-11-28 20:00:00', '2025-11-28 20:05:00', 'cerrado');

-- ====================================
-- DÍA 3: 2025-11-29
-- ====================================

-- Evento 9: 08:15-08:20 (Carro sensor 1→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-29 08:15:00', '2025-11-29 08:20:00', 'cerrado');

-- Evento 10: 13:45-13:50 (Carro sensor 3→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 3, 4, '2025-11-29 13:45:00', '2025-11-29 13:50:00', 'cerrado');

-- Evento 11: 19:30-19:35 (Carro sensor 1→3)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 3, '2025-11-29 19:30:00', '2025-11-29 19:35:00', 'cerrado');

-- ====================================
-- DÍA 4: 2025-11-30
-- ====================================

-- Evento 12: 06:30-06:35 (Carro sensor 2→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 4, '2025-11-30 06:30:00', '2025-11-30 06:35:00', 'cerrado');

-- Evento 13: 11:00-11:05 (Carro sensor 1→4)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-30 11:00:00', '2025-11-30 11:05:00', 'cerrado');

-- Evento 14: 15:20-15:25 (Carro sensor 2→3)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 3, '2025-11-30 15:20:00', '2025-11-30 15:25:00', 'cerrado');

-- Evento 15: 21:00-21:05 (Carro sensor 1→2)
INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 2, '2025-11-30 21:00:00', '2025-11-30 21:05:00', 'cerrado');

-- ====================================
-- Alertas (Carro + Animal simultáneamente)
-- ====================================

-- Primero crear eventos de animales para las alertas

-- Animal evento 1: 2025-11-27 14:15 (coincide con evento_carro #3)
INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-27 14:15:00', '2025-11-27 14:18:00', 'cerrado');

-- Animal evento 2: 2025-11-28 16:20 (coincide con evento_carro #7)
INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-28 16:20:00', '2025-11-28 16:24:00', 'cerrado');

-- Animal evento 3: 2025-11-29 13:45 (coincide con evento_carro #10)
INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-29 13:45:00', '2025-11-29 13:50:00', 'cerrado');

-- Animal evento 4: 2025-11-30 15:20 (coincide con evento_carro #14)
INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-30 15:20:00', '2025-11-30 15:25:00', 'cerrado');

-- Alertas asociando carros + animales
INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (3, 1, '2025-11-27 14:15:00');

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (7, 2, '2025-11-28 16:20:00');

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (10, 3, '2025-11-29 13:45:00');

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (14, 4, '2025-11-30 15:20:00');

-- ============================================
-- Resumen de lo insertado
-- ============================================
SELECT 'Eventos de Carros por día' as tipo;
SELECT 
  DATE(hora_inicio) as dia,
  COUNT(*) as cantidad
FROM eventos_carros 
WHERE zona_id = 1
GROUP BY DATE(hora_inicio)
ORDER BY dia;

SELECT 'Total de Eventos de Carros' as tipo, COUNT(*) as cantidad FROM eventos_carros WHERE zona_id = 1;
SELECT 'Total de Eventos de Animales' as tipo, COUNT(*) as cantidad FROM eventos_animales WHERE zona_id = 1;
SELECT 'Total de Alertas' as tipo, COUNT(*) as cantidad FROM alertas;

SELECT 'Alertas detalladas' as tipo;
SELECT 
  a.id,
  ec.hora_inicio as evento_carro_inicio,
  ea.hora as evento_animal_inicio,
  a.hora as alerta_hora
FROM alertas a
JOIN eventos_carros ec ON a.evento_carro_id = ec.id
JOIN eventos_animales ea ON a.evento_animal_id = ea.id
ORDER BY a.hora;
