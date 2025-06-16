# First National Bank Database
## Overview
#### Project: Bank Database Analysis 
#### Database: FNB_db
The FNB_db is a relational database designed to manage and organize essential information for a financial institution, such as a bank. It stores data related to customers, employees, branches, accounts, transactions, loans, and cards. The database structure ensures efficient tracking of banking operations, customer interactions, and financial services, all while maintaining data integrity through foreign key relationships.
## Objectives 
#### 1. Customer Management:
Store detailed information on bank customers, including contact details and account affiliations.
#### 2. Account & Transaction Tracking:
Maintain records of various account types and all associated transactions for transparency and auditing.
#### 3. Branch and Employee Organization:
Link employees to specific branches to track staffing and administrative responsibilities.
#### 4. Loan Monitoring: 
Record and monitor personal, auto, and mortgage loans, including amounts, interest rates, and statuses.
#### 5. Card Issuance and Control: 
Manage credit and debit card information, including card status, type, and expiry.
#### 6. Data Analysis and Reporting: 
Enable meaningful business insights such as customer distribution by city, total account balances, and loan statistics using SQL queries.

## Database Creation
``` SQL
CREATE DATABASE FNB_db;
USE FNB_db;
```
## Tables Creation
### Customers
```CREATE TABLE Customers(
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
```
### Branches
```sql
CREATE TABLE Branches(
        branch_id INT PRIMARY KEY,
        branch_name VARCHAR(100) NOT NULL,
        address VARCHAR(50) NOT NULL,
        city VARCHAR(20),
        state VARCHAR(20),
        zip_code VARCHAR(10),
        phone VARCHAR(15) UNIQUE
);
```
### Employees
```sql
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
```
### Accounts
```sql
CREATE TABLE Accounts(
        account_id INT PRIMARY KEY,
        customer_id INT,
        account_type VARCHAR(15) NOT NULL,
        balance DECIMAL(10,2),
        opened_date DATE,
        status VARCHAR(25),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) 
);
```
### Transactions 
```sql
CREATE TABLE Transactions(
        transaction_id INT PRIMARY KEY,
        account_id INT,
        transaction_type VARCHAR(20),
        amount DECIMAL(10,2),
        transaction_date DATETIME,
        description VARCHAR(50),
    FOREIGN KEY (account_id)  REFERENCES Accounts(account_id)
);
```
### Loans
```sql
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
```
### Cards
```sql
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
```
## Key Queries 
#### 1. List all customers with their full names and email addresses.
```sql
SELECT customer_id, CONCAT(first_name,' ',last_name) AS Full_Name, email FROM Customers;
```
#### 2. Display all accounts with their account types and balances.
```sql
SELECT account_id, account_type, balance FROM Accounts;
```
#### 3. Show all transactions sorted by date (newest first).
```sql
SELECT * FROM Transactions
ORDER BY transaction_date DESC;
```
#### 4. Find all active loans along with their loan types and amounts.
```sql
SELECT loan_id,customer_id, loan_type, amount, start_date,end_date,status FROM Loans
WHERE status='Active';
```
#### 5. List all credit/debit cards with their expiry dates and statuses.
```sql
SELECT *FROM Cards
WHERE card_type='Debit';
SELECT* FROM Cards
WHERE card_type='Credit';
```
#### 6. Find customers who live in 'New York'.
```sql
SELECT * FROM Customers
WHERE city='New York';
```
#### 7. List all savings accounts with a balance greater than $5,000.
```sql
SELECT* FROM Accounts
WHERE account_type='Savings' AND balance>5000.00;
```
#### 8. Show all transactions of type 'Deposit' that exceed $1,000.
```sql
SELECT * FROM Transactions
WHERE transaction_type='Deposit' AND amount>1000.00;
```
#### 9. Find all blocked cards (status = 'Blocked').
```sql
SELECT * FROM Cards
WHERE status='Blocked';
```
#### 10. List all pending loans (status = 'Pending').
```sql
SELECT * FROM Loans
WHERE status='Pending';
```
#### 11. Calculate the total balance of all accounts in the bank.
```sql
SELECT SUM(balance) AS Total_amount_in_bank FROM Accounts;
```
#### 12. Find the average loan amount for each loan type (Personal, Mortgage, Auto).
```sql
SELECT loan_type, ROUND(AVG(amount),2) AS Average_loan_amount FROM Loans
GROUP BY loan_type;
```
#### 13. Count the number of customers per city.
```sql
SELECT city, COUNT(*) AS Total_Customers FROM Customers
GROUP BY city;
```
#### 14. Calculate the total amount of deposits and withdrawals separately.
```sql
SELECT transaction_type, SUM(amount) AS Total_amount FROM Transactions
WHERE transaction_type='Deposit' OR transaction_type='Withdrawal'
GROUP BY transaction_type;
```
#### 15. Find the highest and lowest account balances.
```sql
SELECT account_id,customer_id, balance FROM Accounts
ORDER BY balance DESC
LIMIT 1;
SELECT account_id,customer_id, balance FROM Accounts
ORDER BY balance ASC
LIMIT 1;
```
#### 16. Display customer names along with their account details (account ID, type, balance).
```sql
SELECT CONCAT(c.first_name,' ',c.last_name) AS Customer_name, a.account_id, a.account_type, a.balance 
FROM Customers AS c
LEFT JOIN Accounts AS a ON 
        c.customer_id=a.customer_id;
```
#### 17. List all transactions with the customer’s name and account type.
```sql
SELECT CONCAT(c.first_name,' ',c.last_name) AS Customer_name,t.transaction_id,t.account_id,a.account_type,transaction_type,t.amount,t.transaction_date,t.description
FROM Accounts AS a
RIGHT JOIN  Transactions AS t ON 
        t.account_id=a.account_id
LEFT JOIN Customers AS c ON 
        c.customer_id=a.customer_id;
```
#### 18. Show all loans along with the customer’s name and contact info.
```sql
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_name, l.loan_id,l.loan_type,l.amount,c.email,c.phone
FROM Loans AS l
LEFT JOIN Customers AS c ON 
        l.customer_id=c.customer_id;
```
#### 19. Find all employees and the branches they work at.
```sql
SELECT e.employee_id, CONCAT(e.first_name,' ',e.last_name) AS Employee_name,b.branch_id, b.branch_name
FROM Employees AS e
LEFT JOIN Branches AS b ON 
        e.branch_id=b.branch_id;
```
#### 20. List all cards with their respective customer names and phone numbers.
```sql
SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) AS Customer_name,cd.card_id,cd.card_type,cd.card_number,cd.expiry_date,cd.cvv, 
cd.issued_date,cd.status
FROM Cards AS cd
LEFT JOIN Customers AS c ON 
        c.customer_id=cd.customer_id;
```
#### 21. Find all accounts opened in January 2023.
```sql
SELECT * FROM Accounts 
WHERE YEAR(opened_date)='2023' AND MONTH(opened_date)='1';
```
#### 22. List transactions that happened on a specific date (e.g., '2023-01-12').
```sql
SELECT * FROM Transactions 
WHERE DATE(transaction_date)='2023-01-12';
```
#### 23. Find customers who were born before 1990.
```sql
SELECT * FROM Customers
WHERE YEAR(date_of_birth)<'1990';
```
#### 24. Show loans that will end in the next 5 years.
```sql
SELECT * FROM Loans
WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 5 YEAR);
```
## Conclusion
The FNB_db provides a comprehensive and scalable foundation for managing the core operations of a banking system. With clearly defined relationships and structured queries, it supports secure data handling, operational efficiency, and insightful financial reporting. It can serve as a base for further expansion into advanced banking features such as digital wallets, loan repayments, fraud detection, or customer analytics.