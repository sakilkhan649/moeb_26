4:17:56 PM | Expense BDD Flow > STEP 1 — Add a required expense (fuel) successfully | stdout
📝 USER STORY:
As a user
I want to log a basic office expense
So that the company can track my spending
📖 BDD SCENARIO: 1. ADD REQUIRED EXPENSE
Feature: Expenses
Given I am an authenticated user
When I POST /api/v1/expenses with Office Supplies category and amount
Then I receive a 201 Created response
And the response contains the newly created expense
 
4:17:56 PM | Expense BDD Flow > STEP 1 — Add a required expense (fuel) successfully | stdout
 POST   /api/v1/expenses [BDD-01-OFFICE-EXPENSE] - Create a required expense REQUEST {  "params": {},  "query": {},  "body": {    "category": "Office Supplies",    "amount": 50.5,    "date": "2026-08-04T10:17:56.102Z"  },  "headers": {    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFiYzUzMDQ4Nzc0ZDI5OWU4YWEzZiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTgzODY3NiwiZXhwIjoxNzg1ODQyMjc2fQ.EdfTFjJFPUxKUPXE2bSAQ1oFQx4j15ncdaVw1WEpXdo"  }} RESPONSE SUCCESS {  "success": true,  "message": "Expense created successfully",  "data": {    "user": "6a71bc53048774d299e8aa3f",    "category": "Office Supplies",    "amount": 50.5,    "date": "2026-08-04T10:17:56.102Z",    "createdAt": "2026-08-04T10:17:56.148Z",    "updatedAt": "2026-08-04T10:17:56.148Z",    "id": "6a71bc54048774d299e8aa67"  }}
4:17:56 PM | Expense BDD Flow > STEP 2 — Add an expense with all optional fields (insurance) | stdout
📝 USER STORY:
As a user
I want to log a software subscription expense with a receipt and description
So that I have full proof of my expenditure
📖 BDD SCENARIO: 2. ADD OPTIONAL EXPENSE FIELDS
Feature: Expenses
Given I am an authenticated user
When I POST /api/v1/expenses with Software Subscription category, description, and receipt
Then I receive a 201 Created response
And the response contains all the optional fields
 
4:17:56 PM | Expense BDD Flow > STEP 2 — Add an expense with all optional fields (insurance) | stdout
 POST   /api/v1/expenses [BDD-02-SOFTWARE-EXPENSE] - Create an expense with optional fields REQUEST {  "params": {},  "query": {},  "body": {    "category": "Software Subscription",    "amount": 150,    "date": "2026-08-04T10:17:56.165Z",    "description": "Monthly premium",    "receipt": "[FILE: receipt.pdf]"  },  "headers": {    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFiYzUzMDQ4Nzc0ZDI5OWU4YWEzZiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTgzODY3NiwiZXhwIjoxNzg1ODQyMjc2fQ.EdfTFjJFPUxKUPXE2bSAQ1oFQx4j15ncdaVw1WEpXdo"  }} RESPONSE SUCCESS {  "success": true,  "message": "Expense created successfully",  "data": {    "user": "6a71bc53048774d299e8aa3f",    "category": "Software Subscription",    "amount": 150,    "date": "2026-08-04T10:17:56.165Z",    "description": "Monthly premium",    "receipt": "//uploads/documents/1785838676176-aw7cqd.pdf",    "createdAt": "2026-08-04T10:17:56.179Z",    "updatedAt": "2026-08-04T10:17:56.179Z",    "id": "6a71bc54048774d299e8aa6b"  }}
 
ei gula intrgte kori peln bhai moeb26 e
 
ok
 


 4:52:27 PM | Expense BDD Flow > STEP 1 — Add a required expense (fuel) successfully | stdout

📝 USER STORY:
As a user
I want to log a basic office expense
So that the company can track my spending

📖 BDD SCENARIO: 1. ADD REQUIRED EXPENSE
Feature: Expenses

Given I am an authenticated user
When I POST /api/v1/expenses with Office Supplies category and amount
Then I receive a 201 Created response
And the response contains the newly created expense

4:52:27 PM | Expense BDD Flow > STEP 1 — Add a required expense (fuel) successfully | stdout


 POST   /api/v1/expenses [BDD-01-OFFICE-EXPENSE] - Create a required expense
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "category": "Office Supplies",
    "amount": 50.5,
    "date": "2026-08-04T10:52:27.666Z"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Expense created successfully",
  "data": {
    "user": "6a71c46b3f522a5d963bafe6",
    "category": "Office Supplies",
    "amount": 50.5,
    "date": "2026-08-04T10:52:27.666Z",
    "createdAt": "2026-08-04T10:52:27.709Z",
    "updatedAt": "2026-08-04T10:52:27.709Z",
    "id": "6a71c46b3f522a5d963bb00e"
  }
}


4:52:27 PM | Expense BDD Flow > STEP 2 — Add an expense with all optional fields (insurance) | stdout

📝 USER STORY:
As a user
I want to log a software subscription expense with a receipt and description
So that I have full proof of my expenditure

📖 BDD SCENARIO: 2. ADD OPTIONAL EXPENSE FIELDS
Feature: Expenses

Given I am an authenticated user
When I POST /api/v1/expenses with Software Subscription category, description, and receipt
Then I receive a 201 Created response
And the response contains all the optional fields

4:52:27 PM | Expense BDD Flow > STEP 2 — Add an expense with all optional fields (insurance) | stdout


 POST   /api/v1/expenses [BDD-02-SOFTWARE-EXPENSE] - Create an expense with optional fields
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "category": "Software Subscription",
    "amount": 150,
    "date": "2026-08-04T10:52:27.726Z",
    "description": "Monthly premium",
    "receipt": "[FILE: receipt.pdf]"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Expense created successfully",
  "data": {
    "user": "6a71c46b3f522a5d963bafe6",
    "category": "Software Subscription",
    "amount": 150,
    "date": "2026-08-04T10:52:27.726Z",
    "description": "Monthly premium",
    "receipt": "//uploads/documents/1785840747737-thnrzl.pdf",
    "createdAt": "2026-08-04T10:52:27.741Z",
    "updatedAt": "2026-08-04T10:52:27.741Z",
    "id": "6a71c46b3f522a5d963bb012"
  }
}


4:52:27 PM | Expense BDD Flow > STEP 3 — Fetch summary of expenses and validate DTOs map correctly | stdout

📝 USER STORY:
As a user
I want to view all my submitted expenses
So that I can verify my records

📖 BDD SCENARIO: 3. FETCH EXPENSE SUMMARY
Feature: Expenses

Given I am an authenticated user
When I GET /api/v1/expenses
Then I receive a 200 OK response
And the response contains a list of my expenses

4:52:27 PM | Expense BDD Flow > STEP 3 — Fetch summary of expenses and validate DTOs map correctly | stdout


 GET   /api/v1/expenses [BDD-03-FETCH-EXPENSES] - Retrieve a list of expenses
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Expenses retrieved successfully",
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 2,
    "totalPage": 1
  },
  "data": [
    {
      "user": "6a71c46b3f522a5d963bafe6",
      "category": "Software Subscription",
      "amount": 150,
      "date": "2026-08-04T10:52:27.726Z",
      "description": "Monthly premium",
      "receipt": "//uploads/documents/1785840747737-thnrzl.pdf",
      "createdAt": "2026-08-04T10:52:27.741Z",
      "updatedAt": "2026-08-04T10:52:27.741Z",
      "id": "6a71c46b3f522a5d963bb012"
    },
    {
      "user": "6a71c46b3f522a5d963bafe6",
      "category": "Office Supplies",
      "amount": 50.5,
      "date": "2026-08-04T10:52:27.666Z",
      "createdAt": "2026-08-04T10:52:27.709Z",
      "updatedAt": "2026-08-04T10:52:27.709Z",
      "id": "6a71c46b3f522a5d963bb00e"
    }
  ]
}


