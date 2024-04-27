create table Curators (
    Id int primary key identity(1,1) not null,
    Name nvarchar(max) not null,
    Surname nvarchar(max) not null
);

create table Departments (
    Id int primary key identity(1,1) not null,
    Building int not null check (Building between 1 and 5),
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

create table GroupsCurators (
    Id int primary key identity(1,1) not null,
    CuratorId int not null,
    GroupId int not null,
    foreign key (CuratorId) references Curators(Id),
    foreign key (GroupId) references Groups(Id)
);

create table GroupsLectures (
    Id int primary key identity(1,1) not null,
    GroupId int not null,
    LectureId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)
);

create table GroupsStudents (
    Id int primary key identity(1,1) not null,
    GroupId int not null,
    StudentId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (StudentId) references Students(Id)
);

create table Lectures (
    Id int primary key identity(1,1) not null,
    Date date not null check (Date <= getdate()),
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);

create table Students (
    Id int primary key identity(1,1) not null,
    Name nvarchar(max) not null,
    Rating int not null check (Rating between 0 and 5),
    Surname nvarchar(max) not null
);

create table Subjects (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

create table Teachers (
    Id int primary key identity(1,1) not null,
    IsProfessor bit not null default 0,
    Name nvarchar(max) not null,
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null
);

insert into Curators (Name, Surname) values
('Katerina', 'Ivanova'),
('Oleksiy', 'Petrov'),
('Yulia', 'Sydorenko');

insert into Departments (Building, Financing, Name, FacultyId) values
(1, 500000, 'Computer Science Department', 1),
(2, 450000, 'Programming Department', 1),
(3, 600000, 'Applied Mathematics Department', 2);

insert into Faculties (Name) values
('Faculty of Information Technology'),
('Faculty of Mathematics');

insert into Groups (Name, Year, DepartmentId) values
('IT-101', 1, 1),
('IT-102', 1, 1),
('CS-201', 2, 2),
('CS-202', 2, 2),
('Math-301', 3, 3);

insert into GroupsCurators (CuratorId, GroupId) values
(1, 1),
(2, 2),
(3, 3),
(1, 4),
(2, 5);

insert into GroupsLectures (GroupId, LectureId) values
(1, 1),
(2, 2),
(3, 3);

insert into GroupsStudents (GroupId, StudentId) values
(1, 1),
(1, 2),
(1, 3);

insert into Lectures (Date, SubjectId, TeacherId) values
('2024-04-27', 1, 1),
('2024-04-28', 2, 2),
('2024-04-29', 3, 3);


insert into Students (Name, Rating, Surname) values
('John', 5, 'Doe'),
('Alice', 4, 'Smith'),
('Bob', 3, 'Johnson');


insert into Subjects (Name) values
('Fundamentals of Programming'),
('Algebra'),
('Discrete Mathematics');


insert into Teachers (IsProfessor, Name, Salary, Surname) values
(1, 'Mykhailo', 3500, 'Petrenko'),
(0, 'Anna', 2500, 'Ivanova'),
(1, 'Oleg', 4000, 'Sydorov');

--1
select Building
from Departments
group by Building
having sum(Financing) > 100000;

--2
select g.Name
from Groups g
join Departments d on g.DepartmentId = d.Id
where g.Year = 5
    and d.Name = 'Software Development'
group by g.Name
having count(*) > 10;

--3
select g.Name
from Groups g
join Students s on g.Id = s.GroupId
where avg(s.Rating) > (select avg(s2.Rating)
                       from Groups g2
                       join Students s2 on g2.Id = s2.GroupId
                       where g2.Name = 'D221');
--4
select t.Surname, t.Name
from Teachers t
where t.Salary > (select avg(t2.Salary)
                  from Teachers t2
                  where t2.IsProfessor = 1);


--5
select g.Name
from Groups g
join GroupsCurators gc on g.Id = gc.GroupId
group by g.Name
having count(*) > 1;

--6
select g.Name
from Groups g
join Students s on g.Id = s.GroupId
group by g.Name
having avg(s.Rating) < (select min(avg(s2.Rating))
                        from Groups g2
                        join Students s2 on g2.Id = s2.GroupId
                        where g2.Year = 5);


--7
select f.Name
from Faculties f
join Departments d on f.Id = d.FacultyId
group by f.Name
having sum(d.Financing) > (select sum(d2.Financing)
                            from Departments d2
                            join Faculties f2 on d2.FacultyId = f2.Id
                            where f2.Name = 'Computer Science');
--8
select s.Name as discipline, concat(t.Name, ' ', t.Surname) as teacher
from Lectures l
join Subjects s on l.SubjectId = s.Id
join Teachers t on l.TeacherId = t.Id
group by s.Name, t.Name, t.Surname
having count(*) = (select max(countlectures)
                   from (select count(*) as countlectures
                         from Lectures
                         group by SubjectId) as lecturecounts);
--9
select s.Name as discipline
from Lectures l
join Subjects s on l.SubjectId = s.Id
group by s.Name
having count(*) = (select min(countlectures)
                   from (select count(*) as countlectures
                         from Lectures
                         group by SubjectId) as lecturecounts);
--10
select count(distinct s.Id) as studentcount, count(distinct s2.Id) as disciplinecount
from Departments d
join Groups g on d.Id = g.DepartmentId
join Students s on g.Id = s.GroupId
join Subjects s2 on d.Id = s2.Id
where d.Name = 'Software Development';

