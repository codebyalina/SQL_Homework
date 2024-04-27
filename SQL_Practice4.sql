Create table Departments (
    ID int identity(1,1) primary key,
    Name nvarchar(100) not null unique
);

Create table Doctors (
    ID int identity(1,1) primary key,
    Name nvarchar(max) not null,
    Premium money not null default 0 check (Premium >= 0),
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null
);

Create table Doctorsspecializations (
    ID int identity(1,1) primary key,
    Doctorid int not null,
    Specializationid int not null,
    Foreign key (Doctorid) references Doctors(ID),
    Foreign key (Specializationid) references Specializations(ID)
);

Create table Donations (
    ID int identity(1,1) primary key,
    Amount money not null check (amount > 0),
    Date date not null default getdate() check (date <= getdate()),
    Departmentid int not null,
    Sponsorid int not null,
    Foreign key (Departmentid) references Departments(ID),
    Foreign key (Sponsorid) references Sponsors(ID)
);

Create table Specializations (
    ID int identity(1,1) primary key,
    Name nvarchar(100) not null unique
);

Create table sponsors (
    ID int identity(1,1) primary key,
    Name nvarchar(100) not null unique
);

Create table Vacations (
    ID int identity(1,1) primary key,
    Enddate date not null,
    Startdate date not null,
    Doctorid int not null,
    Foreign key (Doctorid) references Doctors(ID),
    CONSTRAINT CK_Dates CHECK (Enddate > Startdate)
);

Create table Wards (
    ID int identity(1,1) primary key,
    Name nvarchar(20) not null unique,
    Departmentid int not null,
    Foreign key (Departmentid) references Departments(ID)
);

insert into Departments (Name) values ('Department 1');
insert into Departments (Name) values ('Department 2');
insert into Departments (Name) values ('Intensive Treatment');
insert into Departments (Name) values ('Department 3');

insert into Doctors (Name, Premium, Salary, Surname) values ('John', 1000, 5000, 'Doe');
insert into Doctors (Name, Premium, Salary, Surname) values ('Jane', 1500, 5500, 'Smith');
insert into Doctors (Name, Premium, Salary, Surname) values ('Michael', 800, 4500, 'Johnson');

insert into Doctorsspecializations (Doctorid, Specializationid) values (1, 1);
insert into Doctorsspecializations (Doctorid, Specializationid) values (2, 2);
insert into Doctorsspecializations (Doctorid, Specializationid) values (3, 1);

insert into Donations (Amount, Departmentid, Sponsorid) values (50000, 1, 1);
insert into Donations (Amount, Departmentid, Sponsorid) values (70000, 3, 2);
insert into Donations (Amount, Departmentid, Sponsorid) values (120000, 2, 1);

insert into Specializations (Name) values ('Specialization 1');
insert into Specializations (Name) values ('Specialization 2');

insert into Sponsors (Name) values ('Sponsor 1');
insert into Sponsors (Name) values ('Sponsor 2');

insert into Vacations (Enddate, Startdate, Doctorid) values ('2024-05-10', '2024-05-01', 1);
insert into Vacations (Enddate, Startdate, Doctorid) values ('2024-05-15', '2024-05-05', 2);

insert into Wards (Name, Departmentid) values ('Ward 1', 1);
insert into Wards (Name, Departmentid) values ('Ward 2', 2);
insert into Wards (Name, Departmentid) values ('Ward 3', 3);


--1
select D.Name + ' ' + D.Surname as 'Full Name', S.Name as 'Specialization'
from doctors D
inner join doctorsspecializations DS on D.ID = DS.Doctorid
inner join specializations S on DS.Specializationid = S.ID;

--2
select D.Surname, D.Salary + D.Premium as 'Total Salary'
from doctors D
left join vacations V on D.ID = V.Doctorid
where V.ID is null;

--3
select W.Name as 'Ward Name'
from wards W
inner join departments D on W.Departmentid = D.ID
where D.Name = 'Intensive Treatment';

--4
select distinct D.Name as 'Department Name'
from departments D
inner join donations DN on D.ID = DN.Departmentid
inner join sponsors SP on DN.Sponsorid = SP.ID
where SP.Name = 'Umbrella Corporation';

--5
select D.Name as 'Department', SP.Name as 'Sponsor', DN.Amount as 'Amount', DN.Date as 'Donation Date'
from donations DN
inner join departments D on DN.Departmentid = D.ID
inner join sponsors SP on DN.Sponsorid = SP.ID
where DN.Date >= dateadd(month, -1, getdate());

--6
select D.Surname as 'Doctor Surname', DW.Name as 'Department'
from doctors D
inner join doctorsspecializations DS on D.ID = DS.Doctorid
inner join specializations S on DS.Specializationid = S.ID
inner join wards W on S.ID = W.Departmentid
inner join departments DW on W.Departmentid = DW.ID
where datename(weekday, getdate()) not in ('Saturday', 'Sunday');

--7
select W.Name as 'Ward Name', D.Name as 'Department'
from wards W
inner join departments D on W.Departmentid = D.ID
inner join doctorsspecializations DS on D.ID = DS.Doctorid
inner join doctors DD on DS.Doctorid = DD.ID
where DD.Name = 'Helen Williams';

--8
select D.Name as 'Department Name', DD.Name as 'Doctor Name'
from departments D
inner join donations DN on D.ID = DN.Departmentid
inner join doctors DD on DN.Departmentid = DD.ID
where DN.Amount > 100000;

--9
select distinct D.Name as 'Department Name'
from departments D
inner join doctors DD on D.ID = DD.ID
where DD.Premium = 0;

--10
select distinct S.Name as 'Specialization Name'
from specializations S
inner join doctorsspecializations DS on S.ID = DS.Specializationid
inner join doctors D on DS.Doctorid = D.ID
where D.Premium > 3;

--11
select D.Name as 'Department Name', S.Name as 'Specialization Name'
from departments D
inner join wards W on D.ID = W.Departmentid
inner join specializations S on W.ID = S.ID
inner join doctorsspecializations DS on S.ID = DS.Specializationid
inner join doctors DD on DS.Doctorid = DD.ID
inner join vacations V on DD.ID = V.Doctorid
where V.Enddate >= dateadd(month, -6, getdate());
