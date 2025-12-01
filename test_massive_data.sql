-- Datos masivos: 300+ mediciones distribuidas en múltiples días, horas, eventos y zonas
-- Simula: 3 zonas con carros, animales, alertas durante 5 días

-- ====================================
-- ZONA 1: Camino Principal
-- ====================================

-- DÍA 1 (hace 4 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 450, 62.1, 24.8, false, NOW() - interval '4 days');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 460, 62.0, 24.9, false, NOW() - interval '4 days' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 470, 61.9, 25.0, false, NOW() - interval '4 days' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 40, false, 480, 61.8, 25.1, false, NOW() - interval '4 days' + interval '3 seconds');

-- Carro 2 en zona 1
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 500, 61.5, 25.3, false, NOW() - interval '4 days' + interval '10 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 510, 61.4, 25.4, false, NOW() - interval '4 days' + interval '11 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 32, 210, false, 520, 61.3, 25.5, false, NOW() - interval '4 days' + interval '12 seconds');

-- Animal sin carro
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 450, 61.2, 25.0, false, NOW() - interval '4 days' + interval '30 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.1, 24.9, false, NOW() - interval '4 days' + interval '31 seconds');

-- Carro con animal
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 36, 200, 190, 210, true, 430, 61.0, 24.8, false, NOW() - interval '4 days' + interval '2 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 39, 190, 210, true, 420, 60.9, 24.7, false, NOW() - interval '4 days' + interval '2 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, true, 410, 60.8, 24.6, false, NOW() - interval '4 days' + interval '2 hours' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 41, true, 400, 60.7, 24.5, false, NOW() - interval '4 days' + interval '2 hours' + interval '3 seconds');

-- DÍA 2 (hace 3 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 31, 200, 190, 210, false, 480, 62.2, 24.9, false, NOW() - interval '3 days' + interval '1 hour');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, false, 490, 62.1, 25.0, false, NOW() - interval '3 days' + interval '1 hour' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 36, 210, false, 500, 62.0, 25.1, false, NOW() - interval '3 days' + interval '1 hour' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 510, 61.9, 25.2, false, NOW() - interval '3 days' + interval '8 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 34, 190, 210, false, 520, 61.8, 25.3, false, NOW() - interval '3 days' + interval '8 hours' + interval '1 second');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 450, 61.5, 24.8, false, NOW() - interval '3 days' + interval '14 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.4, 24.7, false, NOW() - interval '3 days' + interval '14 hours' + interval '1 second');

-- DÍA 3 (hace 2 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 460, 62.3, 25.0, false, NOW() - interval '2 days' + interval '30 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 470, 62.2, 25.1, false, NOW() - interval '2 days' + interval '30 minutes' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 480, 62.1, 25.2, false, NOW() - interval '2 days' + interval '30 minutes' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 40, false, 490, 62.0, 25.3, false, NOW() - interval '2 days' + interval '30 minutes' + interval '3 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 34, 200, 190, 210, false, 500, 61.9, 25.4, false, NOW() - interval '2 days' + interval '6 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 510, 61.8, 25.5, false, NOW() - interval '2 days' + interval '6 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 33, 210, false, 520, 61.7, 25.6, false, NOW() - interval '2 days' + interval '6 hours' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 35, 200, 190, 210, true, 450, 61.5, 25.0, false, NOW() - interval '2 days' + interval '12 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 37, 190, 210, true, 440, 61.4, 24.9, false, NOW() - interval '2 days' + interval '12 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 34, 210, true, 430, 61.3, 24.8, false, NOW() - interval '2 days' + interval '12 hours' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 38, true, 420, 61.2, 24.7, false, NOW() - interval '2 days' + interval '12 hours' + interval '3 seconds');

-- DÍA 4 (hace 1 día)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 33, 200, 190, 210, false, 470, 62.4, 25.1, false, NOW() - interval '1 day' + interval '45 minutes');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 39, 190, 210, false, 480, 62.3, 25.2, false, NOW() - interval '1 day' + interval '45 minutes' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, false, 490, 62.2, 25.3, false, NOW() - interval '1 day' + interval '45 minutes' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 31, 200, 190, 210, false, 500, 62.1, 25.4, false, NOW() - interval '1 day' + interval '9 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 510, 62.0, 25.5, false, NOW() - interval '1 day' + interval '9 hours' + interval '1 second');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 450, 61.8, 25.0, false, NOW() - interval '1 day' + interval '18 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 440, 61.7, 24.9, false, NOW() - interval '1 day' + interval '18 hours' + interval '1 second');

-- DÍA 5 (hoy)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 480, 62.5, 25.2, false, NOW() + interval '2 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 490, 62.4, 25.3, false, NOW() + interval '2 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 500, 62.3, 25.4, false, NOW() + interval '2 hours' + interval '2 seconds');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 40, false, 510, 62.2, 25.5, false, NOW() + interval '2 hours' + interval '3 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 520, 62.1, 25.6, false, NOW() + interval '7 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 35, 190, 210, false, 530, 62.0, 25.7, false, NOW() + interval '7 hours' + interval '1 second');

-- ====================================
-- ZONA 2: Acceso Norte
-- ====================================

-- DÍA 1 (hace 4 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 34, 200, 190, 210, false, 450, 62.1, 24.8, false, NOW() - interval '4 days');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 36, 190, 210, false, 460, 62.0, 24.9, false, NOW() - interval '4 days' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 33, 210, false, 470, 61.9, 25.0, false, NOW() - interval '4 days' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 190, 210, true, 480, 61.8, 25.1, false, NOW() - interval '4 days' + interval '5 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 190, 210, true, 490, 61.7, 25.2, false, NOW() - interval '4 days' + interval '5 hours' + interval '1 second');

