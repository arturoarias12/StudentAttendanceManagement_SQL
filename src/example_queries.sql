-- 1. Consultar la asistencia de un alumno en un día determinado
SELECT
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre completo',
a.asistencia, reg.fecha, c.nombre_curso
FROM Alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
WHERE al.id_alumno = 1 AND reg.fecha = '2024-01-03'

-- 2. Ver la lista de asistencia de un curso en un día determinado
SELECT
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre completo',
a.asistencia, reg.fecha, c.nombre_curso
FROM Alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
WHERE reg.fecha = '2024-01-03' AND c.id_curso = 1;

-- 3. Encontrar la cantidad de faltas de los alumnos de un grado y sección determinado
SELECT aul.grado, aul.seccion AS 'sección', COUNT(a.id_alumno) AS 'cantidad_faltas'
FROM alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
JOIN aulas aul ON al.id_aula = aul.id_aula
WHERE a.asistencia = 0 -- o "inasistencia" o "false"
AND aul.grado = 1 -- Poner el grado específico
AND aul.seccion = 'A' -- Usar A o B
GROUP BY aul.grado, aul.seccion
ORDER BY cantidad_faltas DESC;

-- 4. Porcentaje de asistencia de un alumno en un curso, se le aplicó redondeo a 2 decimales y cambio de tipo de dato
SELECT
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre_completo',
c.nombre_curso,
CONCAT(CAST(ROUND(SUM(CASE WHEN a.asistencia = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id_alumno), 2) AS DECIMAL(5, 2)), '%') AS 'porcentaje_asistencia'
FROM alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
JOIN aulas aul ON al.id_aula = aul.id_aula
WHERE al.id_alumno = 1 AND c.id_curso = 1
GROUP BY
al.nombres,
al.apellido_paterno,
al.apellido_materno,
c.nombre_curso;

-- 5. Porcentaje de asistencia de un alumno en todos sus cursos
SELECT
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre_completo',
c.nombre_curso,
(SUM(CASE WHEN a.asistencia = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id_alumno)) AS 'porcentaje_asistencia'
FROM alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
JOIN aulas aul ON al.id_aula = aul.id_aula
WHERE al.id_alumno = 1
GROUP BY
al.nombres,
al.apellido_paterno,
al.apellido_materno,
c.nombre_curso;

sp_help grado_y_seccion

-- 6. Promedio de asistencia de alumnos de un grado y nivel determinado
SELECT aul.grado, aul.seccion, aul.nivel,
(SUM(CASE WHEN a.asistencia = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id_alumno)) AS porcentaje_asistencia
FROM alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
JOIN aulas aul ON al.id_aula = aul.id_aula
WHERE
aul.nivel = 'primaria'
AND aul.grado = 1
GROUP BY
aul.grado,
aul.seccion,
aul.nivel,
al.id_aula;

-- 7. Porcentaje de asistencia de los grados y secciones de secundaria, pero aplicando una tabla temporal y afinando el resultado del porcentaje obtenido
WITH asistenciaporalumno AS (
SELECT al.id_aula, aul.grado, aul.seccion, aul.nivel,
(SUM(CASE WHEN a.asistencia = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id_alumno)) AS porcentaje_asistencia
FROM Alumnos al
JOIN Asistencia a ON al.id_alumno = a.id_alumno
JOIN Registros reg ON a.id_registro = reg.id_registro
JOIN Aulas aul ON al.id_aula = aul.id_aula
GROUP BY
al.id_aula,
aul.grado,
aul.seccion,
aul.nivel
)
SELECT ap.grado, ap.seccion, ap.nivel,
CONCAT(CAST(ROUND(AVG(ap.porcentaje_asistencia), 2) AS DECIMAL(5, 2)), '%') AS 'porcentaje_asistencia'
FROM asistenciaporalumno ap
WHERE
ap.nivel = 'secundaria'
GROUP BY
ap.grado,
ap.seccion,
ap.nivel;

-- 8. Consultar las asistencias de un alumno hasta una fecha determinada
SELECT
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre completo',
a.asistencia, reg.fecha, c.nombre_curso
FROM Alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
WHERE
al.id_alumno = 1
AND reg.fecha >= '2024-01-01'
AND reg.fecha <= '2024-05-05'
ORDER BY nombre_curso DESC;


-- 9. Calificar a los alumnos según su porcentaje de asistencia, en caso tengan más del 50%, calificar como "bien", sino "llamar a padres de familia"
WITH asistenciaporalumno AS (
SELECT al.id_alumno, CONCAT(al.nombres, ' ', al.apellido_paterno, ' ', al.apellido_materno) AS 'nombre_completo',
SUM(CASE WHEN a.asistencia = 1 THEN 1 ELSE 0 END) AS 'total_asistencias',
COUNT(*) AS total_registros,
SUM(CASE WHEN a.asistencia = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS 'porcentaje_asistencia'
FROM alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
GROUP BY
al.id_alumno, al.nombres, al.apellido_paterno, al.apellido_materno
)
SELECT
    nombre_completo, total_asistencias, total_registros,
	CONCAT(CAST(ROUND(porcentaje_asistencia, 2) AS DECIMAL(5, 2)), '%') AS 'porcentaje_asistencia',
    CASE WHEN porcentaje_asistencia > 50 THEN 'Está bien'
    ELSE 'Llamar a padres de familia'
    END AS estado_asistencia
FROM
    asistenciaporalumno;