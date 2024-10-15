select * from dbo.libros
select * from dbo.prestamos
select * from dbo.socios

select COunt(distinct refLibro) as cantidad from prestamos
group by refLibro

select refLibro as cantidad from prestamos
group by refLibro


select s.Dni, p.FechaPrestamo from socios s 
inner join prestamos p on s.Dni = p.Dni
inner join libros l on l.RefLibro = p.RefLibro
where l.Nombre = 'El Quijote'


create or alter procedure imprimirLibros2
as begin

	declare @nombreLibro varchar(50)
	declare @vecesPrestado int
	declare @generoLibro varchar(50)

	declare @dniSocio varchar(50)
	declare @fecha date

	if exists (SELECT RefLibro from dbo.libros) AND EXISTS (SELECT Dni from dbo.socios)
	begin
		if ((select COunt(distinct refLibro) as cantidad from prestamos) < 4)
		begin
			raiserror('HAY MENOS DE 4 LIBROS PRESTADOS, SE CONTINUA CON EL PROGRAMA', 16,1)
		end	
		
		declare cLibros cursor for
	select top 4 L.Nombre, COUNT(p.RefLibro) as NumVecesPrestado, L.Genero from libros L
	inner join prestamos p on l.RefLibro = p.RefLibro
	group by l.Nombre, l.Genero
	order by NumVecesPrestado desc

	open cLibros

	fetch cLibros into @nombreLibro, @vecesPrestado, @generoLibro

	while(@@FETCH_STATUS = 0)
	begin
		print('Nombre: ' + @nombreLibro + ' | Veces prestado: ' + CONVERT(varchar, @vecesPrestado) + ' | Genero: ' + @generoLibro)

		declare cSocios cursor for
		select s.Dni, p.FechaPrestamo from socios s 
		inner join prestamos p on s.Dni = p.Dni
		inner join libros l on l.RefLibro = p.RefLibro
		where l.Nombre = @nombreLibro

		open cSocios

		fetch cSocios into @dniSocio, @fecha

		while(@@FETCH_STATUS = 0)
		begin
			print('	dni: ' + @dniSocio + ' | Fecha prestamo: ' + CONVERT(varchar, @fecha))
			fetch cSocios into @dniSocio, @fecha
		end
		close cSocios
		deallocate cSocios
		fetch cLibros into @nombreLibro, @vecesPrestado, @generoLibro
	end

	close cLibros
	deallocate cLibros



	end 
	else
	begin
		raisError('Alguna tabla está vacia', 16, 1)
	end
end

exec imprimirLibros2