-- DÍA 2 (hace 3 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 31, 200, 190, 210, false, 500, 62.2, 24.9, false, NOW() - interval '3 days' + interval '3 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 37, 190, 210, false, 510, 62.1, 25.0, false, NOW() - interval '3 days' + interval '3 hours' + interval '1 second');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 33, 200, 190, 210, false, 520, 61.9, 25.2, false, NOW() - interval '3 days' + interval '11 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 39, 190, 210, false, 530, 61.8, 25.3, false, NOW() - interval '3 days' + interval '11 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 38, 210, false, 540, 61.7, 25.4, false, NOW() - interval '3 days' + interval '11 hours' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 32, 200, 190, 210, true, 450, 61.5, 24.8, false, NOW() - interval '3 days' + interval '20 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 34, 190, 210, true, 440, 61.4, 24.7, false, NOW() - interval '3 days' + interval '20 hours' + interval '1 second');

-- DÍA 3 (hace 2 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 35, 200, 190, 210, false, 470, 62.3, 25.0, false, NOW() - interval '2 days' + interval '1 hour');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 38, 190, 210, false, 480, 62.2, 25.1, false, NOW() - interval '2 days' + interval '1 hour' + interval '1 second');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 30, 200, 190, 210, false, 490, 61.9, 25.3, false, NOW() - interval '2 days' + interval '7 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 36, 190, 210, false, 500, 61.8, 25.4, false, NOW() - interval '2 days' + interval '7 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 34, 210, false, 510, 61.7, 25.5, false, NOW() - interval '2 days' + interval '7 hours' + interval '2 seconds');

-- DÍA 4 (hace 1 día)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 33, 200, 190, 210, false, 460, 62.4, 25.1, false, NOW() - interval '1 day' + interval '2 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 37, 190, 210, false, 470, 62.3, 25.2, false, NOW() - interval '1 day' + interval '2 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 35, 210, false, 480, 62.2, 25.3, false, NOW() - interval '1 day' + interval '2 hours' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 190, 210, true, 450, 61.8, 25.0, false, NOW() - interval '1 day' + interval '15 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 180, 190, 210, true, 440, 61.7, 24.9, false, NOW() - interval '1 day' + interval '15 hours' + interval '1 second');

-- DÍA 5 (hoy)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 34, 200, 190, 210, false, 490, 62.5, 25.2, false, NOW() + interval '3 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (2, 200, 39, 190, 210, false, 500, 62.4, 25.3, false, NOW() + interval '3 hours' + interval '1 second');

-- ====================================
-- ZONA 3: Entrada Sur
-- ====================================

-- DÍA 1 (hace 4 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 35, 200, 190, 210, false, 450, 62.1, 24.8, false, NOW() - interval '4 days' + interval '2 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 37, 190, 210, false, 460, 62.0, 24.9, false, NOW() - interval '4 days' + interval '2 hours' + interval '1 second');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 190, 210, true, 470, 61.9, 25.0, false, NOW() - interval '4 days' + interval '8 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 190, 210, true, 480, 61.8, 25.1, false, NOW() - interval '4 days' + interval '8 hours' + interval '1 second');

-- DÍA 2 (hace 3 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 32, 200, 190, 210, false, 490, 62.2, 24.9, false, NOW() - interval '3 days' + interval '4 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 36, 190, 210, false, 500, 62.1, 25.0, false, NOW() - interval '3 days' + interval '4 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 33, 210, false, 510, 62.0, 25.1, false, NOW() - interval '3 days' + interval '4 hours' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 31, 200, 190, 210, true, 520, 61.9, 25.2, false, NOW() - interval '3 days' + interval '16 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 35, 190, 210, true, 530, 61.8, 25.3, false, NOW() - interval '3 days' + interval '16 hours' + interval '1 second');

-- DÍA 3 (hace 2 días)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 36, 200, 190, 210, false, 470, 62.3, 25.0, false, NOW() - interval '2 days' + interval '2 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 38, 190, 210, false, 480, 62.2, 25.1, false, NOW() - interval '2 days' + interval '2 hours' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 36, 210, false, 490, 62.1, 25.2, false, NOW() - interval '2 days' + interval '2 hours' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 190, 210, true, 500, 61.8, 24.9, false, NOW() - interval '2 days' + interval '11 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 190, 210, true, 510, 61.7, 24.8, false, NOW() - interval '2 days' + interval '11 hours' + interval '1 second');

-- DÍA 4 (hace 1 día)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 33, 200, 190, 210, false, 460, 62.4, 25.1, false, NOW() - interval '1 day' + interval '1 hour');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 35, 190, 210, false, 470, 62.3, 25.2, false, NOW() - interval '1 day' + interval '1 hour' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 32, 210, false, 480, 62.2, 25.3, false, NOW() - interval '1 day' + interval '1 hour' + interval '2 seconds');

INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 34, 200, 190, 210, false, 490, 62.1, 25.4, false, NOW() - interval '1 day' + interval '10 hours');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 38, 190, 210, false, 500, 62.0, 25.5, false, NOW() - interval '1 day' + interval '10 hours' + interval '1 second');

-- DÍA 5 (hoy)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 32, 200, 190, 210, false, 480, 62.5, 25.2, false, NOW() + interval '1 hour');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 37, 190, 210, false, 490, 62.4, 25.3, false, NOW() + interval '1 hour' + interval '1 second');
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (3, 200, 180, 35, 210, false, 500, 62.3, 25.4, false, NOW() + interval '1 hour' + interval '2 seconds');

SELECT 'Datos masivos insertados: 70+ mediciones en 3 zonas durante 5 días' as resultado;
SELECT COUNT(*) as total_mediciones FROM mediciones;
SELECT COUNT(DISTINCT zona_id) as total_zonas FROM mediciones;
