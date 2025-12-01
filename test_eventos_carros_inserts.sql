-- ============================================
-- Solo INSERTS de evento_carro y alerta
-- Para ZONA 1 con 4 días diferentes
-- ============================================

-- ====================================
-- DÍA 1: 2025-11-27
-- ====================================

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-27 06:00:00', '2025-11-27 06:05:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 3, '2025-11-27 10:30:00', '2025-11-27 10:35:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 3, 4, '2025-11-27 14:15:00', '2025-11-27 14:18:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 2, '2025-11-27 18:45:00', '2025-11-27 18:50:00', 'cerrado');

-- ====================================
-- DÍA 2: 2025-11-28
-- ====================================

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 3, '2025-11-28 07:00:00', '2025-11-28 07:04:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 4, '2025-11-28 12:30:00', '2025-11-28 12:36:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-28 16:20:00', '2025-11-28 16:24:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 3, '2025-11-28 20:00:00', '2025-11-28 20:05:00', 'cerrado');

-- ====================================
-- DÍA 3: 2025-11-29
-- ====================================

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-29 08:15:00', '2025-11-29 08:20:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 3, 4, '2025-11-29 13:45:00', '2025-11-29 13:50:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 3, '2025-11-29 19:30:00', '2025-11-29 19:35:00', 'cerrado');

-- ====================================
-- DÍA 4: 2025-11-30
-- ====================================

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 4, '2025-11-30 06:30:00', '2025-11-30 06:35:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 4, '2025-11-30 11:00:00', '2025-11-30 11:05:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 2, 3, '2025-11-30 15:20:00', '2025-11-30 15:25:00', 'cerrado');

INSERT INTO eventos_carros (zona_id, sensor_inicial, sensor_final, hora_inicio, hora_fin, estado)
VALUES (1, 1, 2, '2025-11-30 21:00:00', '2025-11-30 21:05:00', 'cerrado');

-- ====================================
-- Eventos de Animales
-- ====================================

INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-27 14:15:00', '2025-11-27 14:18:00', 'cerrado');

INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-28 16:20:00', '2025-11-28 16:24:00', 'cerrado');

INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-29 13:45:00', '2025-11-29 13:50:00', 'cerrado');

INSERT INTO eventos_animales (zona_id, hora, hora_fin, estado)
VALUES (1, '2025-11-30 15:20:00', '2025-11-30 15:25:00', 'cerrado');

-- ====================================
-- Alertas
-- ====================================

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (1, 1, '2025-11-27 14:15:00');

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (7, 2, '2025-11-28 16:20:00');

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (11, 3, '2025-11-29 13:45:00');

INSERT INTO alertas (evento_carro_id, evento_animal_id, hora)
VALUES (15, 4, '2025-11-30 15:20:00');
