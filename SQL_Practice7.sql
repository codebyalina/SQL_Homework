create table Departments (
    Id int primary key identity(1,1) not null,
    Building int not null check (Building between 1 and 5),
    Financing money not null default 0,
    Name nvarchar(100) not null unique
);

create table Diseases (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

create table Doctors (
    Id int primary key identity(1,1) not null,
    Name nvarchar(max) not null,
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null
);

create table DoctorsExaminations (
    Id int primary key identity(1,1) not null,
    Date date not null check (Date <= getdate()),
    DiseaseId int not null,
    DoctorId int not null,
    ExaminationId int not null,
    WardId int not null,
    foreign key (DiseaseId) references Diseases(Id),
    foreign key (DoctorId) references Doctors(Id),
    foreign key (ExaminationId) references Examinations(Id),
    foreign key (WardId) references Wards(Id)
);

create table Examinations (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

create table Inters (
    Id int primary key identity(1,1) not null,
    DoctorId int not null,
    foreign key (DoctorId) references Doctors(Id)
);

create table Professors (
    Id int primary key identity(1,1) not null,
    DoctorId int not null,
    foreign key (DoctorId) references Doctors(Id)
);

create table Wards (
    Id int primary key identity(1,1) not null,
    Name nvarchar(20) not null unique,
    Places int not null check (Places >= 1),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(Id)
);

insert into Departments (Building, Financing, Name) values
(1, 300000, 'Orthopedics'),
(2, 250000, 'Neurology'),
(3, 400000, 'Cardiology');

insert into Diseases (Name) values
('Hypertension'),
('Diabetes'),
('Arthritis');

insert into Doctors (Name, Salary, Surname) values
('Michael', 5000, 'Johnson'),
('Emily', 4500, 'Smith'),
('Daniel', 4800, 'Williams');

insert into Examinations (Name) values
('MRI'),
('CT Scan'),
('Blood Test');

insert into Inters (DoctorId) values
(1),
(2),
(3);

insert into Professors (DoctorId) values
(1),
(3);

insert into Wards (Name, Places, DepartmentId) values
('Ward A', 15, 1),
('Ward B', 20, 2),
('Ward C', 10, 3);


--1
select Name, Places
from Wards
where Building = 5 and Places >= 5
  and exists (
    select 1
    from Wards
    where Building = 5 and Places > 15
  );

--2
select distinct d.Name
from Departments d
inner join Wards w on d.Id = w.DepartmentId
inner join DoctorsExaminations de on w.Id = de.WardId
where de.Date >= dateadd(week, -1, getdate());

--3
select distinct d.Name
from Diseases d
left join DoctorsExaminations de on d.Id = de.DiseaseId
where de.Id is null;

--4
select distinct concat(Name, ' ', Surname) as FullName
from Doctors
where not exists (
    select 1
    from DoctorsExaminations
    where DoctorId = Doctors.Id
);

--5
select distinct d.Name
from Departments d
left join Wards w on d.Id = w.DepartmentId
left join DoctorsExaminations de on w.Id = de.WardId
where de.Id is null;

--6
select distinct d.Surname
from Doctors d
inner join Inters i on d.Id = i.DoctorId;

--7
select distinct d.Surname
from Doctors d
inner join Inters i on d.Id = i.DoctorId
where i.Salary > (
    select min(Salary)
    from Doctors
);

--8
select Name
from Wards
where Places > all (
    select Places
    from Wards
    where Building = 3
);

--9
select distinct d.Surname
from Doctors d
inner join DoctorsExaminations de on d.Id = de.DoctorId
inner join Wards w on de.WardId = w.Id
inner join Departments dp on w.DepartmentId = dp.Id
where dp.Name in ('Ophthalmology', 'Physiotherapy');

--10
select distinct d.Name
from Departments d
inner join Wards w on d.Id = w.DepartmentId
inner join DoctorsExaminations de on w.Id = de.WardId
inner join (
    select DoctorId
    from Inters
    union
    select DoctorId
    from Professors
) ip on de.DoctorId = ip.DoctorId;

--11
select distinct concat(d.Name, ' ', d.Surname) as FullName, dp.Name as Department
from Doctors d
inner join DoctorsExaminations de on d.Id = de.DoctorId
inner join Wards w on de.WardId = w.Id
inner join Departments dp on w.DepartmentId = dp.Id
where dp.Financing > 20000;

--12
select top 1 dp.Name
from Departments dp
inner join Wards w on dp.Id = w.DepartmentId
inner join DoctorsExaminations de on w.Id = de.WardId
inner join Doctors d on de.DoctorId = d.Id
order by d.Salary desc;
