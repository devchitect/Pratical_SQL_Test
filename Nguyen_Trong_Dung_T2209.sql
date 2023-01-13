use master 
if exists (select * from sys.databases where name = 'EmployeeDB')
drop database EmployeeDB
go
-- Create DB
create database EmployeeDB
go
-- Use DB
use EmployeeDB
go
--create table
create table department(
	departId int primary key,
	departName varchar(50) not null,
	description varchar(100) not null

)
go

create table employee(
	empCode char(6) primary key,
	firstName varchar(30) not null,
	lastName varchar(30) not null,
	birthday smalldatetime not null,
	gender bit default 1,
	address varchar(100),
	departId int foreign key references department(departId),
	salary money
)
go

-- 1.insert data
insert into department(departId,departName,description)
		values
			(1,'Supervisor','Management'),
			(2,'IT','Development'),
			(3,'Marketing','Marketing for all platform'),
			(4,'Finance','Finance Service')
go
select * from department
go

insert into employee(empCode,firstName,lastName,birthday,gender,address,departId,salary)
		values
			('emp111','John','Doe','1998-12-12',1,'NewYork,USA',1,1000),
			('emp222','Jack','Doe','1995-06-15',1,'NewYork,USA',2,1500),
			('emp333','Brye','Doe','1996-08-20',0,'NewYork,USA',3,1000),
			('emp444','Dan','Nguyen','2000-12-24',1,'NewYork,USA',4,1000)
go
select * from employee
go

-- 2. increase salary for all employees by 10%
update employee
set salary *= 1.1
go

-- 3.add constraint salary > 0
alter table employee
add constraint salaryMoreThan0 check (salary > 0)
go

-- 4.create trigger birthday value > 23
create trigger tg_chkBirthday
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted WHERE Birthday <= 23)
	BEGIN
		RAISERROR('value of birthday column must be greater than 23', 16, 1);
		ROLLBACK TRANSACTION;
	end
END

-- 5.create index IX_DepartmentName	 on departName
create unique index IX_DepartmentName
on department(departName)
go

-- 6.create view
create view empWithDepart
as
	select employee.empCode as [EmployeeCode], employee.firstName as [EmployeeFullName] , employee.lastName as [EmployLastName], 
			department.departId as [DepartmentID], department.departName as [DepartmentName]
	from employee
	join department on employee.departId = department.departId
go
select * from empWithDepart
go
-- 7.create stored procedure find employee
create procedure sp_getAllEmp(@departId int)
as
	begin
		select * 
		from employee
		where departId = @departId
	end
go

-- 8. stored procedure delete employee
create procedure sp_delDept(@empId char(6))
as
	begin
		delete from employee
		where empCode = @empId
	end
go
