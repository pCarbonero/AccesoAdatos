
CREATE DATABASE PracticaJuvenil
Use PracticaJuvenil
--Script Ejercicio 1 Pr?ctica Juvenil
--DROP TABLE socios;

CREATE TABLE socios
(
	Dni              VARCHAR(10) CONSTRAINT s_dni_no_nulo NOT NULL,
	Nombre           VARCHAR(20) CONSTRAINT s_nom_no_nulo NOT NULL,
	Direccion        VARCHAR(20),
	Penalizaciones   int DEFAULT 0,
	CONSTRAINT socios_pk PRIMARY KEY (Dni)
);


--DROP TABLE libros;

CREATE TABLE libros
(
	RefLibro         VARCHAR(10) CONSTRAINT l_ref_no_nula NOT NULL,
	Nombre           VARCHAR(30) CONSTRAINT l_nom_no_nulo NOT NULL,
	Autor            VARCHAR(20) CONSTRAINT l_aut_no_nulo NOT NULL,
	Genero           VARCHAR(10),
	AnyoPublicacion   int, 
	Editorial        VARCHAR(10),
	CONSTRAINT libros_pk PRIMARY KEY (RefLibro)
);


--DROP TABLE prestamos;

CREATE TABLE prestamos
(
	Dni                  VARCHAR(10) CONSTRAINT p_dni_no_nulo NOT NULL,
	RefLibro             VARCHAR(10) CONSTRAINT p_lib_no_nulo NOT NULL,
	FechaPrestamo        DATE         CONSTRAINT p_fec_no_nula NOT NULL,
	Duracion             int    DEFAULT(24),
	CONSTRAINT Dni_Ref_fech_pk  PRIMARY KEY(Dni, RefLibro, FechaPrestamo),
	CONSTRAINT Dni_fk 	    FOREIGN KEY (Dni) references socios,
	CONSTRAINT Ref_fk 	    FOREIGN KEY (RefLibro) references libros
);





INSERT INTO socios VALUES ('111-A', 'David',   'Sevilla Este', 2);
INSERT INTO socios VALUES ('222-B', 'Mariano', 'Los Remedios', 3);

INSERT INTO socios (DNI, Nombre, Direccion)
VALUES ('333-C', 'Raul',    'Triana'      );

INSERT INTO socios (DNI, Nombre, Direccion)
VALUES ('444-D', 'Rocio',   'La Oliva'    );

INSERT INTO socios VALUES ('555-E', 'Marilo',  'Triana',       2);
INSERT INTO socios VALUES ('666-F', 'Benjamin','Montequinto',  5);

INSERT INTO socios (DNI, Nombre, Direccion)
VALUES ('777-G', 'Carlos',  'Los Remedios');

INSERT INTO socios VALUES ('888-H', 'Manolo',  'Montequinto',  2);


INSERT INTO libros
VALUES('E-1', 'El valor de educar', 'Savater',    'Ensayo', 1994, 'Alfaguara');
INSERT INTO libros
VALUES('N-1', 'El Quijote',         'Cervantes',  'Novela', 1602, 'Anagrama');
INSERT INTO libros
VALUES('E-2', 'La Republica',       'Plat?n',     'Ensayo', -230, 'Anagrama');
INSERT INTO libros
VALUES('N-2', 'Tombuctu',           'Auster',     'Novela', 1998, 'Planeta');
INSERT INTO libros
VALUES('N-3', 'Todos los nombres',  'Saramago',   'Novela', 1995, 'Planeta');
INSERT INTO libros
VALUES('E-3', 'Etica para Amador',  'Savater',    'Ensayo', 1991, 'Alfaguara');
INSERT INTO libros
VALUES('P-1', 'Rimas y Leyendas',   'Becquer',    'Poesia', 1837, 'Anagrama');
INSERT INTO libros
VALUES('P-2', 'Las flores del mal', 'Baudelaire', 'Poesia', 1853, 'Anagrama');
INSERT INTO libros
VALUES('P-3', 'El fulgor',          'Valente',    'Poesia', 1998, 'Alfaguara');
INSERT INTO libros
VALUES('N-4', 'Lolita',             'Nabokov',    'Novela', 1965, 'Planeta');
INSERT INTO libros
VALUES('C-1', 'En salvaje compa?ia','Rivas',      'Cuento', 2001, 'Alfaguara');


INSERT INTO prestamos VALUES('111-A','E-1', '17/12/00',24);
INSERT INTO prestamos VALUES('333-C','C-1', '15/12/01',48);
INSERT INTO prestamos VALUES('111-A','N-1', '17/12/01',24);
INSERT INTO prestamos VALUES('444-D','E-1', '17/12/01',48);
--INSERT INTO prestamos VALUES('111-A','C-2', '17/12/01',72);

INSERT INTO prestamos (DNI, RefLibro, FechaPrestamo) 
VALUES('777-G','N-1', '07/12/01');

INSERT INTO prestamos VALUES('111-A','N-1', '16/12/01',48);


select *
from libros
select *
from prestamos
select *
from socios


update libros 
set Nombre = 'En salvaje compañia'
where Nombre = 'En salvaje compa?ia'