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