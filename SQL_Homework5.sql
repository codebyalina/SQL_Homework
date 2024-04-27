create table Departments (
    Id int primary key identity(1,1) not null,
    Financing money not null default 0,
    Name nvarchar(100) not null unique,
    FacultyId int not null,
    foreign key (FacultyId) references Faculties(Id)
);

create table Faculties (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

create table Groups (
    Id int primary key identity(1,1) not null,
    Name nvarchar(10) not null unique,
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(Id)
);

create table GroupsLectures (
    Id int primary key identity(1,1) not null,
    GroupId int not null,
    LectureId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)
);

create table Lectures (
    Id int primary key identity(1,1) not null,
    DayOfWeek int not null check (DayOfWeek between 1 and 7),
    LectureRoom nvarchar(max) not null,
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);

create table Subjects (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

create table Teachers (
    Id int primary key identity(1,1) not null,
    Name nvarchar(max) not null,
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null
);

insert into departments (financing, name, facultyid) values (10000, 'Department of Mathematics', 1);
insert into departments (financing, name, facultyid) values (15000, 'Department of Physics', 1);
insert into departments (financing, name, facultyid) values (12000, 'Department of Chemistry', 2);
insert into departments (financing, name, facultyid) values (8000, 'Department of Biology', 2);

insert into faculties (name) values ('Faculty of Science');
insert into faculties (name) values ('Faculty of Arts');

insert into groups (name, year, departmentid) values ('A1', 1, 1);
insert into groups (name, year, departmentid) values ('B2', 2, 1);
insert into groups (name, year, departmentid) values ('C3', 3, 2);
insert into groups (name, year, departmentid) values ('D4', 4, 2);

insert into groupslectures (groupid, lectureid) values (1, 1);
insert into groupslectures (groupid, lectureid) values (2, 2);
insert into groupslectures (groupid, lectureid) values (3, 3);
insert into groupslectures (groupid, lectureid) values (4, 4);

insert into lectures (dayofweek, lectureroom, subjectid, teacherid) values (1, 'Room 101', 1, 1);
insert into lectures (dayofweek, lectureroom, subjectid, teacherid) values (2, 'Room 102', 2, 2);
insert into lectures (dayofweek, lectureroom, subjectid, teacherid) values (3, 'Room 103', 3, 3);
insert into lectures (dayofweek, lectureroom, subjectid, teacherid) values (4, 'Room 104', 4, 4);

insert into subjects (name) values ('Mathematics');
insert into subjects (name) values ('Physics');
insert into subjects (name) values ('Chemistry');
insert into subjects (name) values ('Biology');

insert into teachers (name, salary, surname) values ('John', 5000, 'Doe');
insert into teachers (name, salary, surname) values ('Jane', 5500, 'Smith');
insert into teachers (name, salary, surname) values ('Michael', 6000, 'Johnson');
insert into teachers (name, salary, surname) values ('Emily', 5200, 'Williams');

--1
select count(*) as TotalTeachers
from Teachers T
inner join Lectures L on T.Id = L.TeacherId
inner join Subjects S on L.SubjectId = S.Id
inner join Departments D on S.DepartmentId = D.Id
where D.Name = 'Software Development';

--2
select count(*) as TotalLectures
from Lectures L
inner join Teachers T on L.TeacherId = T.Id
where T.Name = 'Dave McQueen';

--3
select count(*) as TotalClasses
from Lectures
where LectureRoom = 'D201';

--4
select LectureRoom, count(*) as TotalLectures
from Lectures
group by LectureRoom;

--5
select count(distinct G.Id) as TotalStudents
from Groups G
inner join GroupsLectures GL on G.Id = GL.GroupId
inner join Lectures L on GL.LectureId = L.Id
inner join Teachers T on L.TeacherId = T.Id
where T.Name = 'Jack Underhill';

--6
select avg(T.Salary) as AverageSalary
from Teachers T
inner join Lectures L on T.Id = L.TeacherId
inner join Subjects S on L.SubjectId = S.Id
inner join Departments D on S.DepartmentId = D.Id
inner join Faculties F on D.FacultyId = F.Id
where F.Name = 'Computer Science';

--7
select min(StudentsCount) as MinStudentsCount, max(StudentsCount) as MaxStudentsCount
from (
    select count(*) as StudentsCount
    from GroupsLectures GL
    inner join Groups G on GL.GroupId = G.Id
    group by G.Id
) as StudentCounts;

--8
select avg(Financing) as AverageFinancing
from Departments;

--9
select T.Name + ' ' + T.Surname as FullName, count(distinct S.Id) as TotalSubjects
from Teachers T
inner join Lectures L on T.Id = L.TeacherId
inner join Subjects S on L.SubjectId = S.Id
group by T.Name, T.Surname;

--10
select DayOfWeek, count(*) as TotalLecturesPerDay
from Lectures
group by DayOfWeek;

--11
select LectureRoom, count(distinct D.Id) as TotalDepartments
from Lectures L
inner join Subjects S on L.SubjectId = S.Id
inner join Departments D on S.DepartmentId = D.Id
group by LectureRoom;

--12
select F.Name as FacultyName, count(distinct S.Id) as TotalSubjects
from Faculties F
inner join Departments D on F.Id = D.FacultyId
inner join Subjects S on D.Id = S.DepartmentId
group by F.Name;

--13
select T.Id as TeacherId, L.LectureRoom, count(*) as TotalLectures
from Lectures L
inner join Teachers T on L.TeacherId = T.Id
group by T.Id, L.LectureRoom;
