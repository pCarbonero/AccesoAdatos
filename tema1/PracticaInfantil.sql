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
select * from dbo.fnCalcularCosteSalarial('operations')

--4 cr. Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de todos los departamentos y el coste salarial de cada uno de ellos. 
-- Puedes usar la función del ejercicio 3.

select * from dbo.DEPT
select * from dbo.EMP



create or alter procedure MostrarCostesSalariales
AS BEGIN 
DECLARE @nomD varChar(100)

DECLARE cEj04 CURSOR FOR
SELECT DNAME FROM DEPT
OPEN cEj04

FETCH cEj04 INTO @nomD

WHILE (@@FETCH_STATUS = 0 )
BEGIN

SELECT @nomD aS nombreDept, ISNULL(s.SALARIO, 0) AS Salario
from dbo.fnCalcularCosteSalarial(@nomD) AS S
FETCH cEj04 INTO @nomD

END

CLOSE cEj04
-- Liberar los recursos
DEALLOCATE cEj04

END

execute MostrarCostesSalariales


--5. Realiza un procedimiento MostrarAbreviaturas que muestre las tres primeras letras del nombre de cada empleado.

select * from dbo.EMP

create or alter procedure MostrarAbreviaturas
AS BEGIN

declare @tres varChar(3)
	SELECT SUBSTRING(ENAME, 1, 3) AS Nombre FROM dbo.EMP
END

execute MostrarAbreviaturas

--6 cr. Realiza un procedimiento MostrarMasAntiguos que muestre el nombre del empleado más antiguo de cada departamento junto con el nombre del departamento. Trata las excepciones que consideres necesarias.

select * from EMP order by HIREDATE
select * from DEPT


create or alter procedure MostrarMasAntiguos
AS BEGIN

DECLARE @nomD varChar(50)

DECLARE cEj06 CURSOR FOR 
SELECT DNAME FROM DEPT
OPEN cEj06

FETCH cEj06 into @nomD

WHILE (@@FETCH_STATUS = 0 )
BEGIN

SELECT TOP 1 ENAME, @nomD as empleado FROM EMP AS E WHERE  exists (SELECT DEPTNO FROM DEPT AS D WHERE D.DNAME = @nomD AND D.DEPTNO = E.DEPTNO) order by HIREDATE

FETCH cEj06 INTO @nomD

END

CLOSE cEj06
-- Liberar los recursos
DEALLOCATE cEj06

END

execute MostrarMasAntiguos

--7 cr. Realiza un procedimiento MostrarJefes que reciba el nombre de un departamento y muestre los nombres de los empleados de ese departamento que son jefes de otros empleados.
-- Trata las excepciones que consideres necesarias.

select * from EMP

create or alter procedure MostrarJefes
(@nomD varchar(30))
AS BEGIN
	declare @MGR int

	declare cEj07 CURSOR FOR 
	SELECT mgr FROM EMP where DEPTNO = dbo.fnDevolverCodDept(@nomD)
	OPEN cEj07

	FETCH cEj07 into @MGR

	WHILE (@@FETCH_STATUS = 0 )
		BEGIN

			SELECT ENAME FROM EMP AS E WHERE EMPNO = @MGR

			FETCH cEj07 INTO @MGR

		END

	CLOSE cEj07
	-- Liberar los recursos
	DEALLOCATE cEj07

END

execute MostrarJefes @nomD = 'ACCOUNTING'

--8. Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres de los dos vendedores con más comisiones. Trata las excepciones que consideres necesarias.


CREATE OR ALTER PROCEDURE MostrarMejoresVendedores
AS BEGIN

select TOP 2 SAL AS SALARIO from dbo.emp where JOB = 'SALESMAN' order by sal desc

END

Execute MostrarMejoresVendedores

--10. Realiza un procedimiento RecortarSueldos que recorte el sueldo un 20% a los empleados cuyo nombre empiece por la  letra que recibe como parámetro.Trata las excepciones  que consideres necesarias

select * from EMP

CREATE OR ALTER PROCEDURE RecortarSueldos 
(@letra varChar(1))
AS BEGIN

UPDATE EMP
 SET SAL = SAL - (SAL*0.2)
 WHERE ENAME LIKE @letra+'%'

END


BEGIN TRANSACTION

execute RecortarSueldos @letra = 'S'
select * from EMP


ROLLBACK


--11 CR. Realiza un procedimiento BorrarBecarios que borre a los dos empleados más nuevos de cada departamento. Trata las excepciones que consideres necesarias.

select * from EMP
select * from DEPT

create or alter procedure BorrarBecarios
as begin

	declare @numD int

	declare crEj11 cursor for
	select DEPTNO FROM DEPT
	open crEj11

	fetch crEj11 into @numD

	WHILE (@@FETCH_STATUS = 0 )
		BEGIN

			delete EMP
			where EMPNO in (SELECT TOP 2 EMPNO from EMP where DEPTNO = @numD order by HIREDATE desc)
			

			fetch crEj11 into @numD

		END

	CLOSE crEj11
	-- Liberar los recursos
	DEALLOCATE crEj11

end

begin transaction 
execute BorrarBecarios
select * from EMP where DEPTNO = 30 order by HIREDATE desc
rollback