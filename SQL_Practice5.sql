Create table Departments (
    Id int primary key identity(1,1) not null,
    Building int not null check (Building between 1 and 5),
    Name nvarchar(100) not null unique
);

Create table Doctors (
    Id int primary key identity(1,1) not null,
    Name nvarchar(max) not null,
    Premium money not null default 0,
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null
);

create table Doctorsexaminations (
    Id int primary key identity(1,1) not null,
    Doctorid int not null,
    Examinationid int not null,
    Wardid int not null,
    Foreign key (doctorid) references doctors(id),
    Foreign key (examinationid) references Examinations(id),
    Foreign key (wardid) references Wards(id),
	[StartTime] time not null,
	[EndTime] time not null,
	Constraint CK_StartTime check([StartTime] >= '08:00:00' AND [StartTime] <= '18:00:00'),
	Constraint CK_EndTime check([EndTime] > [StartTime])
);

Create table Examinations (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

Create table Wards (
    Id int primary key identity(1,1) not null,
    Name nvarchar(20) not null unique,
    Places int not null check (Places >= 1),
    Departmentid int not null,
    Foreign key (Departmentid) references Departments(id)
);


insert into Departments (Building, Name) values
(1, 'Department A'),
(2, 'Department B'),
(3, 'Department C'),
(4, 'Department D'),
(5, 'Department E');


insert into Doctors (Name, Premium, Salary, Surname) values
('John Doe', 500, 3000, 'Doe'),
('Jane Smith', 600, 3500, 'Smith'),
('Michael Johnson', 700, 4000, 'Johnson');


insert into Examinations (Name) values
('Blood Test'),
('MRI Scan'),
('X-Ray'),
('Ultrasound');

insert into Wards (Name, Places, Departmentid) values
('Ward 1', 10, 1),
('Ward 2', 15, 2),
('Ward 3', 12, 3),
('Ward 4', 20, 4),
('Ward 5', 8, 5);

insert into Doctorsexaminations (Doctorid, Examinationid, Wardid, Starttime, Endtime) values
(1, 1, 1, '08:30:00', '10:00:00'),
(2, 2, 2, '10:30:00', '12:00:00'),
(3, 3, 3, '13:00:00', '14:30:00');

--Practise5
--1
select count(*) as TotalWards
from Wards
where Places > 10;

--2
select D.Name as BuildingName, count(W.Id) as TotalWards
from Departments D
left join Wards W on D.Id = W.DepartmentId
group by D.Name;

--3
select D.Name as DepartmentName, count(W.Id) as TotalWards
from Departments D
left join Wards W on D.Id = W.DepartmentId
group by D.Name;

--4
select D.Name as DepartmentName, sum(Doc.Premium) as TotalPremium
from Departments D
left join Wards W on D.Id = W.DepartmentId
left join Doctors Doc on W.DepartmentId = Doc.Id
group by D.Name;

--5
select D.Name as DepartmentName
from Departments D
inner join Wards W on D.Id = W.DepartmentId
inner join Doctorsexaminations DE on W.Id = DE.Wardid
group by D.Name
having count(distinct DE.Doctorid) >= 5;

--8
select Name as WardName
from Wards
where Places = (select min(Places) from Wards);

--9
select D.Name as BuildingName
from Departments D
inner join Wards W on D.Id = W.DepartmentId
where D.Building in (1, 6, 7, 8)
group by D.Name
having sum(W.Places) > 100 and count(W.Id) > 1;

--Practice6
--5
select W.Name as WardName
from Wards W
inner join Departments D on W.Departmentid = D.Id
where D.Name = 'Microbiology'
and W.Places > (
select avg(Places)
from Wards
where Departmentid = D.Id
);

--7
select distinct D.Name as DepartmentName
from Departments D
inner join Wards W on D.Id = W.Departmentid
inner join Doctorsexaminations DE on W.Id = DE.Wardid
inner join Doctors Doc on DE.Doctorid = Doc.Id
where Doc.Name = 'Joshua Bell';








