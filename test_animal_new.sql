-- Datos nuevos: Animal cruzando sin carro
-- Animal detectado por movimiento
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 500, 60.5, 25.3, false, NOW());

-- Animal continúa
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 500, 60.5, 25.3, false, NOW() + interval '1 second');

-- Animal continúa
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, true, 500, 60.5, 25.3, false, NOW() + interval '2 seconds');

-- Animal se va
INSERT INTO mediciones (zona_id, distancia_1, distancia_2, distancia_3, distancia_4, movimiento, luz, humedad, temperatura, procesado, hora) 
VALUES (1, 200, 180, 190, 210, false, 500, 60.5, 25.3, false, NOW() + interval '3 seconds');
