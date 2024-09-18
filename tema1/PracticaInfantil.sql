--1. Haz una función llamada DevolverCodDept que reciba el nombre de un departamento y devuelva su código.
	select * from dbo.DEPT

	create or alter function fnDevolverCodDept 
	(@nombreD as varChar(100))
	returns int
	as begin

	DECLARE @num as int;

	if EXISTS (SELECT * from dbo.DEPT where DNAME = @nombreD)
		BEGIN 

		SELECT @num = DEPTNO from dbo.DEPT where DNAME = @nombreD 

		END

		return @num;
	end

	select dbo.fnDevolverCodDept('ACCOUNTING') as code


--2. Realiza un procedimiento llamado HallarNumEmp que recibiendo un nombre de departamento, muestre en pantalla el número de empleados de dicho departamento. 
-- Puedes utilizar la función creada en el ejercicio 1.

-- Si el departamento no tiene empleados deberá mostrar un mensaje informando de ello. Si el departamento no existe se tratará la excepción correspondiente.

select * from dbo.EMP
select * from dbo.DEPT


create or alter procedure prHallarNumEmp 
(@nombreD as varChar(100))
AS BEGIN
SET NOCOUNT ON
declare @numD int
declare @numE int

if exists (SELECT DEPTNO FROM dbo.DEPT WHERE DNAME = @nombreD)
	begin
	
	SELECT @numD = DEPTNO FROM dbo.DEPT WHERE DNAME = @nombreD 

	SELECT @numE = COUNT(EMPNO) FROM dbo.EMP WHERE DEPTNO = @numD

	if @numE > 0
		begin
			print 'Hay ' + CAST(@numE AS VARCHAR(100)) + ' de empleados en ese departamento'
		end
	else
		begin
			print 'No hay empleados'
		end
	end
else
	begin
		print'No existe el departamento '
	end
END

execute prHallarNumEmp @nombreD = 'ACCOUNTING'

/* HICE FUNCION SINQUERER
create or alter function fnHallarNumEmp
(@nombreD as varChar(100))
returns int
As begin

declare @numD int
declare @numE int

SELECT @numD = DEPTNO FROM dbo.DEPT WHERE DNAME = @nombreD

SELECT @numE = COUNT(EMPNO) FROM dbo.EMP WHERE DEPTNO = @numD

return @numE

end

select dbo.fnHallarNumEmp('ACCOUNTING') as numerote

select dbo.fnHallarNumEmp('RESEARCH') as numerote*/

--3. Realiza una función llamada CalcularCosteSalarial que reciba un nombre de departamento y devuelva la suma de los salarios y comisiones de los empleados de dicho departamento. 
-- Trata las excepciones que consideres necesarias.

select * from dbo.EMP

create or alter function fnCalcularCosteSalarial
(@nombreD as varChar(100))
returns table	
as return 
SELECT SUM(SAL) AS SALARIO, SUM (COMM) AS COMISIONES FROM DBO.EMP WHERE DEPTNO = dbo.fnDevolverCodDept(@nombreD)

select * from fnCalcularCosteSalarial('ACCOUNTING')
select * from dbo.fnCalcularCosteSalarial('SALES')

--4 cr. Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de todos los departamentos y el coste salarial de cada uno de ellos. 
-- Puedes usar la función del ejercicio 3.

--5. Realiza un procedimiento MostrarAbreviaturas que muestre las tres primeras letras del nombre de cada empleado.

select * from dbo.EMP

create or alter procedure MostrarAbreviaturas
AS BEGIN

declare @tres varChar(3)
	SELECT SUBSTRING(ENAME, 1, 3) AS Nombre FROM dbo.EMP
END

execute MostrarAbreviaturas