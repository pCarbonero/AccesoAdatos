use TiendaJuvenil

select * from productos
select * from ventas


-- A1
select CodProducto, SUM(UnidadesVendidas) as TotalVendido from ventas
group by CodProducto

create procedure actualizarProductosA1 
as begin

	declare @codProducto int
	declare @udsVendidas int

	declare cA1 cursor for
	select CodProducto, SUM(UnidadesVendidas) as TotalVendido from ventas
	group by CodProducto

	open cA1

	fetch cA1 into @codProducto, @udsVendidas

	while(@@FETCH_STATUS = 0)
	begin
		update productos
		set Stock -= @udsVendidas
		where CodProducto = @codProducto
		fetch cA1 into @codProducto, @udsVendidas
	end
	close cA1
	deallocate cA1
end

begin transaction
exec actualizarProductosA1
select * from productos
select * from ventas
rollback
------------------------------------

-- A2

-- B
select * from productos
select * from ventas

select lineaproducto from productos group by LineaProducto

select p.Nombre, SUm(v.UnidadesVendidas) as ventasTotales, Sum(v.UnidadesVendidas * p.PrecioUnitario) as importeTotal from ventas v
inner join productos p on v.CodProducto = p.CodProducto
where p.LineaProducto = 'Proc'
group by p.Nombre

select Sum(v.UnidadesVendidas * p.PrecioUnitario) as importeTotal from ventas v
inner join productos p on v.CodProducto = p.CodProducto



create or alter procedure listadoVentas
as begin

	declare @lineaProd varchar(100)
	------------
	declare @nombreProd varchar(100)
	declare @udsTotales int
	declare @importe int
	-----------
	declare @importeTodo int = 0


	declare cLinea cursor for
	select lineaproducto from productos group by LineaProducto

	open cLinea

	fetch cLinea into @lineaProd

	while (@@FETCH_STATUS = 0)
	begin
		print(@lineaProd + ': ')		
		
		declare cProd cursor for
		select p.Nombre, SUm(v.UnidadesVendidas) as ventasTotales, Sum(v.UnidadesVendidas * p.PrecioUnitario) as importeTotal from ventas v
		inner join productos p on v.CodProducto = p.CodProducto
		where p.LineaProducto = @lineaProd
		group by p.Nombre

		open cProd

		fetch cProd into @nombreProd, @udsTotales, @importe

		while (@@FETCH_STATUS = 0)
		begin
			print('	'+@nombreProd +	' | Uds totales vendidas: ' + Convert(varchar, @udsTotales) + ' | Importe total: ' + Convert(varchar, @importe))
			set @importeTodo += @importe
			fetch cProd into @nombreProd, @udsTotales, @importe
		end

		close cProd
		deallocate cProd

		fetch cLinea into @lineaProd
	end
	close cLinea
	deallocate cLinea

	print('---------------------')

	print('Importe total: ' + Convert(varchar, @importeTodo))

end


exec listadoVentas