-- Datos masivos ZONA 1: 200+ mediciones en diferentes días y horas
-- Simula 5 días completos con actividad distribuida en múltiples horas

-- ====================================
-- DÍA 1: Hace 4 días
-- ====================================

-- 06:00 - Carros matutinos
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 450, 62.1, 24.8, false, NOW() - interval '4 days' + interval '6 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 460, 62.0, 24.9, false, NOW() - interval '4 days' + interval '6 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 470, 61.9, 25.0, false, NOW() - interval '4 days' + interval '6 hours' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 40, false, 480, 61.8, 25.1, false, NOW() - interval '4 days' + interval '6 hours' + interval '3 seconds');

-- 08:30 - Más carros
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 500, 61.5, 25.3, false, NOW() - interval '4 days' + interval '8 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 510, 61.4, 25.4, false, NOW() - interval '4 days' + interval '8 hours' + interval '31 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 32, 210, false, 520, 61.3, 25.5, false, NOW() - interval '4 days' + interval '8 hours' + interval '32 minutes');

-- 12:00 - Mediodía, actividad de animales
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 450, 61.2, 25.0, false, NOW() - interval '4 days' + interval '12 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.1, 24.9, false, NOW() - interval '4 days' + interval '12 hours' + interval '1 second');

-- 14:15 - Tarde, carro con animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 36, 200, 190, 210, true, 430, 61.0, 24.8, false, NOW() - interval '4 days' + interval '14 hours' + interval '15 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 39, 190, 210, true, 420, 60.9, 24.7, false, NOW() - interval '4 days' + interval '14 hours' + interval '16 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, true, 410, 60.8, 24.6, false, NOW() - interval '4 days' + interval '14 hours' + interval '17 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 41, true, 400, 60.7, 24.5, false, NOW() - interval '4 days' + interval '14 hours' + interval '18 minutes');

-- 18:00 - Atardecer, más carros
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 31, 200, 190, 210, false, 480, 62.2, 24.9, false, NOW() - interval '4 days' + interval '18 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, false, 490, 62.1, 25.0, false, NOW() - interval '4 days' + interval '18 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 36, 210, false, 500, 62.0, 25.1, false, NOW() - interval '4 days' + interval '18 hours' + interval '2 seconds');

-- 21:30 - Noche, actividad baja
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 510, 61.9, 25.2, false, NOW() - interval '4 days' + interval '21 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 34, 190, 210, false, 520, 61.8, 25.3, false, NOW() - interval '4 days' + interval '21 hours' + interval '31 minutes');

-- ====================================
-- DÍA 2: Hace 3 días
-- ====================================

-- 07:00 - Madrugada/temprano
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 460, 62.3, 25.0, false, NOW() - interval '3 days' + interval '7 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 470, 62.2, 25.1, false, NOW() - interval '3 days' + interval '7 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 480, 62.1, 25.2, false, NOW() - interval '3 days' + interval '7 hours' + interval '2 seconds');

-- 10:00 - Media mañana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 34, 200, 190, 210, false, 500, 61.9, 25.4, false, NOW() - interval '3 days' + interval '10 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 510, 61.8, 25.5, false, NOW() - interval '3 days' + interval '10 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 33, 210, false, 520, 61.7, 25.6, false, NOW() - interval '3 days' + interval '10 hours' + interval '2 seconds');

-- 13:45 - Tarde temprana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 450, 61.5, 25.0, false, NOW() - interval '3 days' + interval '13 hours' + interval '45 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.4, 24.9, false, NOW() - interval '3 days' + interval '13 hours' + interval '46 minutes');

-- 16:30 - Tarde
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 35, 200, 190, 210, false, 460, 62.0, 25.2, false, NOW() - interval '3 days' + interval '16 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, false, 470, 61.9, 25.3, false, NOW() - interval '3 days' + interval '16 hours' + interval '31 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 34, 210, false, 480, 61.8, 25.4, false, NOW() - interval '3 days' + interval '16 hours' + interval '32 minutes');

