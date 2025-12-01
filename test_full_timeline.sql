-- Datos simulados: Período de 2 minutos con múltiples eventos aleatorios
-- Simula: 2 carros sin animal, 1 animal solo, 1 carro con animal

-- Evento 1: Carro 1 cruzando (sin animal)
-- 00:00 - Carro 1 en sensor 1
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 32, 200, 190, 210, false, 450, 62.1, 24.8, false, NOW());

-- 00:01
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 38, 190, 210, false, 460, 62.0, 24.9, false, NOW() + interval '1 second');

-- 00:02
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 35, 210, false, 470, 61.9, 25.0, false, NOW() + interval '2 seconds');

-- 00:03
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 40, false, 480, 61.8, 25.1, false, NOW() + interval '3 seconds');

-- 00:04 - Carro 1 saliendo
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 250, 240, 260, 230, false, 490, 61.7, 25.2, false, NOW() + interval '4 seconds');

-- Espera 4 segundos (baseline)
-- 00:08
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, false, 500, 61.5, 25.3, false, NOW() + interval '8 seconds');

-- Evento 2: Animal solo (solo movimiento, sin detección ultrasónica)
-- 00:10 - Animal detectado
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 480, 61.4, 25.2, false, NOW() + interval '10 seconds');

-- 00:11 - Animal continúa
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 470, 61.3, 25.1, false, NOW() + interval '11 seconds');

-- 00:12 - Animal se va
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, false, 460, 61.2, 25.0, false, NOW() + interval '12 seconds');

-- Espera 5 segundos (baseline y timeout para animal)
-- 00:17
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, false, 500, 61.0, 25.3, false, NOW() + interval '17 seconds');

-- Evento 3: Carro 2 con animal
-- 00:20 - Carro 2 + animal en sensor 1
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 36, 200, 190, 210, true, 450, 61.5, 25.2, false, NOW() + interval '20 seconds');

-- 00:21 - Carro 2 + animal en sensor 2
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 39, 190, 210, true, 455, 61.6, 25.3, false, NOW() + interval '21 seconds');

-- 00:22 - Carro 2 + animal en sensor 3
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 37, 210, true, 460, 61.7, 25.4, false, NOW() + interval '22 seconds');

-- 00:23 - Carro 2 + animal en sensor 4
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 41, true, 465, 61.8, 25.5, false, NOW() + interval '23 seconds');

-- 00:24 - Carro 2 + animal saliendo
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 250, 240, 260, 230, false, 470, 61.9, 25.6, false, NOW() + interval '24 seconds');

-- Espera 6 segundos (baseline y timeout para evento)
-- 00:30
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, false, 500, 62.0, 25.3, false, NOW() + interval '30 seconds');

-- Evento 4: Carro 3 cruzando rápido (sin animal)
-- 00:35 - Carro 3 en sensor 1
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 30, 200, 190, 210, false, 480, 62.1, 25.1, false, NOW() + interval '35 seconds');

-- 00:36 - Carro 3 en sensor 2
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 36, 190, 210, false, 490, 62.2, 25.2, false, NOW() + interval '36 seconds');

-- 00:37 - Carro 3 en sensor 3
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 33, 210, false, 495, 62.3, 25.3, false, NOW() + interval '37 seconds');

-- 00:38 - Carro 3 en sensor 4
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 38, false, 500, 62.4, 25.4, false, NOW() + interval '38 seconds');

-- 00:39 - Carro 3 saliendo
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 250, 240, 260, 230, false, 505, 62.5, 25.5, false, NOW() + interval '39 seconds');

-- Baseline final
-- 00:45
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, false, 500, 62.0, 25.3, false, NOW() + interval '45 seconds');
