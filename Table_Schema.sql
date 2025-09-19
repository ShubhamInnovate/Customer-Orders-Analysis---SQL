CREATE TABLE P1_Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    DOB DATE,
    Gender CHAR(1),
    JoinDate DATE
);

INSERT INTO P1_Customers VALUES
(1, 'John',   'Smith',    'USA',       'New York',   '1985-03-12', 'M', '2015-01-10'),
(2, 'Emma',   'Johnson',  'USA',       'Chicago',    '1990-07-24', 'F', '2016-05-20'),
(3, 'Liam',   'Brown',    'Canada',    'Toronto',    '1988-11-02', 'M', '2017-03-12'),
(4, 'Olivia', 'Jones',    'UK',        'London',     '1992-01-30', 'F', '2018-07-15'),
(5, 'Noah',   'Garcia',   'India',     'Delhi',      '1987-09-18', 'M', '2019-11-05'),
(6, 'Sophia', 'Lopez',    'Canada',    'Montreal',   '1986-04-23', 'F', '2020-01-12'),
(7, 'Mason',  'Gonzalez', 'Australia', 'Sydney',     '1993-10-09', 'M', '2021-06-19'),
(8, 'Ava',    'Martinez', 'India',     'Mumbai',     '1989-06-11', 'F', '2022-05-25'),
(9, 'Ethan',  'Rodriguez','USA',       'Miami',      '1991-12-04', 'M', '2017-04-11'),
(10,'Isabella','Wilson',  'UK',        'Leeds',      '1985-08-14', 'F', '2019-09-07');



CREATE TABLE P1_Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

INSERT INTO P1_Products VALUES
(101, 'iPhone 14',       'Electronics', 999.99),
(102, 'Samsung TV',      'Electronics', 550.00),
(103, 'Nike Shoes',      'Footwear',    120.00),
(104, 'Levi Jeans',      'Clothing',     80.00),
(105, 'Cookware Set',    'Home',        200.00),
(106, 'Dell Laptop',     'Electronics', 850.00),
(107, 'Office Chair',    'Furniture',   300.00),
(108, 'Washing Machine', 'Home',        400.00),
(109, 'Harry Potter',    'Books',        25.00),
(110, 'Adidas Jacket',   'Clothing',    150.00);



CREATE TABLE P1_Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES P1_Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES P1_Products(ProductID),
    OrderDate DATE,
    Quantity INT,
    Discount DECIMAL(5,2)
);

INSERT INTO P1_Orders VALUES
(1001, 1, 101, '2022-01-10', 1, 0.05),
(1002, 2, 103, '2022-02-14', 2, 0.00),
(1003, 3, 106, '2022-03-01', 1, 0.10),
(1004, 4, 104, '2022-03-15', 3, 0.00),
(1005, 5, 109, '2022-04-20', 4, 0.00),
(1006, 6, 108, '2022-05-11', 1, 0.15),
(1007, 7, 102, '2022-06-05', 2, 0.05),
(1008, 8, 105, '2022-06-15', 1, 0.00),
(1009, 9, 107, '2022-07-10', 2, 0.10),
(1010,10, 110, '2022-07-25', 1, 0.00);
