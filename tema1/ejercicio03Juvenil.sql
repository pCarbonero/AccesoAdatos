--03 a) Realiza un procedimiento que actualice la columna Stock de la tabla Productos a partir de los registros de la tabla Ventas.
--El citado procedimiento debe informarnos por pantalla si alguna de las tablas está vacía o si el stock de un producto pasa a ser negativo, 
--en cuyo caso se parará la actualización.

--a.1) Suponemos que se han realizado una serie de Ventas (todos los registros añadidos en la tabla Ventas), 
-- así debemos realizar un procedimiento para actualizar la tabla Productos con las ventas realizadas que están en la tabla Ventas.

select * from dbo.ventas
select * from dbo.productos

select CodProducto, sum(UnidadesVendidas) as uds from dbo.ventas group by CodProducto



create or alter procedure quitarStock
as begin
	declare @cod int
	declare @cant int

	declare crVentas cursor for
	select CodProducto, sum(UnidadesVendidas) as uds from dbo.ventas group by CodProducto
	open crVentas

	fetch crVentas into @cod, @cant

	while (@@FETCH_STATUS = 0)
	begin

		if (@cant <= (select Stock from productos where CodProducto = @cod))
		begin
			update productos
			set Stock = Stock - @cant
			where @cod = CodProducto
		end
		else 
		begin
			print('no se puede actualizar el producto' + CONVERT(varchar, @cod))
		end
		fetch crVentas into @cod, @cant
	end
	
	close crVentas
	deallocate crVentas

end

begin transaction
exec quitarStock

select * from dbo.productos
select CodProducto, sum(UnidadesVendidas) as uds from dbo.ventas group by CodProducto

rollback

-- a.2) Mediante Triggers: Tenemos la tabla Ventas y Productos, debemos actualizar la tabla Productos con las modificaciones 
-- o inserciones que se hagan en la tabla Ventas de la siguiente forma:
-- Si se aumentan las unidades vendidas de una venta ya realizada (me pasarán el código de la venta, el código del producto y las unidades vendidas), 
--se deberá actualizar el Stock de la tabla Productos.
-- Si se realiza una devolución de una venta (me pasan el código de la venta, el código del producto y las unidades devueltas), 
--se deberá actualizar el Stock de la tabla Productos. Hay que tener en cuenta que si se devuelven todas las unidades que habían sido vendidas, 
--se deberá borrar esa venta de la tabla Ventas.

select * from ventas
select * from productos

CREATE or alter PROCEDURE reducirStock
@codProdPr int, @nuevaVentaPr int, @antiguaVentaPr int
AS BEGIN
	update productos
	set Stock = Stock - (@nuevaVentaPr-@antiguaVentaPr)
	where CodProducto = @codProdPr
END

CREATE or alter PROCEDURE aumentarStock
@codProdPr int, @nuevaVentaPr int, @antiguaVentaPr int
AS BEGIN
	update productos
	set Stock = Stock + (@antiguaVentaPr-@nuevaVentaPr)
	where CodProducto = @codProdPr
END


create or alter trigger tr_ventas
on Ventas
after update
as begin
	set nocount on
	declare @codProducto int
	declare @antiguaVenta int
	declare @nuevaVenta int
	declare @codVenta varchar(10)

	select @antiguaVenta = UnidadesVendidas from deleted 
	select @nuevaVenta = UnidadesVendidas from inserted
	select @codProducto = CodProducto from inserted
	select @codVenta = codVenta from inserted

	select * from inserted

	if (@antiguaVenta < @nuevaVenta)
	begin
		exec reducirStock @codProdPR = @codProducto, @nuevaVentaPr = @nuevaVenta, @antiguaVentaPr = @antiguaVenta
	end

	else if (@antiguaVenta > @nuevaVenta)
	begin
		exec aumentarStock @codProdPR = @codProducto, @nuevaVentaPr = @nuevaVenta, @antiguaVentaPr = @antiguaVenta
	end

	if (@antiguaVenta - @nuevaVenta = 0)
	begin
		delete From ventas where CodVenta = @codVenta
	end

end


begin transaction

update Ventas 
set UnidadesVendidas = 7
where CodProducto = 4 AND CodVenta = 'V16'

rollback

select * from ventas
select * from productos

select Sum(UnidadesVendidas) from ventas where CodProducto = 4

select UnidadesVendidas from ventas where CodProducto = 4 AND CodVenta = 'V16'


-- b) Realiza un procedimiento que presente por pantalla un listado de las ventas con el siguiente formato:
select * from ventas where CodProducto = 1 or CodProducto = 5 or CodProducto = 7
select * from productos 


select lineaProducto from productos

select p.nombre, sum(v.UnidadesVendidas) as Ventastotal, sum(p.PrecioUnitario * v.UnidadesVendidas) as imoprte from productos p
inner join ventas v on v.CodProducto = p.CodProducto
where p.LineaProducto = 'Proc'
group by p.CodProducto, p.Nombre




create or alter procedure mostrarLn
as begin
	
	declare @lineaPr varchar(50)
	declare @codProd int
	declare @udsTotales int
	declare @importeTotal int
	declare @nombre varchar(50)

	declare crLinea cursor for
	select lineaProducto from productos group by LineaProducto
	open crLinea 
	
	fetch crLinea into @lineaPr

	while (@@FETCH_STATUS = 0)
	begin
		print('Linea producto: ' + @lineaPr)

		declare crVentas cursor for
		select p.Nombre, sum(v.UnidadesVendidas) as Ventastotal, sum(p.PrecioUnitario * v.UnidadesVendidas) as imoprte from productos p
		inner join ventas v on v.CodProducto = p.CodProducto
		where p.LineaProducto = @lineaPr
		group by p.CodProducto, p.Nombre

		open crVentas

		fetch crVentas into @nombre, @udsTotales, @importeTotal

		while (@@FETCH_STATUS = 0)
		begin
			print(Concat_ws('|', '	', @nombre, @udsTotales, @importeTotal))
			fetch crVentas into @nombre, @udsTotales, @importeTotal
		end

		close crVentas
		deallocate crVentas

		fetch crLinea into @lineaPr
	end
		close crLinea
		deallocate crLinea

end 

exec mostrarLn