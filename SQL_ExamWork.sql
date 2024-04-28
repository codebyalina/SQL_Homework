Create table Authors (
    Id int not null primary key identity(1,1),
    Name nvarchar(max) not null check(len(Name) > 0),
    Surname nvarchar(max) not null check(len(Surname) > 0),
    Countryid int not null,
    Foreign key (Countryid) references Countries(Id)
);

Create table Books (
    Id int not null primary key identity(1,1),
    Name nvarchar(max) not null check(len(Name) > 0),
    Pages int not null check (Pages > 0),
    Price money not null check (Price >= 0),
    PublishDate date not null check (PublishDate <= getdate()),
    Authorid int not null,
    Themeid int not null,
    Foreign key (AuthorId) references Authors(Id),
    Foreign key (ThemeId) references Themes(Id)
);

Create table Countries(
	Id int not null primary key identity(1,1),
	Name nvarchar(50) not null unique check(len(Name) > 0)
);

Create table Sales(
	Id int not null primary key identity(1,1),
	Price money not null check(Price >= 0),
	Quantity int not null check(Quantity > 0),
	SaleDate date not null check(SaleDate <= getdate()),
	BookId int not null,
	ShopId int not null,
	Foreign key (BookId) references Books(Id),
	Foreign key (ShopId) references Shops(Id)
);

Create table Shops(
	Id int not null primary key identity(1,1),
	Name nvarchar(max) not null check(len(Name) > 0),
	CountryId int not null,
	Foreign key (CountryId) references Countries(Id)
); 

Create table Themes(
	Id int not null primary key identity(1,1),
	Name nvarchar(100) not null unique check(len(Name) > 0)
);

--Додаткове завдання
Create table Publishers (
    Id int not null primary key identity(1,1),
    Name nvarchar(100) not null unique check(len(Name) > 0)
);

insert into Authors (Name, Surname, CountryId) 
values 
('John', 'Doe', 1),
('Alice', 'Smith', 2),
('Michael', 'Johnson', 3),
('Emma', 'Williams', 1),
('David', 'Brown', 2),
('Sarah', 'Jones', 3),
('James', 'Garcia', 1),
('Jennifer', 'Martinez', 2),
('Robert', 'Davis', 3),
('Mary', 'Rodriguez', 1);

 
insert into Books (Name, Pages, Price, PublishDate, AuthorId, ThemeId) 
values 
('Book1', 200, 15.99, '2023-01-01', 1, 1),
('Book2', 300, 20.50, '2022-12-15', 2, 2),
('Book3', 150, 12.99, '2023-05-20', 3, 1),
('Book4', 250, 18.75, '2023-03-10', 4, 3),
('Book5', 180, 14.99, '2023-02-28', 5, 2),
('Book6', 320, 24.99, '2023-04-05', 6, 1),
('Book7', 270, 19.50, '2023-06-18', 7, 3),
('Book8', 190, 15.99, '2023-07-22', 8, 2),
('Book9', 280, 21.75, '2023-09-03', 9, 1),
('Book10', 220, 17.50, '2023-08-14', 10, 3);


insert into Countries (Name) 
values 
('USA'),
('UK'),
('Canada'),
('Australia'),
('Germany'),
('France'),
('Japan'),
('China'),
('India'),
('Brazil');

insert into Sales (Price, Quantity, SaleDate, BookId, ShopId) 
values 
(15.99, 2, '2024-04-26', 1, 1),
(20.50, 3, '2024-04-25', 2, 2),
(12.99, 1, '2024-04-24', 3, 3),
(18.75, 2, '2024-04-23', 4, 4),
(14.99, 1, '2024-04-22', 5, 5),
(24.99, 3, '2024-04-21', 6, 6),
(19.50, 2, '2024-04-20', 7, 7),
(15.99, 1, '2024-04-19', 8, 8),
(21.75, 3, '2024-04-18', 9, 9),
(17.50, 2, '2024-04-17', 10, 10);


insert into Shops (Name, CountryId) 
values
('Shop1', 1),
('Shop2', 2),
('Shop3', 3),
('Shop4', 4),
('Shop5', 5),
('Shop6', 1),
('Shop7', 2),
('Shop8', 3),
('Shop9', 4),
('Shop10', 5);


insert into Themes (Name) 
values
('Fiction'),
('Science Fiction'),
('Thriller'),
('Romance'),
('Mystery'),
('Fantasy'),
('Biography'),
('History'),
('Self-help'),
('Cooking');