4:52:27 PM | Expense BDD Flow > STEP 4 — Fetch total of expenses | stdout

📝 USER STORY:
As a user
I want to view my total expenses
So that I can see my overall spending

📖 BDD SCENARIO: 4. FETCH TOTAL EXPENSES
Feature: Expenses

Given I am an authenticated user
When I GET /api/v1/expenses/total
Then I receive a 200 OK response
And the response contains the total amount of my expenses

4:52:27 PM | Expense BDD Flow > STEP 4 — Fetch total of expenses | stdout


 GET   /api/v1/expenses/total [BDD-04-FETCH-TOTAL] - Retrieve total of expenses
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Total expenses calculated successfully",
  "data": {
    "total": 200.5
  }
}


4:52:27 PM | Expense BDD Flow > STEP 5 — Fetch monthly expenses | stdout

📝 USER STORY:
As a user
I want to view my monthly expenses
So that I can see my spending for the current month

📖 BDD SCENARIO: 5. FETCH MONTHLY EXPENSES
Feature: Expenses

Given I am an authenticated user
When I GET /api/v1/expenses?period=monthly
Then I receive a 200 OK response
And the response contains a list of my expenses for the month

4:52:27 PM | Expense BDD Flow > STEP 5 — Fetch monthly expenses | stdout


 GET   /api/v1/expenses?startDate=2026-08-01T10:52:27.779Z&endDate=2026-08-31T17:59:59.999Z [BDD-05-FETCH-MONTHLY-EXPENSES] - Retrieve a list of expenses by date range
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Expenses retrieved successfully",
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 2,
    "totalPage": 1
  },
  "data": [
    {
      "user": "6a71c46b3f522a5d963bafe6",
      "category": "Software Subscription",
      "amount": 150,
      "date": "2026-08-04T10:52:27.726Z",
      "description": "Monthly premium",
      "receipt": "//uploads/documents/1785840747737-thnrzl.pdf",
      "createdAt": "2026-08-04T10:52:27.741Z",
      "updatedAt": "2026-08-04T10:52:27.741Z",
      "id": "6a71c46b3f522a5d963bb012"
    },
    {
      "user": "6a71c46b3f522a5d963bafe6",
      "category": "Office Supplies",
      "amount": 50.5,
      "date": "2026-08-04T10:52:27.666Z",
      "createdAt": "2026-08-04T10:52:27.709Z",
      "updatedAt": "2026-08-04T10:52:27.709Z",
      "id": "6a71c46b3f522a5d963bb00e"
    }
  ]
}


