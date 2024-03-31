create table Departments(
ID int not null primary key identity(1,1),
Financing money not null default 0 check(Financing >= 0),
Name nvarchar(100) not null unique check(len(Name) > 0)
);
create table Faculties(
ID int not null primary key identity(1,1),
Dean nvarchar(max) not null check(len(Dean) > 0),
Name nvarchar(100) not null unique check(len(Name) > 0),
);
create table Groups(
ID int not null primary key identity(1,1),
Name nvarchar(10) not null unique check(len(Name)> 0),
Rating int not null check(Rating >= 1 and Rating <= 5),
Year int not null check(Year >= 1 and Year <= 5)
);
create table Teachers(
ID int not null primary key identity(1,1),
EmploymentDate date not null check(EmploymentDate >= '1990-01-01'),
IsAssistant bit not null default 0,
IsProfessor bit not null default 0,
Name nvarchar(max) not null check(len(Name) > 0),
Position nvarchar(max) not null check(len(Position) > 0),
Premium money not null default 0 check(Premium >= 0),
Salary money not null default 0 check(Salary > 0),
Surname nvarchar(max) not null check(len(Surname) > 0)
);


insert into Departments (Financing, Name)
values 
	    (4000.00,'A'),
		(5000.00, 'B'),
		(6000.00, 'C');

insert into Faculties (Dean, Name)
values 
	    ('Mr.John', 'The first faculty'),
	   ('Mr.Jack', 'The second faculty'),
	   ('Ms.Ann', 'The third facultiy');

insert into Groups(Name, Rating, Year)
values 
	   ('A1', 2, 3),
	   ('A2', 3, 4),
	   ('A3', 1, 5);

insert into Teachers (EmploymentDate, IsAssistant, IsProfessor, Name, Position, Premium, Salary, Surname)
values
    ('1995-05-15', 1, 0, 'John', 'Assistant Professor', 1000.00, 50000.00, 'Smith'),
    ('2000-10-20', 0, 1, 'Alice', 'Professor', 2000.00, 60000.00, 'Johnson'),
    ('1998-03-07', 1, 0, 'Michael', 'Associate Professor', 1500.00, 55000.00, 'Williams');
--1
select *
from Departments
order by ID desc;
--2
select Name as [Group Name], Rating as [Group Rating]
from Groups;
--3
select Surname, concat(((Premium * 100) / Salary), '%')  as [Premium Percentage], 
concat((Premium * 100) / (Salary + Premium), '%') as [Salary Percentage]
from Teachers;
--4
select concat ('The dean of faculty ', Name, ' is ', Dean,'.') as [Faculty information]
from Faculties;
--5
select Surname 
from Teachers
where IsProfessor = 1 and Salary > 1050;
--6
select Name 
from Departments
where Financing  < 11000 or Financing > 25000;
--7
select Name
from Faculties
where Name <> 'Computer Science';
--8
select Surname, Position
from Teachers
where IsProfessor = 0;
--9
select Surname, Position, Salary, Premium
from Teachers
where (IsAssistant = 1) and Premium between 16 and 550;
--10
select Surname, Salary
from Teachers
where IsAssistant = 1;
--11
select Surname, Position 
from Teachers 
where EmploymentDate <= '2000-01-01';
--12
select Name as [Name of Department]
from Departments
where Name < 'Software Development'
order by Name;
--13
select Surname
from Teachers
where (IsAssistant = 1) and (Salary + Premium) <= 1200; 
--14
select Name
from Groups 
where (Year = 5) and (Rating between 2 and 4);
--15
select Surname
from Teachers
where (IsAssistant = 0) and (Premium <= 200 or Salary <=  550);