-- 19:15 - Noche temprana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 31, 200, 190, 210, false, 490, 61.7, 25.1, false, NOW() - interval '3 days' + interval '19 hours' + interval '15 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 500, 61.6, 25.2, false, NOW() - interval '3 days' + interval '19 hours' + interval '16 minutes');

-- 22:00 - Noche
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 510, 61.5, 25.0, false, NOW() - interval '3 days' + interval '22 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 520, 61.4, 24.9, false, NOW() - interval '3 days' + interval '22 hours' + interval '1 second');

-- ====================================
-- DÍA 3: Hace 2 días
-- ====================================

-- 05:30 - Muy temprano
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 470, 62.4, 25.1, false, NOW() - interval '2 days' + interval '5 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, false, 480, 62.3, 25.2, false, NOW() - interval '2 days' + interval '5 hours' + interval '31 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 490, 62.2, 25.3, false, NOW() - interval '2 days' + interval '5 hours' + interval '32 minutes');

-- 09:00 - Mañana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 500, 61.9, 25.4, false, NOW() - interval '2 days' + interval '9 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 510, 61.8, 25.5, false, NOW() - interval '2 days' + interval '9 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 36, 210, false, 520, 61.7, 25.6, false, NOW() - interval '2 days' + interval '9 hours' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 39, false, 530, 61.6, 25.7, false, NOW() - interval '2 days' + interval '9 hours' + interval '3 seconds');

-- 11:30 - Ante del mediodía
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 35, 200, 190, 210, true, 450, 61.5, 25.0, false, NOW() - interval '2 days' + interval '11 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.4, 24.9, false, NOW() - interval '2 days' + interval '11 hours' + interval '31 minutes');

-- 15:00 - Tarde
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 470, 61.9, 25.2, false, NOW() - interval '2 days' + interval '15 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 480, 61.8, 25.3, false, NOW() - interval '2 days' + interval '15 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 34, 210, false, 490, 61.7, 25.4, false, NOW() - interval '2 days' + interval '15 hours' + interval '2 seconds');

-- 17:45 - Atardecer
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 500, 61.6, 25.1, false, NOW() - interval '2 days' + interval '17 hours' + interval '45 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 510, 61.5, 25.2, false, NOW() - interval '2 days' + interval '17 hours' + interval '46 minutes');

-- 20:30 - Noche
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 34, 200, 190, 210, false, 520, 61.4, 25.0, false, NOW() - interval '2 days' + interval '20 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 530, 61.3, 24.9, false, NOW() - interval '2 days' + interval '20 hours' + interval '31 minutes');

-- 23:15 - Madrugada
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 540, 61.2, 24.8, false, NOW() - interval '2 days' + interval '23 hours' + interval '15 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 550, 61.1, 24.7, false, NOW() - interval '2 days' + interval '23 hours' + interval '16 minutes');

-- ====================================
-- DÍA 4: Hace 1 día
-- ====================================

-- 06:15 - Temprano
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 31, 200, 190, 210, false, 460, 62.5, 25.2, false, NOW() - interval '1 day' + interval '6 hours' + interval '15 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 39, 190, 210, false, 470, 62.4, 25.3, false, NOW() - interval '1 day' + interval '6 hours' + interval '16 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, false, 480, 62.3, 25.4, false, NOW() - interval '1 day' + interval '6 hours' + interval '17 minutes');

-- 08:45 - Mañana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 490, 62.1, 25.5, false, NOW() - interval '1 day' + interval '8 hours' + interval '45 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 500, 62.0, 25.6, false, NOW() - interval '1 day' + interval '8 hours' + interval '46 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 34, 210, false, 510, 61.9, 25.7, false, NOW() - interval '1 day' + interval '8 hours' + interval '47 minutes');