--Додаткове завдання 
insert into Publishers (Name) 
values 
('Publisher1'),
('Publisher2'),
('Publisher3'),
('Publisher4'),
('Publisher5');

--1
select Name, Pages
from Books
where Pages >= 200 and Pages <=250;

--2
select Name
from Books
where Name like 'A%' or  Name like 'Z%';

--3
select *
from Books as B
join Sales as S on B.Id = S.BookId
join Themes as T on B.ThemeId = T.Id
where T.Name = 'Detective' and S.Quantity > 30;

--4
select *
from Books as B
where Name like '%Microsoft%' and Name not like '%Windows%';

--5
select B.Name, B.ThemeId, CONCAT(A.Name, ' ', A.Surname) as [Author]
from Books as B
join Themes as T on B.ThemeId = T.Id
join Authors as A on B.AuthorId = A.Id
where B.Price / B.Pages > 0.65;

--6
select *
from Books
where len(Name) = 4;

--7
select B.Name, T.Name, concat(A.Name, ' ', A.Surname) as [Author],
S.Price,S.Quantity,SH.Name
from Sales as S
join Books as B on S.BookId = B.Id
join Themes as T on B.ThemeId = T.Id
join Authors as A on B.AuthorId = A.Id
join Shops as SH on S.ShopId = SH.Id
where B.Name not like '%A%' 
    and T.Name <> 'Programming' 
    and concat(A.Name, ' ', A.Surname) <> 'Herbert Schildt' 
    and S.Price between 10 and 20 
    and S.Quantity >= 8 
    and SH.CountryId not in (select Id from Countries where Name in ('Ukraine', 'Russian'));

--8
select 'Count authors' as "Name", count(*) as "Count" from Authors
union all
select 'Count books', count(*) from Books
union all
select 'Average prices', avg(Price) from Books
union all
select 'Average pages', avg(Pages) from Books;

--9
select T.Name, sum(B.Pages)
from Books as B
join Themes as T on B.ThemeId = T.Id
group by T.Name;

--10
select count(B.Id), sum(B.Pages), concat(A.Name, ' ', A.Surname) as [Author]
from Books as B
join Authors as A on B.AuthorId = A.Id
group by  A.Name, A.Surname;

--11
select top 1 *
from Books as B
join Themes as T on B.ThemeId = T.Id
where T.Name = 'Programming' 
order by B.Pages desc;

--12
select T.Name, avg(B.Pages) as [Average pages]
from Books as B
join Themes as T on B.ThemeId = T.Id
where T.Name = 'Programming' 
group by T.Name
having avg(B.Pages) <= 400;

--13
select T.Name,sum(B.Pages) as [Sum of pages]
from Books as B
join Themes as T on B.ThemeId = T.Id
where T.Name IN ('Programming', 'Administration', 'Design') and B.Pages >= 400
group by T.Name;

--14
select S.SaleDate, SH.Name, B.Name, A.Name, A.Surname, S.Quantity
from Sales as S
join Books as B on S.BookId = B.Id
join Authors as A on B.AuthorId = A.Id
join Shops as SH on S.ShopId = SH.Id;

--15
select top 1 SH.Name as ShopName, sum(S.Price * S.Quantity) as TotalProfit
from Sales as S
join Shops as SH on S.ShopId = SH.Id
group by SH.Name
order by TotalProfit desc;

--Додаткові завдання 
--16
select Name
from Books
where Pages > 300 and PublishDate < '2023-01-01';

-- 17
select Name, Price
from Books
where Price > (select avg(Price) from Books);

-- 18. 
select year(SaleDate) as Year, month(SaleDate) as Month, SH.Name as ShopName, sum(S.Quantity) as TotalSales
from Sales as S
join Shops as SH on S.ShopId = SH.Id
where year(SaleDate) = 2023
group by year(SaleDate), month(SaleDate), SH.Name
order by year(SaleDate), month(SaleDate);

-- 19
select B.Name as BookName, concat(A.Name, ' ', A.Surname) as Author, C.Name as AuthorCountry
from Books as B
join Authors as A on B.AuthorId = A.Id
join Countries as C on A.CountryId = C.Id
where C.Name not in ('USA', 'UK', 'Ukraine');

-- 20 
select distinct C.Name as CountryName
from Countries as C
join Shops as SH on C.Id = SH.CountryId
join Sales as S on SH.Id = S.ShopId
join Books as B on S.BookId = B.Id
where year(B.PublishDate) = 2023 and month(B.PublishDate) = 10;

