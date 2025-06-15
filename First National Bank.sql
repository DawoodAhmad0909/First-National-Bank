CREATE DATABASE FNB_db;
USE FNB_db;

CREATE TABLE Customers(
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	email VARCHAR(50) UNIQUE,
	phone VARCHAR(15) UNIQUE,
	address VARCHAR(50),
	city VARCHAR(20),
    state VARCHAR(20),
	zip_code VARCHAR(10),
	date_of_birth DATE,
	created_at DATETIME
);
INSERT INTO Customers VALUES
	(1, 'John', 'Smith', 'john.smith@email.com', '555-123-4567', '123 Main St', 'New York', 'NY', '10001', '1985-03-15', '2023-01-10 09:30:00'),
	(2, 'Jane', 'Doe', 'jane.doe@email.com', '555-987-6543', '456 Oak Ave', 'Chicago', 'IL', '60601', '1990-07-22', '2023-01-12 14:15:00'),
	(3, 'Robert', 'Johnson', 'robert@email.com', '555-456-7890', '789 Pine Blvd', 'Houston', 'TX', '77002', '1978-11-05', '2023-01-15 10:45:00'),
	(4, 'Emily', 'Williams', 'emily@email.com', '555-654-3210', '321 Elm St', 'Los Angeles', 'CA', '90001', '1995-05-30', '2023-01-20 16:20:00');

CREATE TABLE Branches(
	branch_id INT PRIMARY KEY,
	branch_name VARCHAR(100) NOT NULL,
	address VARCHAR(50) NOT NULL,
	city VARCHAR(20),
	state VARCHAR(20),
	zip_code VARCHAR(10),
	phone VARCHAR(15) UNIQUE
);
INSERT INTO Branches VALUES
	(1, 'Main Branch', '123 Bank St', 'New York', 'NY', '10001', '555-111-2222'),
	(2, 'Downtown Branch', '456 Finance Ave', 'Chicago', 'IL', '60601', '555-333-4444'),
	(3, 'Westside Branch', '789 Money Blvd', 'Houston', 'TX', '77002', '555-555-6666');

CREATE TABLE Employees(
	employee_id INT PRIMARY KEY,
	branch_id INT,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	position VARCHAR(15) NOT NULL,
	email varchar(50) NOT NULL,
	hire_date DATE,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id) 
);
INSERT INTO Employees VALUES
	(101, 1, 'Michael', 'Brown', 'Manager', 'michael@bank.com', '2020-05-10'),
	(102, 1, 'Sarah', 'Wilson', 'Teller', 'sarah@bank.com', '2021-08-15'),
	(103, 2, 'David', 'Lee', 'Loan Officer', 'david@bank.com', '2019-03-22');

CREATE TABLE Accounts(
	account_id INT PRIMARY KEY,
	customer_id INT,
	account_type VARCHAR(15) NOT NULL,
	balance DECIMAL(10,2),
	opened_date DATE,
	status VARCHAR(25),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
);
INSERT INTO Accounts VALUES
	(1001, 1, 'Savings', 5000.00, '2023-01-10', 'Active'),
	(1002, 1, 'Checking', 2500.00, '2023-01-10', 'Active'),
	(1003, 2, 'Savings', 12000.00, '2023-01-12', 'Active'),
	(1004, 3, 'Checking', 750.00, '2023-01-15', 'Active'),
	(1005, 4, 'Savings', 3000.00, '2023-01-20', 'Active');

CREATE TABLE Transactions(
	transaction_id INT PRIMARY KEY,
	account_id INT,
	transaction_type VARCHAR(20),
	amount DECIMAL(10,2),
	transaction_date DATETIME,
	description VARCHAR(50),
    FOREIGN KEY (account_id)  REFERENCES Accounts(account_id)
);
INSERT INTO Transactions VALUES
	(1, 1001, 'Deposit', 1000.00, '2023-01-11 10:30:00', 'Initial Deposit'),
	(2, 1001, 'Withdrawal', 500.00, '2023-01-12 14:45:00', 'ATM Withdrawal'),
	(3, 1002, 'Deposit', 2000.00, '2023-01-12 15:20:00', 'Paycheck Deposit'),
	(4, 1003, 'Transfer', 1500.00, '2023-01-15 11:10:00', 'Transfer to Friend'),
	(5, 1004, 'Deposit', 500.00, '2023-01-16 09:05:00', 'Cash Deposit');

CREATE TABLE Loans(
	loan_id INT PRIMARY KEY,
	customer_id INT,
	loan_type VARCHAR(20),
	amount DECIMAL(10,2),
	interest_rate DECIMAL(5,2),
	start_date DATE,
	end_date DATE,
	status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
);
INSERT INTO Loans VALUES
	(101, 1, 'Personal', 10000.00, 5.50, '2023-02-01', '2026-02-01', 'Active'),
	(102, 3, 'Mortgage', 200000.00, 3.80, '2023-02-15', '2043-02-15', 'Active'),
	(103, 4, 'Auto', 15000.00, 6.20, '2023-03-01', '2028-03-01', 'Pending');

