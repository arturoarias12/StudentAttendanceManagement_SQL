-- Sistema de asistencia en un colegio con nivel primaria y secundaria
-- Crear base de datos
CREATE DATABASE grupo12_trabajo;
GO

USE grupo12_trabajo;
GO

-- Tabla Aulas
CREATE TABLE Aulas (
    id_aula INT PRIMARY KEY IDENTITY(1,1),
    grado INT,
    seccion VARCHAR(50),
    nivel VARCHAR(50),
    numero_aula INT
);
GO

-- Tabla Alumnos
CREATE TABLE Alumnos (
    id_alumno INT PRIMARY KEY IDENTITY(1,1),
    nombres VARCHAR(50),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    fecha_nacimiento DATE,
    dni INT,
    correo VARCHAR(50),
    id_aula INT,
    FOREIGN KEY (id_aula) REFERENCES Aulas(id_aula)
);
GO

-- Tabla Cursos
CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY IDENTITY(1,1),
    nombre_curso VARCHAR(50),
    horas INT
);
GO

-- Tabla Profesores
CREATE TABLE Profesores (
    id_profesor INT PRIMARY KEY IDENTITY(1,1),
    nombres_profesor VARCHAR(50),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    fecha_nacimiento DATE,
    dni_profesor INT
);
GO

-- Tabla Registros
CREATE TABLE Registros (
    id_registro INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE,
    id_aula INT,
    id_profesor INT,
    id_curso INT,
    FOREIGN KEY (id_aula) REFERENCES Aulas(id_aula),
    FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);
GO

-- Tabla Asistencia
CREATE TABLE Asistencia (
    id_alumno INT,
    id_registro INT,
    asistencia BIT,
    PRIMARY KEY (id_alumno, id_registro),
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_registro) REFERENCES Registros(id_registro)
);
GO