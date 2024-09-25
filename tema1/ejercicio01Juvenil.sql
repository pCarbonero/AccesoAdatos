--1. Realiza un procedimiento llamado listadocuatromasprestados que nos muestre por pantalla un listado de los cuatro libros más prestados y los socios a los que han sido prestados
select * from libros
select * from dbo.prestamos

select TOP 4 Nombre, count(p.refLibro) as numPrestamos from libros as l
inner join prestamos as p ON l.RefLibro = p.RefLibro
group by l.Nombre
order by numPrestamos desc

select p.DNi, p.FechaPrestamo from prestamos as p
inner join libros as l on l.RefLibro = p.RefLibro
where l.Nombre = 'El Quijote'

create or alter procedure listadocuatromasprestados
as begin
declare @nomLibro varChar(50)
declare @vecPrest int
declare @generoLibro varChar(50)


declare libro Cursor for
select TOP 4 Nombre, count(p.refLibro) as numPrestamos, Genero from libros as l
inner join prestamos as p ON l.RefLibro = p.RefLibro
group by l.Nombre, l.Genero
order by numPrestamos desc

open libro
fetch libro into @nomLibro, @vecPrest, @generoLibro

WHILE (@@FETCH_STATUS = 0 )
BEGIN
	execute imprimirLibros @nombre = @nomLibro, @prestado = @vecPrest, @genero = @generoLibro
	fetch libro into @nomLibro, @vecPrest, @generoLibro
END
close libro
deallocate libro

end


create or alter procedure imprimirLibros 
(@nombre varChar(50), @prestado int, @genero varchar(50))
AS BEGIN

declare @dni varChar(10)
declare @fecha date

print ('Libro: ' + @nombre + '| Veces prestado: ' + CONVERT(varchar(50), @prestado) + '| Género: ' + @genero)

	declare socio cursor for
		select p.DNi, p.FechaPrestamo from prestamos as p
		inner join libros as l on l.RefLibro = p.RefLibro
		where l.Nombre = @nombre
	open socio

	fetch socio into @dni, @fecha
		WHILE (@@FETCH_STATUS = 0 )
		BEGIN

		print ('	DNI: ' + @dni + '| Fecha prestamo: ' + CONVERT(varchar(50), @fecha))
		fetch socio into @dni, @fecha

		END
	close socio
	deallocate socio


END

execute listadocuatromasprestados