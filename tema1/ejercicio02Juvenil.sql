select * from dbo.ALUMNOS
select * from dbo.ASIGNATURAS
select * from dbo.NOTAS

--2. Diseña un procedimiento al que pasemos como parámetro de entrada el nombre de uno de los módulos existentes en la BD y visualice el nombre de los alumnos que lo han cursado junto a su nota.
--Al final del listado debe aparecer el nº de suspensos, aprobados, notables y sobresalientes.
--Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan la nota más alta y la más baja.
--Debes comprobar que las tablas tengan almacenada información y que exista el módulo cuyo nombre pasamos como parámetro al procedimiento. 

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
--------
declare @mejorA varchar(50)
declare @mejorN int
declare @peorA varchar(50)
declare @peorN int


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

			select @aprobados = ISNULL(COUNT(CASE WHEN NOTA >= 5 THEN 1 END),0) from dbo.NOTAS
				inner join ASIGNATURAS AS A ON NOTAS.COD = A.COD
				WHERE A.NOMBRE = @nombre
			select @sobres = ISNULL(COUNT(CASE WHEN NOTA >= 9 THEN 1 END),0) from dbo.NOTAS
							inner join ASIGNATURAS AS A ON NOTAS.COD = A.COD
				WHERE A.NOMBRE = @nombre
			select @notables = ISNULL(COUNT(CASE WHEN NOTA >= 7 AND NOTA < 9 THEN 1 END),0) from dbo.NOTAS
							inner join ASIGNATURAS AS A ON NOTAS.COD = A.COD
				WHERE A.NOMBRE = @nombre
			select @suspensos = ISNULL(COUNT(CASE WHEN NOTA < 5 THEN 1 END),0) from dbo.NOTAS
							inner join ASIGNATURAS AS A ON NOTAS.COD = A.COD
				WHERE A.NOMBRE = @nombre


			print('Aprobados: ' + Convert(varchar, @aprobados) + CHAR(13) + CHAR(10) +
					'Sobresalientes: ' + Convert(varchar, @sobres) + CHAR(13) + CHAR(10) +
					'Notables: ' + Convert(varchar, @notables) + CHAR(13) + CHAR(10) +
					'Suspensos: ' + Convert(varchar, @suspensos) + CHAR(13) + CHAR(10))

		-- para acabal
		select TOP 1 @mejorA = Al.APENOM, @mejorN = N.NOTA from ALUMNOS AS AL
		inner join NOTAS AS N ON AL.DNI = N.DNI
		INNER JOIN ASIGNATURAS AS A ON N.COD = A.COD
		where A.NOMBRE = @nombre
		order by N.NOTA desc

		select TOP 1 @peorA = Al.APENOM, @peorN = N.NOTA from ALUMNOS AS AL
		inner join NOTAS AS N ON AL.DNI = N.DNI
		INNER JOIN ASIGNATURAS AS A ON N.COD = A.COD
		where A.NOMBRE = @nombre
		order by N.NOTA 
					
		print('Mejor nota: ' + @mejorA + ', ' + CONVERT(varchar, @mejorN) + CHAR(13) + CHAR(10) +
		'Sobresalientes: ' + @peorA + ', ' + CONVERT(varchar, @peorN))

		end-- fin if
		
	else
		begin
			print('No existe un módulo con ese nombre');
		end
END

execute moduloCursado @nombre = 'RET'