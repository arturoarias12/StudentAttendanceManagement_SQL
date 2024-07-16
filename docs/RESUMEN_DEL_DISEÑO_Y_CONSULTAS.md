# Explicación de la base de datos y consultas

## Diseño conceptual
El diseño conceptual describe las entidades y relaciones en el sistema. Aquí hay una visión general:

### Visión general
Los estudiantes participan en clases y su presencia se rastrea a través de registros de asistencia. Cada día, se crea un registro de asistencia para cada curso que se lleva a cabo en cada aula. Estas aulas están asignadas a grados y secciones específicos, como 1° "B" de secundaria.

Se asume que los profesores son versátiles y pueden enseñar múltiples cursos en diferentes aulas y niveles de grado. Es importante notar que el hecho de que un profesor esté asignado a un curso en una sección no implica que enseñe el mismo curso en otras secciones del mismo grado.

Cada día, los profesores son responsables de crear estos registros de asistencia. Esto asegura que la asistencia de los estudiantes se documente diariamente para cada curso que asisten. Para simplificar esta demostración, estamos asumiendo que se imparten los mismos cursos todos los días.

Además, el esquema de la base de datos ha sido diseñado para alinearse con el sistema educativo peruano, que organiza a los estudiantes en grados y secciones específicos.

El diseño conceptual se puede ver gráficamente aquí:

![Diseño Conceptual](docs/diseño_conceptual.pdf)

### Entities and Relationships
- **Alumnos**: Represents the students.
- **Profesores**: Represents the teachers.
- **Cursos**: Represents the courses.
- **Aulas**: Represents the classrooms.
- **Registros**: Represents the attendance records.
- **Asistencia**: Represents the attendance relationship between students and records.

### Relaciones
- Los **Alumnos** tienen **Asistencia** en registros (relación N:M).
- Los **Profesores** crean **Registros** diariamente (relación 1:N).
- Los **Cursos** suceden en **Aulas** (relación N:M).
- Los **Registros** se crean para cada curso y aula cada día (relación N:M con Cursos y Aulas).
- Los **Registros** tienen un atributo `fecha`

## Diseño lógico
El diseño lógico especifica la estructura de la base de datos, incluyendo tablas, campos y relaciones.

### Tablas y campos
- **Alumnos**
  - `id_alumno` (integer, llave primaria)
  - `nombres` (varchar)
  - `apellido_paterno` (varchar)
  - `apellido_materno` (varchar)
  - `fecha_nacimiento` (date)
  - `dni` (integer)
  - `correo` (varchar)
  - `id_aula` (integer, llave foránea a Aulas)

- **Profesores**
  - `id_profesor` (integer, llave primaria)
  - `nombres_profesor` (varchar)
  - `apellido_paterno` (varchar)
  - `apellido_materno` (varchar)
  - `fecha_nacimiento` (date)
  - `dni_profesor` (integer)

- **Cursos**
  - `id_curso` (integer, llave primaria)
  - `nombre_curso` (varchar)
  - `horas` (integer)

- **Aulas**
  - `id_aula` (integer, llave primaria)
  - `grado` (integer)
  - `seccion` (varchar)
  - `nivel` (varchar)
  - `numero_aula` (integer)

- **Registros**
  - `id_registro` (integer, llave primaria)
  - `fecha` (date)
  - `id_aula` (integer, llave foránea a Aulas)
  - `id_profesor` (integer, llave foránea a Profesores)
  - `id_curso` (integer, llave foránea a Cursos)

- **Asistencia**
  - `id_alumno` (integer, llave foránea a Alumnos)
  - `id_registro` (integer, llave foránea a Registros)
  - `asistencia` (boolean)

### Relaciones
- Los **Estudiantes** tienen registros de asistencia rastreados en **Asistencia** (relación N:M).
- Los **Profesores** crean registros diarios en **Registros** (relación 1:N).
- Los **Cursos** ocurren en **Aulas** (relación N:M).
- Los **Registros** están vinculados a **Cursos**, **Aulas** y **Profesores** (relaciones 1:N).
- Los **Registros** tienen un atributo `fecha`.

El diseño lógico se puede ver gráficamente aquí:

![Diseño Lógico](docs/diseño_logico.pdf)

## Consultas de ejemplo
Aquí hay algunas consultas de ejemplo para demostrar cómo interactuar con la base de datos:

### Consulta 1: Asistencia de un alumno en un día determinado
```sql
SELECT
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre completo',
a.asistencia, reg.fecha, c.nombre_curso
FROM Alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
WHERE al.id_alumno = 1 AND reg.fecha = '2024-01-03'
```

### Consulta 2: Ver la lista de asistencia de un curso en un día determinado
```sql
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre completo',
a.asistencia, reg.fecha, c.nombre_curso
FROM Alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
WHERE reg.fecha = '2024-01-03' AND c.id_curso = 1;
```

### Consulta 3: Encontrar la cantidad de faltas de los alumnos de un grado y sección determinado
```sql
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
```

### Consulta 4: Porcentaje de asistencia de un alumno en un curso, se le aplicó redondeo a 2 decimales y cambio de tipo de dato
```sql
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
```

### Consulta 5: Porcentaje de asistencia de un alumno en todos sus cursos
```sql
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
```

### Consulta 6: Promedio de asistencia de alumnos de un grado y nivel determinado
```sql
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
```

### Consulta 7: Porcentaje de asistencia de los grados y secciones de secundaria, pero aplicando una tabla temporal y afinando el resultado del porcentaje obtenido
```sql
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
```

### Consulta 8: Consultar las asistencias de un alumno hasta una fecha determinada
```sql
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
```

### Consulta 9: Calificar a los alumnos según su porcentaje de asistencia, en caso tengan más del 50%, calificar como "bien", sino "llamar a padres de familia"
```sql
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
```
