create table Assistants (
    Id int primary key identity(1,1) not null,
    TeacherId int not null,
    foreign key (TeacherId) references Teachers(Id)
);

create table Curators (
    Id int primary key identity(1,1) not null,
    TeacherId int not null,
    foreign key (TeacherId) references Teachers(Id)
);

create table Deans (
    Id int primary key identity(1,1) not null,
    TeacherId int not null,
    foreign key (TeacherId) references Teachers(Id)
);

create table Departments (
    Id int primary key identity(1,1) not null,
    Building int not null check (Building between 1 and 5),
    Name nvarchar(100) not null unique,
    FacultyId int not null,
    HeadId int not null,
    foreign key (FacultyId) references Faculties(Id),
    foreign key (HeadId) references Heads(Id)
);

create table Faculties (
    Id int primary key identity(1,1) not null,
    Building int not null check (Building between 1 and 5),
    Name nvarchar(100) not null unique,
    DeanId int not null,
    foreign key (DeanId) references Deans(Id)
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

create table Heads (
    Id int primary key identity(1,1) not null,
    TeacherId int not null,
    foreign key (TeacherId) references Teachers(Id)
);

create table LectureRooms (
    Id int primary key identity(1,1) not null,
    Building int not null check (Building between 1 and 5),
    Name nvarchar(10) not null unique
);

create table Lectures (
    Id int primary key identity(1,1) not null,
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);

create table Schedules (
    Id int primary key identity(1,1) not null,
    Class int not null check (Class between 1 and 8),
    DayOfWeek int not null check (DayOfWeek between 1 and 7),
    Week int not null check (Week between 1 and 52),
    LectureId int not null,
    LectureRoomId int not null,
    foreign key (LectureId) references Lectures(Id),
    foreign key (LectureRoomId) references LectureRooms(Id)
);

create table Subjects (
    Id int primary key identity(1,1) not null,
    Name nvarchar(100) not null unique
);

create table Teachers (
    Id int primary key identity(1,1) not null,
    Name nvarchar(max) not null,
    Surname nvarchar(max) not null
);

insert into Assistants (TeacherId) values (1);
insert into Assistants (TeacherId) values (2);
insert into Assistants (TeacherId) values (3);

insert into Curators (TeacherId) values (4);
insert into Curators (TeacherId) values (5);
insert into Curators (TeacherId) values (6);

insert into Deans (TeacherId) values (7);
insert into Deans (TeacherId) values (8);
insert into Deans (TeacherId) values (9);

insert into Faculties (Building, Name, DeanId) values (1, 'Факультет информационных технологий', 1);
insert into Faculties (Building, Name, DeanId) values (2, 'Факультет медицины', 2);
insert into Faculties (Building, Name, DeanId) values (3, 'Факультет искусств', 3);

insert into Departments (Building, Name, FacultyId, HeadId) values (1, 'Кафедра программирования', 1, 4);
insert into Departments (Building, Name, FacultyId, HeadId) values (2, 'Кафедра хирургии', 2, 5);
insert into Departments (Building, Name, FacultyId, HeadId) values (3, 'Кафедра живописи', 3, 6);

insert into Groups (Name, Year, DepartmentId) values ('Группа-1', 1, 1);
insert into Groups (Name, Year, DepartmentId) values ('Группа-2', 2, 2);
insert into Groups (Name, Year, DepartmentId) values ('Группа-3', 3, 3);

insert into GroupsCurators (CuratorId, GroupId) values (1, 1);
insert into GroupsCurators (CuratorId, GroupId) values (2, 2);
insert into GroupsCurators (CuratorId, GroupId) values (3, 3);

insert into GroupsLectures (GroupId, LectureId) values (1, 1);
insert into GroupsLectures (GroupId, LectureId) values (2, 2);
insert into GroupsLectures (GroupId, LectureId) values (3, 3);

insert into Heads (TeacherId) values (10);
insert into Heads (TeacherId) values (11);
insert into Heads (TeacherId) values (12);

insert into LectureRooms (Building, Name) values (1, 'Аудитория-101');
insert into LectureRooms (Building, Name) values (2, 'Аудитория-201');
insert into LectureRooms (Building, Name) values (3, 'Аудитория-301');

insert into Lectures (SubjectId, TeacherId) values (1, 1);
insert into Lectures (SubjectId, TeacherId) values (2, 2);
insert into Lectures (SubjectId, TeacherId) values (3, 3);

insert into Schedules (Class, DayOfWeek, Week, LectureId, LectureRoomId) values (1, 1, 1, 1, 1);
insert into Schedules (Class, DayOfWeek, Week, LectureId, LectureRoomId) values (2, 2, 2, 2, 2);
insert into Schedules (Class, DayOfWeek, Week, LectureId, LectureRoomId) values (3, 3, 3, 3, 3);

insert into Subjects (Name) values ('Программирование');
insert into Subjects (Name) values ('Хирургия');
insert into Subjects (Name) values ('Живопись');

insert into Teachers (Name, Surname) values ('Алексей', 'Иванов');
insert into Teachers (Name, Surname) values ('Екатерина', 'Петрова');
insert into Teachers (Name, Surname) values ('Дмитрий', 'Сидоров');

--1
select lr.Name
from Lectures l
join LectureRooms lr on l.LectureRoomId = lr.Id
join Teachers t on l.TeacherId = t.Id
where t.Name = 'Edward' and t.Surname = 'Hopper';

-- 2
select t.Surname
from GroupsLectures gl
join Lectures l on gl.LectureId = l.Id
join Teachers t on l.TeacherId = t.Id
join Assistants a on t.Id = a.TeacherId
join Groups g on gl.GroupId = g.Id
where g.Name = 'F505';

--3
select distinct s.Name
from Lectures l
join Subjects s on l.SubjectId = s.Id
join Teachers t on l.TeacherId = t.Id
join GroupsLectures gl on l.Id = gl.LectureId
join Groups g on gl.GroupId = g.Id
where t.Name = 'Alex' and t.Surname = 'Carmack' and g.Year = 5;

--4
select distinct t.Surname
from Teachers t
left join Lectures l on t.Id = l.TeacherId
left join Schedules s on l.Id = s.LectureId
where dayofweek(s.DayOfWeek) != 2 or s.DayOfWeek is null;

--5
select lr.Name, lr.Building
from LectureRooms lr
left join Schedules s on lr.Id = s.LectureRoomId
where dayofweek(s.DayOfWeek) = 4 and s.Week = 2 and s.Class = 3 and s.LectureRoomId is null;

-- 6
select concat(t.Name, ' ', t.Surname) as FullName
from Teachers t
join Faculties f on t.Id = f.DeanId
join Departments d on f.Id = d.FacultyId
left join GroupsCurators gc on t.Id = gc.CuratorId
join Groups g on gc.GroupId = g.Id
join Departments d2 on g.DepartmentId = d2.Id
where d2.Name <> 'Software Development' and d.Name = 'Computer Science';

--7
select distinct Building
from (
    select Building from Faculties
    union
    select Building from Departments
    union
    select Building from LectureRooms
) as AllBuildings;

--8
select concat(Name, ' ', Surname) as FullName, 'Deans' as Position
from Deans
union
select concat(Name, ' ', Surname) as FullName, 'Heads' as Position
from Heads
union
select concat(Name, ' ', Surname) as FullName, 'Teachers' as Position
from Teachers
where Id not in (select TeacherId from Deans) and Id not in (select TeacherId from Heads)
union
select concat(Name, ' ', Surname) as FullName, 'Curators' as Position
from Curators
union
select concat(Name, ' ', Surname) as FullName, 'Assistants' as Position
from Assistants;

-- 9
select distinct DayOfWeek
from Schedules s
join LectureRooms lr on s.LectureRoomId = lr.Id
where lr.Name in ('A311', 'A104');
