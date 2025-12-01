-- Datos nuevos: Primer carro sin animal, luego segundo carro con animal
-- PRIMER CARRO (sin animal)
-- Carro en sensor 1
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 35, 200, 190, 210, false, 500, 60.5, 25.3, false, NOW());

-- Carro avanza a sensor 2
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 40, 190, 210, false, 500, 60.5, 25.3, false, NOW() + interval '1 second');

-- Carro avanza a sensor 3
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 38, 210, false, 500, 60.5, 25.3, false, NOW() + interval '2 seconds');

-- Carro avanza a sensor 4
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 42, false, 500, 60.5, 25.3, false, NOW() + interval '3 seconds');

-- Primer carro saliendo (fuera de rango)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 250, 240, 260, 230, false, 500, 60.5, 25.3, false, NOW() + interval '4 seconds');

-- Pausa de 6 segundos para que el primer evento se cierre (EVENT_TIMEOUT_SECONDS = 5)
-- (El worker procesará en background)

-- SEGUNDO CARRO (CON ANIMAL)
-- Carro en sensor 1 + animal presente (movimiento)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 38, 200, 190, 210, true, 500, 60.5, 25.3, false, NOW() + interval '10 seconds');

-- Carro avanza a sensor 2 + animal sigue presente
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 42, 190, 210, true, 500, 60.5, 25.3, false, NOW() + interval '11 seconds');

-- Carro avanza a sensor 3 + animal presente
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 40, 210, true, 500, 60.5, 25.3, false, NOW() + interval '12 seconds');

-- Carro avanza a sensor 4 + animal presente
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 45, true, 500, 60.5, 25.3, false, NOW() + interval '13 seconds');

-- Segundo carro saliendo + animal se va
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 250, 240, 260, 230, false, 500, 60.5, 25.3, false, NOW() + interval '14 seconds');
