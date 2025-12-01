-- Datos nuevos como si vinieron del sensor (carro detectado pasando por sensores)
-- Carro en sensor 1
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 35, 200, 190, 210, true, 500, 60.5, 25.3, false, NOW());

-- Carro avanza a sensor 2
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 40, 190, 210, true, 500, 60.5, 25.3, false, NOW() + interval '1 second');

-- Carro avanza a sensor 3
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 38, 210, true, 500, 60.5, 25.3, false, NOW() + interval '2 seconds');

-- Carro avanza a sensor 4
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 42, true, 500, 60.5, 25.3, false, NOW() + interval '3 seconds');

-- Carro saliendo (fuera de rango)
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 250, 240, 260, 230, false, 500, 60.5, 25.3, false, NOW() + interval '4 seconds');