CREATE TABLE Cards(
	card_id INT PRIMARY KEY,
	customer_id INT,
	card_type VARCHAR(10),
	card_number VARCHAR(20),
	expiry_date DATE,
	cvv VARCHAR(10),
	issued_date DATE,
	status VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
INSERT INTO Cards VALUES
	(501, 1, 'Debit', '4532-7890-1234-5678', '2026-05-01', '123', '2023-01-15', 'Active'),
	(502, 2, 'Credit', '5123-4567-8901-2345', '2027-08-01', '456', '2023-01-20', 'Active'),
	(503, 3, 'Debit', '4000-1234-5678-9012', '2025-12-01', '789', '2023-02-01', 'Blocked');


-- 1. List all customers with their full names and email addresses.
SELECT customer_id, CONCAT(first_name,' ',last_name) AS Full_Name, email FROM Customers;

-- 2. Display all accounts with their account types and balances.
SELECT account_id, account_type, balance FROM Accounts;

-- 3. Show all transactions sorted by date (newest first).
SELECT * FROM Transactions
ORDER BY transaction_date;

-- 4. Find all active loans along with their loan types and amounts.
SELECT loan_id,customer_id, loan_type, amount, start_date,end_date,status FROM Loans
WHERE status='Active';

-- 5. List all credit/debit cards with their expiry dates and statuses.
SELECT *FROM Cards
WHERE card_type='Debit';
SELECT* FROM Cards
WHERE card_type='Credit';

-- 6. Find customers who live in 'New York'.
SELECT * FROM Customers
WHERE city='New York';

-- 7. List all savings accounts with a balance greater than $5,000.
SELECT* FROM Accounts
WHERE account_type='Savings' AND balance>5000.00;

-- 8. Show all transactions of type 'Deposit' that exceed $1,000.
SELECT * FROM Transactions
WHERE transaction_type='Deposit';

-- 9. Find all blocked cards (status = 'Blocked').
SELECT * FROM Cards
WHERE status='Blocked';

-- 10. List all pending loans (status = 'Pending').
SELECT * FROM Loans
WHERE status='Pending';

-- 11. Calculate the total balance of all accounts in the bank.
SELECT SUM(balance) AS Total_amount_in_bank FROM Accounts;

-- 12. Find the average loan amount for each loan type (Personal, Mortgage, Auto).
SELECT loan_type, ROUND(AVG(amount),2) AS Average_loan_ammount FROM Loans
GROUP BY loan_type;

-- 13. Count the number of customers per city.
SELECT city, COUNT(*) AS Total_Customers FROM Customers
GROUP BY city;

-- 14. Calculate the total amount of deposits and withdrawals separately.
SELECT transaction_type, SUM(amount) AS Total_amount FROM Transactions
WHERE transaction_type='Deposit' OR transaction_type='Withdrawal'
GROUP BY transaction_type;

-- 15.-- Find the highest and lowest account balances.
SELECT account_id,customer_id, balance FROM Accounts
ORDER BY balance DESC
LIMIT 1;
SELECT account_id,customer_id, balance FROM Accounts
ORDER BY balance ASC
LIMIT 1;

-- 16. Display customer names along with their account details (account ID, type, balance).
SELECT CONCAT(c.first_name,' ',c.last_name) AS Customer_name, a.account_id, a.account_type, a.balance 
FROM Customers AS c
LEFT JOIN Accounts AS a ON 
	c.customer_id=a.customer_id;
    
-- 17. List all transactions with the customer’s name and account type.
SELECT CONCAT(c.first_name,' ',c.last_name) AS Customer_name,t.transaction_id,t.account_id,a.account_type,transaction_type,t.amount,t.transaction_date,t.description
FROM Accounts AS a
RIGHT JOIN  Transactions AS t ON 
	t.account_id=a.account_id
LEFT JOIN Customers AS c ON 
	c.customer_id=a.customer_id;
-- 18. Show all loans along with the customer’s name and contact info.
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_name, l.loan_id,l.loan_type,l.amount,c.email,c.phone
FROM Loans AS l
LEFT JOIN Customers AS c ON 
	l.customer_id=c.customer_id;
    
-- 19. Find all employees and the branches they work at.
SELECT e.employee_id, CONCAT(e.first_name,' ',e.last_name) AS Employee_name,b.branch_id, b.branch_name
FROM Employees AS e
LEFT JOIN Branches AS b ON 
	e.branch_id=b.branch_id;
    
-- 20. List all cards with their respective customer names and phone numbers.
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_name,cd.card_id,cd.card_type,cd.card_number,cd.expiry_date,cd.cvv, 
cd.issued_date,cd.status
FROM Cards AS cd
LEFT JOIN Customers AS c ON 
	c.customer_id=cd.customer_id;
    
-- 21. Find all accounts opened in January 2023.
SELECT * FROM Accounts 
WHERE YEAR(opened_date)='2023' AND MONTH(opened_date)='1';

-- 22. List transactions that happened on a specific date (e.g., '2023-01-12').
SELECT * FROM Transactions 
WHERE DATE(transaction_date)='2023-01-12';

-- 23. Find customers who were born before 1990.
SELECT * FROM Customers
WHERE YEAR(date_of_birth)<'1990';

-- 24. Show loans that will end in the next 5 years.
SELECT * FROM Loans
WHERE FLOOR(DATEDIFF(NOW(),end_date)/365.25)<5;