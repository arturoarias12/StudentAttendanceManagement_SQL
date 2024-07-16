# Database Explanation and Queries

## Conceptual Design
The conceptual design outlines the entities and relationships in the system. Here's an overview:

### Overview
Students participate in classes, and their presence is tracked through attendance records. Each day, an attendance record is created for every course conducted in each classroom. These classrooms are assigned to specific grades and sections, such as 1st "B" of secondary school.

It is assumed that teachers are versatile and may instruct multiple courses across various classrooms and grade levels. It is important to note that just because a teacher is assigned to a course in one section does not mean they teach the same course in other sections of the same grade.

Every day, teachers are responsible for creating these attendance records. This ensures that student attendance is documented daily for each course they attend. To simplify this demonstration, we are assuming that the same courses are conducted every day.

Moreover, the database schema has been designed to align with the Peruvian educational system, which organizes students into specific grades and sections.

The conceptual design can be graphically viewed here:

![Conceptual Design](docs/conceptual_design.pdf)

### Entities and Relationships
- **Students**: Represents the students.
- **Teachers**: Represents the teachers.
- **Courses**: Represents the courses.
- **Classrooms**: Represents the classrooms.
- **Records**: Represents the attendance records.
- **Attendance**: Represents the attendance relationship between students and records.

### Relationships
- **Students** have **Attendance** records (N:M relationship).
- **Teachers** create **Records** (1:N relationship).
- **Courses** take place in **Classrooms** (N:M relationship).
- **Records** are created for each course and classroom each day (N:M relationship with Courses and Classrooms).
- **Records** have a **date** attribute.

## Logical Design
The logical design specifies the structure of the database, including tables, fields, and relationships.

### Tables and Fields
- **Students**
  - `id_alumno` (integer, primary key)
  - `nombres` (varchar)
  - `apellido_paterno` (varchar)
  - `apellido_materno` (varchar)
  - `fecha_nacimiento` (date)
  - `dni` (integer)
  - `correo` (varchar)
  - `id_aula` (integer, foreign key to Classrooms)

- **Teachers**
  - `id_profesor` (integer, primary key)
  - `nombres_profesor` (varchar)
  - `apellido_paterno` (varchar)
  - `apellido_materno` (varchar)
  - `fecha_nacimiento` (date)
  - `dni_profesor` (integer)

- **Courses**
  - `id_curso` (integer, primary key)
  - `nombre_curso` (varchar)
  - `horas` (integer)

- **Classrooms**
  - `id_aula` (integer, primary key)
  - `grado` (integer)
  - `seccion` (varchar)
  - `nivel` (varchar)
  - `numero_aula` (integer)

- **Records**
  - `id_registro` (integer, primary key)
  - `fecha` (date)
  - `id_aula` (integer, foreign key to Classrooms)
  - `id_profesor` (integer, foreign key to Teachers)
  - `id_curso` (integer, foreign key to Courses)

- **Attendance**
  - `id_alumno` (integer, foreign key to Students)
  - `id_registro` (integer, foreign key to Records)
  - `asistencia` (boolean)

### Relationships
- **Students** have attendance records tracked in **Attendance** (N:M relationship).
- **Teachers** create daily **Records** (1:N relationship).
- **Courses** occur in **Classrooms** (N:M relationship).
- **Records** are linked to **Courses**, **Classrooms**, and **Teachers** (1:N relationships).
- **Records** have a `fecha` (date) attribute.

The logical design can be graphically viewed here:

![Logical Design](docs/diseño_logico.pdf)

## Example Queries
Here are some example queries to demonstrate how to interact with the database (all queries were originally written in Spanish and may need to be translated):

### Query 1: Retrieve the attendance of a student on a specific day
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

### Query 2: View the attendance list for a course on a specific day
```sql
CONCAT(al.nombres,' ', al.apellido_paterno,' ',al.apellido_materno ) AS 'nombre completo',
a.asistencia, reg.fecha, c.nombre_curso
FROM Alumnos al
JOIN asistencia a ON al.id_alumno = a.id_alumno
JOIN registros reg ON a.id_registro = reg.id_registro
JOIN cursos c ON reg.id_curso = c.id_curso
WHERE reg.fecha = '2024-01-03' AND c.id_curso = 1;
```

### Query 3: Find the number of absences for students in a specific grade and section
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

### Query 4: Attendance percentage of a student in a course, rounded to 2 decimal places and type converted
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

### Query 5: Attendance percentage of a student in all their courses
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

### Query 6: Average attendance of students in a specific grade and level
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

### Query 7: Attendance percentage of grades and sections in secondary school, using a temporary table to refine the percentage result
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

### Query 8: Retrieve the attendance of a student up to a specific date
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

### Query 9: Grade students based on their attendance percentage: if above 50%, grade as "good"; otherwise, "call parents"
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
