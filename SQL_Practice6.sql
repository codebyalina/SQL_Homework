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

--PRACTISE 5

--6
select count(*) as DoctorCount, sum(Salary + Premium) as TotalSalary
from Doctors;

--7
select avg(Salary + Premium) as AverageSalary
from Doctors;

--PRACTISE 6
--1
select distinct D1.Name
from Departments D1
join Departments D2 on D1.Building = D2.Building
where D2.Name = 'Cardiology';

--2
select distinct D1.Name
from Departments D1
join Departments D2 on D1.Building = D2.Building
where D2.Name in ('Gastroenterology', 'General Surgery');

--3
select top 1 Name
from Departments
order by Financing;

--4
select Surname
from Doctors
where Salary + Premium > (select Salary + Premium from Doctors where Surname = 'Gerada' and Name = 'Thomas');

--6
select concat(Name, ' ', Surname) as Full_Name
from Doctors
where Salary + Premium > 100 * (select Salary + Premium from Doctors where Surname = 'Davis' and Name = 'Anthony');

--8
select distinct S.Name
from Sponsors S
left join Donations D on S.ID = D.SponsorID
left join Departments Dep on D.DepartmentID = Dep.ID
where Dep.Name not in ('Neurology', 'Oncology') or Dep.Name is null;

--9
select distinct Surname
from Doctors
join Examinations on Doctors.Name = Examinations.Name
where Examinations.StartTime >= '12:00:00' and Examinations.EndTime <= '15:00:00';

--TRIGGERS
--1
create trigger SetDefaultSeverity
on Diseases
instead of insert
as
begin
    insert into  Diseases (Name, Severity)
    select name, coalesce(Severity, 1) from inserted;
end;

--2
create trigger CheckExamTime
on Examinations
after insert, update
as
begin
    if exists (select 1 from inserted where StartTime > EndTime)
    begin
        raiserror ('Start Time cannot be later than End Time.', 16, 1)
        rollback transaction;
        return;
    end;
end;

--3
create trigger SetPremiumPercentage
on Doctors
after insert
as
begin
    update Doctors
    set Premium = inserted.Salary * 0.1
    from Doctors
    inner join inserted on Doctors.ID = inserted.ID;
end;