4:52:27 PM | Expense BDD Flow > STEP 6 — Fetch monthly total of expenses | stdout

📝 USER STORY:
As a user
I want to view my total expenses for the current month
So that I can monitor my monthly budget

📖 BDD SCENARIO: 6. FETCH MONTHLY TOTAL EXPENSES
Feature: Expenses

Given I am an authenticated user
When I GET /api/v1/expenses/total?period=monthly
Then I receive a 200 OK response
And the response contains the total amount of my monthly expenses

4:52:27 PM | Expense BDD Flow > STEP 6 — Fetch monthly total of expenses | stdout


 GET   /api/v1/expenses/total?startDate=2026-08-01T10:52:27.795Z&endDate=2026-08-31T17:59:59.999Z [BDD-06-FETCH-MONTHLY-TOTAL] - Retrieve total of expenses by date range
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Total expenses calculated successfully",
  "data": {
    "total": 200.5
  }
}


4:52:27 PM | Expense BDD Flow > STEP 7 — Update an expense | stdout

📝 USER STORY:
As a user
I want to update an existing expense
So that I can correct mistakes or add details

📖 BDD SCENARIO: 7. UPDATE EXPENSE
Feature: Expenses

Given I am an authenticated user
And I have an existing expense ID
When I PATCH /api/v1/expenses/:expenseId
Then I receive a 200 OK response
And the response contains the updated expense details

4:52:27 PM | Expense BDD Flow > STEP 7 — Update an expense | stdout


 PATCH   /api/v1/expenses/6a71c46b3f522a5d963bb00e [BDD-07-UPDATE-EXPENSE] - Update an existing expense
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "amount": 200,
    "description": "Updated premium"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Expense updated successfully",
  "data": {
    "user": "6a71c46b3f522a5d963bafe6",
    "category": "Office Supplies",
    "amount": 200,
    "date": "2026-08-04T10:52:27.666Z",
    "createdAt": "2026-08-04T10:52:27.709Z",
    "updatedAt": "2026-08-04T10:52:27.811Z",
    "description": "Updated premium",
    "id": "6a71c46b3f522a5d963bb00e"
  }
}


4:52:27 PM | Expense BDD Flow > STEP 8 — Delete an expense | stdout

📝 USER STORY:
As a user
I want to delete an existing expense
So that I can remove incorrect records

📖 BDD SCENARIO: 8. DELETE EXPENSE
Feature: Expenses

Given I am an authenticated user
And I have an existing expense ID
When I DELETE /api/v1/expenses/:expenseId
Then I receive a 200 OK response
And the expense is removed from my list

4:52:27 PM | Expense BDD Flow > STEP 8 — Delete an expense | stdout


 DELETE   /api/v1/expenses/6a71c46b3f522a5d963bb00e [BDD-08-DELETE-EXPENSE] - Delete an existing expense
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzFjNDZiM2Y1MjJhNWQ5NjNiYWZlNiIsInJvbGUiOiJEUklWRVIiLCJlbWFpbCI6ImRyaXZlckB0ZXN0LmNvbSIsImlhdCI6MTc4NTg0MDc0NywiZXhwIjoxNzg1ODQ0MzQ3fQ.fIdGMmr1iYXfgOKLljE1eYVGR5o8XwH8Z_arpp1xwJM"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Expense deleted successfully",
  "data": {
    "user": "6a71c46b3f522a5d963bafe6",
    "category": "Office Supplies",
    "amount": 200,
    "date": "2026-08-04T10:52:27.666Z",
    "createdAt": "2026-08-04T10:52:27.709Z",
    "updatedAt": "2026-08-04T10:52:27.811Z",
    "description": "Updated premium",
    "id": "6a71c46b3f522a5d963bb00e"
  }
}