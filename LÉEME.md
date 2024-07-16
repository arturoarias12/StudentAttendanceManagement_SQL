# Gestión de Asistencia Estudiantil con SQL Server

> [Read in ENGLISH](README.md)

## Descripción
Este proyecto está diseñado para gestionar los registros de asistencia de una institución educativa (escuela) utilizando SQL Server. Incluye la creación y gestión de una base de datos que rastrea la asistencia de los estudiantes, la asignación de profesores y los horarios de clases. La estructura de la base de datos está diseñada para optimizar la asignación de profesores a los cursos y mantener información actualizada sobre la asistencia de los estudiantes, lo que ayuda a la toma de decisiones informadas para la gestión educativa.

Mayores detalles y el resumen explicativo del diseño de la base datos y ejemplos de consultas aquí:
- [Español](docs/RESUMEN_DEL_DISEÑO_Y_CONSULTAS.md)
- [Inglés](docs/DESIGN_EXPLANATION_AND_QUERIES.md)

## Estructura del Proyecto
- **src/**: Contiene los scripts SQL para crear y gestionar las tablas de la base de datos.
- **docs/**: Documentación adicional, incluidos diagramas ER y modelos lógicos.
- **notebooks/**: Notebooks de Google Colab con análisis y ejemplos de consultas a la base de datos.
- **LÉEME.md**: Este archivo, que proporciona una visión general del proyecto.
- **README.md**: Versión en inglés de este archivo.
- **LICENSE**: El archivo de licencia del proyecto.

## Instrucciones de Uso
1. Clona el repositorio:
   ```sh
   git clone https://github.com/arturoarias12/StudentAttendanceManagement_SQL/
   ```
2. Ejecuta los scripts SQL en tu entorno de SQL Server para configurar la base de datos.
3. Revisa los notebooks para ejemplos y análisis adicionales.

## Diseño de la Base de Datos

### Diseño Conceptual
El diseño conceptual incluye las entidades y relaciones involucradas en el sistema, como Estudiantes, Profesores, Cursos, Aulas y Registros de Asistencia.

### Diseño Lógico
El diseño lógico especifica la estructura de la base de datos, incluidas tablas, campos y relaciones.

### Diseño Físico
El diseño físico incluye los scripts SQL para la construcción de la base de datos, creación de las tablas e inserción de datos iniciales.

## Autores
- Alvaro Adrian Condori Anconeira
- **Arturo Alfredo Arias Aguilar**
- Carlos Goñi Caicedo
- Giancarlo Abraham Lopez Ramirez
- Lindsay Meza Perilla

## Licencia
Este proyecto está licenciado bajo una Licencia Personalizada. Consulta el archivo [LICENSE](LICENSE) para más detalles.
