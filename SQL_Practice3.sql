create table Departments (
ID int not null primary key identity(1,1),
Building int not null check(Building >= 1 AND Building <= 5),
Financing money not null default 0 check(Financing >= 0),
Floor int not null check(Floor >= 1),
Name nvarchar(100) not null unique check(len(Name) > 0 )
);
create table Diseases (
ID int not null primary key identity(1,1),
Name nvarchar(100) not null unique check(len(Name) > 0),
Severity  int not null default 1 check(Severity >= 1)
);
create table Doctors(
ID int not null primary key identity(1,1),
Name nvarchar(max) not null check(len(Name) > 0),
Phone char(10) not null,
Premium money not null default 0 check(Premium >= 0),
Salary money not null check(Salary > 0),
Surname nvarchar(max) not null check(len(Surname) > 0)
);
create table Examinations(
ID int not null primary key identity(1,1),
DayOFWeek int not null check(DayOFWeek >= 1 AND DayOfWeek <= 7),
Name nvarchar(100) not null unique check(len(Name) > 0),
[StartTime] time not null,
[EndTime] time not null,
Constraint CK_StartTime check([StartTime] >= '08:00:00' AND [StartTime] <= '18:00:00'),
Constraint CK_EndTime check([EndTime] > [StartTime])
);
create table Wards(
ID int not null primary key identity(1,1),
Building int not null check(Building >= 1 AND Building <= 5),
Floor int not null check(Floor >= 1),
Name nvarchar(20) not null unique check(len(Name) > 0)
);

insert into Departments(Building, Financing, Floor, Name)
values (3, 13000.00, 3, 'A'),
		(5, 4000.00, 4, 'B'),
		(4, 600000.00, 2, 'C');
insert into Diseases(Name,Severity)
values ('Ann', 4),
		('John', 3),
		('Jack',1);
insert into Doctors (Name, Phone, Premium, Salary, Surname)
values ('Marry', '4562', 7800.00, 4500.00, 'L'),
		('Peter', '45654', 6500.00, 7800.00, 'H'),
		('Kate', '4564', 4500.00, 4780.00, 'K');
insert into Examinations(DayOFWeek,Name,StartTime,EndTime)
values (4, 'JK', '08:30', '10:00'),
	   (4, 'ML', '16:30', '17:00'),
	   (2, 'JY', '12:30', '14:00');
insert into Wards (Building,Floor,Name)
values (4,1,'Henry'),
	   (3,1,'Ann'),
	   (2,3,'John');

--1
select Building, Floor, Name
from Wards;
--2
select Surname, Phone
from Doctors;
--3
select distinct Floor
from Wards;
--4
select Name as [Name of Disease], Severity as [Severity of Disease]
from Diseases; 
--5
select D.Name as DepartmentName, DS.Name as DiseaseName, DR.Name as DoctorName
from Departments as D
join Diseases as DS on D.ID = DS.ID
join Doctors as DR on DS.ID = DR.ID
--6
select Name 
from Departments
where Building = 5 and Financing < 30000
--7
select Name 
from Departments 
where Building = 3 and Financing between 12000 and 15000
--8
select Name
from Wards
where Building in (4,5) and Floor = 1
--9
select Name, Building, Financing
from Departments
where (Building in (3,6)) and (Financing <= 11000 or Financing >= 25000)
--10
select Name 
from Doctors
where (Salary + Premium) > 1500
--11
select Surname 
from Doctors 
where (Salary / 2) > (Premium * 3)
--12
select distinct Name
from Examinations
where DayOFWeek in (1,2,3) and StartTime between '12:00:00' and '15:00:00'
--13
select Name, Building
from Departments
where Building in (1,3,8,10)
--14
select Name 
from Diseases
where Severity not in (1,2)
--15
select Name 
from Departments
where Building not in (1,3)
--16
select Name
from Departments
where Building in (1,3)
--17
select Name
from Doctors
where Surname like 'N%'