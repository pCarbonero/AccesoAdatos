select * from dbo.ALUMNOS
select * from dbo.ASIGNATURAS
select * from dbo.NOTAS

--2. Dise�a un procedimiento al que pasemos como par�metro de entrada el nombre de uno de los m�dulos existentes en la BD y visualice el nombre de los alumnos que lo han cursado junto a su nota.
--Al final del listado debe aparecer el n� de suspensos, aprobados, notables y sobresalientes.
--Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan la nota m�s alta y la m�s baja.
--Debes comprobar que las tablas tengan almacenada informaci�n y que exista el m�dulo cuyo nombre pasamos como par�metro al procedimiento. 

create or alter procedure moduloCursado
(@nombre varchar(50))
AS BEGIN
--------
declare @alumno varchar(50)
declare @notas int
declare @na varchar(50)
--------
declare @aprobados int 
declare @sobres int 
declare @notables int 
declare @suspensos int 


	if exists (SELECT Nombre from ASIGNATURAS where nombre = @nombre)
		begin
		-- //declaracion del primer cursor//
			declare alumnos cursor for
			select N.dni, N.NOTA from NOTAS AS N
			inner join ASIGNATURAS AS A ON N.COD = A.COD
			where A.NOMBRE = @nombre
			group by N.DNI, N.NOTA 

			open alumnos

			fetch alumnos into @alumno, @notas

			while (@@FETCH_STATUS = 0)
				begin 
					select @na = A.apenom from ALUMNOS as A 
					WHERE a.DNI = @alumno

					print('Nombre: ' + @na + ' | Nota: ' + CONVERT(varchar, @notas));

					fetch alumnos into @alumno, @notas
				end

			close alumnos
			deallocate alumnos
		-- //fin primer cursor//

		-- //segundo cursor//
			declare cantNotas cursor for
				select 
				ISNULL(COUNT(CASE WHEN NOTA >= 5 THEN 1 END),0) AS aprobados,
				ISNULL(COUNT(CASE WHEN NOTA >= 9 THEN 1 END),0) AS sobresalientes,
				ISNULL(COUNT(CASE WHEN NOTA >= 7 AND NOTA < 9 THEN 1 END),0) AS notables,
				ISNULL(COUNT(CASE WHEN NOTA <= 4 THEN 1 END),9) AS insuficientes
				from NOTAS
				inner join ASIGNATURAS AS A ON NOTAS.COD = A.COD
				WHERE A.NOMBRE = @nombre
			open cantNotas

			fetch cantNotas into @aprobados, @sobres, @notables, @suspensos

			while (@@FETCH_STATUS = 0)
				begin
					print('----------------------------------')
					print('Aprobados: ' + Convert(varchar, @aprobados) + CHAR(13) + CHAR(10) +
					'Sobresalientes: ' + Convert(varchar, @sobres) + CHAR(13) + CHAR(10) +
					'Notables: ' + Convert(varchar, @notables) + CHAR(13) + CHAR(10) +
					'Suspensos: ' + Convert(varchar, @suspensos) + CHAR(13) + CHAR(10))
					fetch cantNotas into @aprobados, @sobres, @notables, @suspensos
				end
			--//fin segundo cursor//
			close cantNotas
			deallocate cantNotas

		end-- fin if
		
	else
		begin
			print('No existe un m�dulo con ese nombre');
		end
END

execute moduloCursado @nombre = 'RET'