-- Dise�a un procedimiento al que pasemos como par�metro de entrada el nombre de uno de los m�dulos existentes en la BD y 
-- visualice el nombre de los alumnos que lo han cursado junto a su nota.

-- Al final del listado debe aparecer el n� de suspensos, aprobados, notables y sobresalientes.

-- Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan la nota m�s alta y la m�s baja.

-- Debes comprobar que las tablas tengan almacenada informaci�n y que exista el m�dulo cuyo nombre pasamos como par�metro al procedimiento.

select * from dbo.alumnos
select * from dbo.ASIGNATURAS
select * from dbo.NOTAS

select top 1 al.APENOM, n.NOTA from ALUMNOS al
inner join notas n on al.dni = n.DNI
inner join ASIGNATURAS asi on asi.COD = n.COD
where asi.NOMBRE = 'Entornos Gr�ficos'
order by NOTA desc
 

create or alter procedure mostrarInfoAlumnos
(@nombreAsignatura varchar(50))
as begin

	declare @nombreAlumno varchar(50)
	declare @notaAlumno int
	------
	declare @sobresalientes int = 0
	declare @notables int = 0
	declare @aprobados int = 0
	declare @suspensos int = 0
	------
	declare @notaAlta int = -1
	declare @notaBaja int = 11


	if exists (select cod from ASIGNATURAS where NOMBRE = @nombreAsignatura)
	begin 
		declare cAlumno cursor for
	select al.APENOM, n.NOTA from ALUMNOS al
	inner join notas n on al.dni = n.DNI
	inner join ASIGNATURAS asi on asi.COD = n.COD
	where asi.NOMBRE = @nombreAsignatura

	open cAlumno

	fetch cAlumno into @nombreAlumno, @notaAlumno
	while(@@FETCH_STATUS = 0)
	begin
			print('Nombre: '+@nombreAlumno+' | Nota: '+CONVERT(varchar, @notaAlumno))	


			-- PARA CALCULAR CANTIDADA DE NOTAS
			if (@notaAlumno >= 9)
			begin
				set @sobresalientes += 1
			end
			else if (@notaAlumno >= 7 AND @notaAlumno < 9)
			begin 
				set @notables += 1
			end
			else if (@notaAlumno >= 5 AND @notaAlumno < 7)
			begin 
				set @aprobados += 1
			end
			else if (@notaAlumno <= 4)
			begin 
				set @suspensos += 1
			end

			fetch cAlumno into @nombreAlumno, @notaAlumno
		end

		print('----------')
		print('Num Sobresalientes: ' + Convert(varchar, @sobresalientes))
		print('Num Notables: ' + Convert(varchar, @notables))
		print('Num Aprobados: ' + Convert(varchar, @aprobados))
		print('Num Suspensos: ' + Convert(varchar, @suspensos))
		print('----------')
	
		select top 1 @notaAlta = n.NOTA, @nombreAlumno = al.APENOM from ALUMNOS al
										inner join notas n on al.dni = n.DNI
										inner join ASIGNATURAS asi on asi.COD = n.COD
										where asi.NOMBRE = @nombreAsignatura
										order by NOTA desc
		print('Alumno con la nota m�s alta: ' + @nombreAlumno + ', ' + Convert(varchar, @notaAlta))

		select top 1 @notaBaja = n.NOTA, @nombreAlumno = al.APENOM from ALUMNOS al
									inner join notas n on al.dni = n.DNI
									inner join ASIGNATURAS asi on asi.COD = n.COD
									where asi.NOMBRE = @nombreAsignatura
									order by NOTA 
		print('Alumno con la nota m�s baja: ' + @nombreAlumno + ', ' + Convert(varchar, @notaBaja))

		close cAlumno
		deallocate cAlumno
	end
	else
	begin
		raiserror('NO EXISTE ESA ASIGNATURA', 16,1)
	end

	
end

exec mostrarInfoAlumnos @nombreAsignatura = 'Ret'