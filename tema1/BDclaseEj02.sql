
create database ClaseEj02
use ClaseEj02
DROP ALUMNOS cascade constraints;

CREATE TABLE ALUMNOS
(
  DNI VARCHAR(10) NOT NULL,
  APENOM VARCHAR(30),
  DIREC VARCHAR(30),
  POBLA  VARCHAR(15),
  TELEF  VARCHAR(10)  
)

DROP TABLE ASIGNATURAS cascade constraints;

CREATE TABLE ASIGNATURAS
(
  COD int NOT NULL,
  NOMBRE VARCHAR(25)
) 

DROP TABLE NOTAS cascade constraints;

CREATE TABLE NOTAS
(
  DNI VARCHAR(10) NOT NULL,
  COD int NOT NULL,
  NOTA int
)

INSERT INTO ASIGNATURAS VALUES (1,'Prog. Leng. Estr.');
INSERT INTO ASIGNATURAS VALUES (2,'Sist. Inform�ticos');
INSERT INTO ASIGNATURAS VALUES (3,'An�lisis');
INSERT INTO ASIGNATURAS VALUES (4,'FOL');
INSERT INTO ASIGNATURAS VALUES (5,'RET');
INSERT INTO ASIGNATURAS VALUES (6,'Entornos Gr�ficos');
INSERT INTO ASIGNATURAS VALUES (7,'Aplic. Entornos 4�Gen');

INSERT INTO ALUMNOS VALUES
('12344345','Alcalde Garc�a, Elena', 'C/Las Matas, 24','Madrid','917766545');

INSERT INTO ALUMNOS VALUES
('4448242','Cerrato Vela, Luis', 'C/Mina 28 - 3A', 'Madrid','916566545');

INSERT INTO ALUMNOS VALUES
('56882942','D�az Fern�ndez, Mar�a', 'C/Luis Vives 25', 'M�stoles','915577545');

INSERT INTO NOTAS VALUES('12344345', 1,6);
INSERT INTO NOTAS VALUES('12344345', 2,5);
INSERT INTO NOTAS VALUES('12344345', 3,6);

INSERT INTO NOTAS VALUES('4448242', 4,6);
INSERT INTO NOTAS VALUES('4448242', 5,8);
INSERT INTO NOTAS VALUES('4448242', 6,4);
INSERT INTO NOTAS VALUES('4448242', 7,5);

INSERT INTO NOTAS VALUES('56882942', 5,7);
INSERT INTO NOTAS VALUES('56882942', 6,8);
INSERT INTO NOTAS VALUES('56882942', 7,9);

COMMIT;