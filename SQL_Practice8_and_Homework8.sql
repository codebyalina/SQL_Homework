create table Products (
    ID int primary key identity(1,1),
    Productname nvarchar(100) not null,
    Producttype nvarchar(50),
    Quantityinstock int,
    Costprice money,
    Manufacturer nvarchar(100),
    Sellingprice money
);


create table Sales (
    ID int primary key identity(1,1),
    Productid int,
    Saleprice money,
    Quantity int,
    Saledate date,
    Sellername nvarchar(100),
    Customername nvarchar(100),
    Foreign key (Productid) references Products(ID)
);

create table Employees (
    ID int primary key identity(1,1),
    Fullname nvarchar(100) not null,
    Position nvarchar(50),
    Hiredate date,
    Gender char(1),
    Salary money
);

create table Customers (
    ID int primary key identity(1,1),
    Fullname nvarchar(100) not null,
    Email nvarchar(100),
    Phone nvarchar(20),
    Gender char(1),
    Orderhistory nvarchar(max),
    Discountpercentage decimal(5,2),
    Subscribedtonewsletter bit
);

create table History (
    SaleID int primary key identity(1,1),
    ProductID int,
    SalePrice money,
    Quantity int,
    SaleDate date,
    SellerName nvarchar(100),
    CustomerName nvarchar(100),
    Foreign key (ProductID) references Products(ID)
);

 
insert into Products (productname, producttype, quantityinstock, costprice, manufacturer, sellingprice)
values
    ('t-shirt', 'clothing', 50, 15.99, 'ABC Clothing', 29.99),
    ('running shoes', 'footwear', 30, 49.99, 'XYZ Footwear', 89.99),
    ('sports ball', 'toy', 100, 5.99, 'Sporty Toys', 12.99);


insert into Sales (productid, saleprice, quantity, saledate, sellername, customername)
values 
    (1, 29.99, 2, '2024-04-20', 'John Doe', 'Jane Smith'),
    (2, 89.99, 1, '2024-04-21', 'Peter Johnson', 'Michael Brown'),
    (3, 12.99, 3, '2024-04-22', 'Emily Taylor', 'Sarah Clark');
insert into  Employees (fullname, position, hiredate, gender, salary)
values 
    ('John Smith', 'manager', '2020-01-15', 'M', 2500.00),
    ('Emily Davis', 'consultant', '2021-03-20', 'F', 1800.00),
    ('Michael Johnson', 'cashier', '2022-05-10', 'M', 2000.00);


insert into Customers (fullname, email, phone, gender, orderhistory, discountpercentage, subscribedtonewsletter)
values 
    ('Alexander Bondarenko', 'alexander@example.com', '123456789', 'M', 'Order 1: t-shirt, Order 2: running shoes', 5.00, 1),
    ('Irina Mikhailova', 'irina@example.com', '987654321', 'F', 'Order 1: sports ball', 0.00, 0),
    ('Paul Chernenko', 'paul@example.com', '555555555', 'M', NULL, 10.00, 1);

--1
create trigger InsertIntoHistory
on Sales
after insert
as 
begin
    insert into  History (SaleID, ProductID, SalePrice, Quantity, SaleDate, SellerName, CustomerName)
    select ID, ProductID, SalePrice, Quantity, Saledate, Sellername, Customername
    from inserted;
end;

--2
create trigger MoveSoldProductToArchive
on Sales
after update
as
begin
    insert into Archive (ProductID, SalePrice, Quantity, SaleDate, SellerName, CustomerName)
    select ProductID, SalePrice, Quantity, SaleDate, SellerName, CustomerName
    from deleted
    where Quantity = 0;
end;

--3
create trigger PreventDuplicateCustomers
on Customers
instead of insert
as
begin
    if exists (
        select 1
        from Customers as C
        join Inserted as I on C.Fullname = I.Fullname or C.Email = I.Email
    )
    begin
        print ('This customer already exists in the database');
        return;
    end;

    insert into Customers (Fullname, Email, Phone, Gender, Orderhistory, Discountpercentage, Subscribedtonewsletter)
    select Fullname, Email, Phone, Gender, Orderhistory, Discountpercentage, Subscribedtonewsletter
    from Inserted;
end;

--4

create trigger PreventDeletingCustomers
on Customers
instead of delete
as
begin
    print ('Deleting customers is not allowed');  
    return;  
end;

--5
create trigger PreventDeletingEmployees
on Employees
instead of delete
as
begin
    if exists (
        select 1
        from deleted
        where Hiredate < '2015-01-01'
    )
    begin
        print ('Deleting employees hired before 2015 is not allowed');  
        return;      
    end;

    delete from Employees where ID in (select ID from deleted);  
end;

--6
create trigger SetDiscountForCustomer
on Sales
after insert
as
begin
    update Customers
    set Discountpercentage = 15
    where ID in (
        select c.ID
        from inserted i
        join Customers c on i.Customername = c.Fullname
        group by c.ID
        having sum(i.Saleprice * i.Quantity) > 50000
    );
end;

--7

create trigger PreventAddingProducts
on Products
instead of insert
as
begin
    if exists (
        select 1
        from inserted
        where Manufacturer = 'Sports, sun and barbell'
    )
    begin
        print ('Adding products from this manufacturer is not allowed');   
        return;  
    end;

    insert into Products (Productname, Producttype, Quantityinstock, Costprice, Manufacturer, Sellingprice)
    select Productname, Producttype, Quantityinstock, Costprice, Manufacturer, Sellingprice
    from inserted;
end;

--8
create trigger MoveLastRemainingProductToLastUnit
on Products
after update
as
begin
    declare @ProductID int, @QuantityInStock int;

    select @ProductID = ID, @QuantityInStock = Quantityinstock
    from inserted;

    if @QuantityInStock = 1
    begin
        insert into LastUnit (ProductID)
        values (@ProductID);
    end
end;

--HOMEWORK

--1
create trigger UpdateProductQuantity
on Products
instead of insert
as
begin
    set nocount on;
    declare @ProductId int, @ProductQuantity int;

    select @ProductId = ProductID, @ProductQuantity = Quantityinstock
    from inserted;

    if exists (select 1 from Products where ID = @ProductId)
    begin
        update Products
        set Quantityinstock = Quantityinstock + @ProductQuantity
        where ID = @ProductId;
    end
    else
    begin
        insert into Products (Productname, Producttype, Quantityinstock, Costprice, Manufacturer, Sellingprice)
        select Productname, Producttype, Quantityinstock, Costprice, Manufacturer, Sellingprice
        from inserted;
    end
end;


--2
create trigger MoveDismissedEmployeeToArchive
on Employees
after delete
as
begin
    insert into EmployeeArchive (ID, Fullname, Position, Hiredate, Gender, Salary)
    select ID, Fullname, Position, Hiredate, Gender, Salary
    from deleted;
end;

--3
create trigger PreventAddingNewSeller
on Employees
instead of insert
as
begin
    set nocount on;
    declare @SellerCount int;

    select @SellerCount = count(*)
    from Employees
    where Position = 'Seller';

    if ((select count(*) from inserted where Position = 'Seller') + @SellerCount) > 6
    begin
        raiserror ('Cannot add new seller. Maximum limit of sellers exceeded.', 16, 1);
        rollback transaction;
    end
    else
    begin
        insert into Employees (Fullname, Position, Hiredate, Gender, Salary)
        select Fullname, Position, Hiredate, Gender, Salary
        from inserted;
    end
end;