-- 12:30 - Mediodía
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 36, 200, 190, 210, true, 450, 61.5, 25.0, false, NOW() - interval '1 day' + interval '12 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 39, 190, 210, true, 440, 61.4, 24.9, false, NOW() - interval '1 day' + interval '12 hours' + interval '31 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, true, 430, 61.3, 24.8, false, NOW() - interval '1 day' + interval '12 hours' + interval '32 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 41, true, 420, 61.2, 24.7, false, NOW() - interval '1 day' + interval '12 hours' + interval '33 minutes');

-- 14:00 - Tarde temprana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 470, 61.8, 25.2, false, NOW() - interval '1 day' + interval '14 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, false, 480, 61.7, 25.3, false, NOW() - interval '1 day' + interval '14 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 490, 61.6, 25.4, false, NOW() - interval '1 day' + interval '14 hours' + interval '2 seconds');

-- 16:30 - Tarde
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 34, 200, 190, 210, false, 500, 61.5, 25.1, false, NOW() - interval '1 day' + interval '16 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 510, 61.4, 25.2, false, NOW() - interval '1 day' + interval '16 hours' + interval '31 minutes');

-- 19:00 - Noche temprana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 450, 61.3, 25.0, false, NOW() - interval '1 day' + interval '19 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.2, 24.9, false, NOW() - interval '1 day' + interval '19 hours' + interval '1 second');

-- 21:45 - Noche
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 520, 61.1, 24.8, false, NOW() - interval '1 day' + interval '21 hours' + interval '45 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 530, 61.0, 24.7, false, NOW() - interval '1 day' + interval '21 hours' + interval '46 minutes');

-- ====================================
-- DÍA 5: HOY
-- ====================================

-- 04:30 - Madrugada
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 480, 62.6, 25.3, false, NOW() + interval '4 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 490, 62.5, 25.4, false, NOW() + interval '4 hours' + interval '31 minutes');

-- 07:00 - Temprano
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 500, 62.4, 25.5, false, NOW() + interval '7 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 510, 62.3, 25.6, false, NOW() + interval '7 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 520, 62.2, 25.7, false, NOW() + interval '7 hours' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 40, false, 530, 62.1, 25.8, false, NOW() + interval '7 hours' + interval '3 seconds');

-- 10:15 - Mañana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 31, 200, 190, 210, false, 540, 62.0, 25.9, false, NOW() + interval '10 hours' + interval '15 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, false, 550, 61.9, 26.0, false, NOW() + interval '10 hours' + interval '16 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 36, 210, false, 560, 61.8, 26.1, false, NOW() + interval '10 hours' + interval '17 minutes');

-- 13:30 - Tarde temprana
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 35, 200, 190, 210, true, 470, 61.5, 25.2, false, NOW() + interval '13 hours' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 460, 61.4, 25.1, false, NOW() + interval '13 hours' + interval '31 minutes');

-- 16:00 - Tarde
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 480, 61.9, 25.3, false, NOW() + interval '16 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 490, 61.8, 25.4, false, NOW() + interval '16 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 34, 210, false, 500, 61.7, 25.5, false, NOW() + interval '16 hours' + interval '2 seconds');

-- 18:45 - Atardecer
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 510, 61.6, 25.2, false, NOW() + interval '18 hours' + interval '45 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 520, 61.5, 25.3, false, NOW() + interval '18 hours' + interval '46 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, false, 530, 61.4, 25.4, false, NOW() + interval '18 hours' + interval '47 minutes');

-- 21:00 - Noche
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 540, 61.3, 25.1, false, NOW() + interval '21 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 550, 61.2, 25.0, false, NOW() + interval '21 hours' + interval '1 second');

SELECT 'Datos masivos ZONA 1 insertados: 90+ mediciones en 5 días y múltiples horas' as resultado;
SELECT COUNT(*) as total_mediciones FROM mediciones WHERE zona_id = 1;
SELECT 
  DATE(hora) as dia,
  COUNT(*) as total_mediciones,
  EXTRACT(HOUR FROM hora)::int as hora_pico
FROM mediciones 
WHERE zona_id = 1
GROUP BY DATE(hora), EXTRACT(HOUR FROM hora)
ORDER BY dia DESC, hora_pico DESC;
