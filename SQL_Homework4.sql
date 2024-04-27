Create table Curators (
    Id int primary key identity,
    Name nvarchar(max) not null,
    Surname nvarchar(max) not null
);

Create table Departments (
    Id int primary key identity,
    Financing money not null default 0,
    Name nvarchar(100) not null unique,
    FacultyId int not null,
    Foreign key (FacultyId) references Faculties(Id)
);

Create table Faculties (
    Id int primary key identity,
    Financing money not null default 0,
    Name nvarchar(100) not null unique
);

Create table Groups (
    Id int primary key identity,
    Name nvarchar(10) not null unique,
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null,
    Foreign key (DepartmentId) references Departments(Id)
);

Create table GroupsCurators (
    Id int primary key identity,
    CuratorId int not null,
    GroupId int not null,
    Foreign key (CuratorId) references Curators(Id),
    Foreign key (GroupId) references Groups(Id)
);

Create table GroupsLectures (
    Id int primary key identity,
    GroupId int not null,
    LectureId int not null,
    Foreign key (GroupId) references Groups(Id),
    Foreign key (LectureId) references Lectures(Id)
);

Create table Lectures (
    Id int primary key identity,
    LectureRoom nvarchar(max) not null,
    SubjectId int not null,
    TeacherId int not null,
    Foreign key (SubjectId) references Subjects(Id),
    Foreign key (TeacherId) references Teachers(Id)
);

Create table Subjects (
    Id int primary key identity,
    Name nvarchar(100) not null unique
);

Create table Teachers (
    Id int primary key identity,
    Name nvarchar(max) not null,
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null
);

insert into Curators (Name, Surname) values ('John', 'Doe');
insert into Curators (Name, Surname) values ('Jane', 'Smith');

insert into Departments (Financing, Name, FacultyId) values (10000.00, 'Computer Science', 1);
insert into Departments (Financing, Name, FacultyId) values (15000.00, 'Mathematics', 2);

insert into Faculties (Financing, Name) values (50000.00, 'Engineering');
insert into Faculties (Financing, Name) values (70000.00, 'Science');

insert into Groups (Name, Year, DepartmentId) values ('CS101', 1, 1);
insert into Groups (Name, Year, DepartmentId) values ('Math202', 2, 2);

insert into GroupsCurators (CuratorId, GroupId) values (1, 1);
insert into GroupsCurators (CuratorId, GroupId) values (2, 2);

insert into GroupsLectures (GroupId, LectureId) values (1, 1);
insert into GroupsLectures (GroupId, LectureId) values (2, 2);

insert into Lectures (LectureRoom, SubjectId, TeacherId) values ('Room A', 1, 1);
insert into Lectures (LectureRoom, SubjectId, TeacherId) values ('Room B', 2, 2);

insert into Subjects (Name) values ('Database Management');
insert into Subjects (Name) values ('Linear Algebra');

insert into Teachers (Name, Salary, Surname) values ('Michael', 5000.00, 'Johnson');
insert into Teachers (Name, Salary, Surname) values ('Emily', 6000.00, 'Williams');


--1
select t.Name as teachername, t.Surname as teachersurname, g.Name as groupname
from Teachers t
cross join Groups g;

--2
select f.Name as facultyname
from Faculties f
inner join Departments d on f.Id = d.FacultyId
group by f.Id, f.Name, f.Financing
having sum(d.Financing) > f.Financing;

--3
select c.Surname as curatorsurname, g.Name as groupname
from Curators c
inner join GroupsCurators gc on c.Id = gc.CuratorId
inner join Groups g on gc.GroupId = g.Id;

--4
select distinct t.Name as teachername, t.Surname as teachersurname
from Teachers t
inner join Lectures l on t.Id = l.TeacherId
inner join GroupsLectures gl on l.Id = gl.LectureId
inner join Groups g on gl.GroupId = g.Id
where g.Name = 'P107';

--5
select t.Surname as teachersurname, f.Name as facultyname
from Teachers t
inner join Lectures l on t.Id = l.TeacherId
inner join Subjects s on l.SubjectId = s.Id
inner join Departments d on s.Id = d.Id
inner join Faculties f on d.FacultyId = f.Id;

--6
select d.Name as departmentname, g.Name as groupname
from Departments d
inner join Groups g on d.Id = g.DepartmentId;

--7
select distinct s.Name as subjectname
from Teachers t
inner join Lectures l on t.Id = l.TeacherId
inner join Subjects s on l.SubjectId = s.Id
where t.Name = 'Samantha' and t.Surname = 'Adams';

--8
select d.Name as departmentname
from Departments d
inner join Subjects s on d.Id = s.Id
inner join Lectures l on s.Id = l.SubjectId
where s.Name = 'Database Theory';

--9
select g.Name as groupname
from Groups g
inner join Departments d on g.DepartmentId = d.Id
inner join Faculties f on d.FacultyId = f.Id
where f.Name = 'Computer Science';

--10
select g.Name as groupname, d.Name as departmentname, f.Name as facultyname
from Groups g
inner join Departments d on g.DepartmentId = d.Id
inner join Faculties f on d.FacultyId = f.Id
where g.Year = 5;

--11
select concat(t.Name, ' ', t.Surname) as teacherfullname, s.Name as subjectname, g.Name as groupname
from Teachers t
inner join Lectures l on t.Id = l.TeacherId
inner join Subjects s on l.SubjectId = s.Id
inner join GroupsLectures gl on l.Id = gl.LectureId
inner join Groups g on gl.GroupId = g.Id
where l.LectureRoom = 'B103';

