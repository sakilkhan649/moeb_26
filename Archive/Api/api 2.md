11:45:59 AM | Invoice BDD Flow > STEP 2 — Fetch summary of invoices | stdout

📝 USER STORY:
As a user
I want to view all my invoices
So that I can verify my records

📖 BDD SCENARIO: 2. FETCH INVOICES
Feature: Invoices

Given I am an authenticated user
When I GET /api/v1/invoices
Then I receive a 200 OK response
And the response contains a list of my invoices

11:45:59 AM | Invoice BDD Flow > STEP 2 — Fetch summary of invoices | stdout


 GET   /api/v1/invoices [BDD-02-FETCH-INVOICES] - Retrieve a list of invoices
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgxNDE3YWMwOWQzYmRhZWM4MzdlMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNTQzNTksImV4cCI6MTc4NjI1Nzk1OX0.5dhUfG3aC1wJlsZroS91E7fh7WUyedS6sNIeDc1OAAg"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoices retrieved successfully",
  "pagination": {
    "total": 1,
    "limit": 10,
    "page": 1,
    "totalPage": 1
  },
  "data": [
    {
      "senderDetails": {
        "businessName": "My Awesome Biz",
        "email": "contact@mybiz.com",
        "phoneNumber": "9876543210",
        "website": "https://mybiz.com",
        "address": "456 Tech Park, Sillicon Valley",
        "logo": "https://mybiz.com/logo.png"
      },
      "invoiceAmount": 500,
      "issueDate": "2026-08-09T05:45:59.792Z",
      "dueDateType": "custom",
      "customDueDate": "2026-08-16T05:45:59.793Z",
      "currency": "USD",
      "clientName": "Acme Corp",
      "businessName": "Acme LLC",
      "emailAddress": "client@acme.com",
      "phoneNumber": "+1-555-0198",
      "billingAddress": {
        "streetAddress": "123 Main St",
        "city": "Metropolis",
        "state": "NY",
        "zipCode": "10001",
        "country": "USA"
      },
      "description": "Web development services",
      "messageToClient": "Thank you for your business!",
      "status": "unpaid",
      "user": "6a781417ac09d3bdaec837e2",
      "createdAt": "2026-08-09T05:45:59.813Z",
      "updatedAt": "2026-08-09T05:45:59.813Z",
      "invoiceNumber": "INV-000001",
      "id": "6a781417ac09d3bdaec83816"
    }
  ]
}


11:45:59 AM | Invoice BDD Flow > STEP 3 — Fetch a single invoice | stdout

📝 USER STORY:
As a user
I want to view a specific invoice
So that I can see its details

📖 BDD SCENARIO: 3. FETCH SINGLE INVOICE
Feature: Invoices

Given I am an authenticated user
When I GET /api/v1/invoices/:invoiceId
Then I receive a 200 OK response
And the response contains the invoice details

11:45:59 AM | Invoice BDD Flow > STEP 3 — Fetch a single invoice | stdout


 GET   /api/v1/invoices/6a781417ac09d3bdaec83816 [BDD-03-FETCH-SINGLE-INVOICE] - Retrieve a single invoice
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgxNDE3YWMwOWQzYmRhZWM4MzdlMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNTQzNTksImV4cCI6MTc4NjI1Nzk1OX0.5dhUfG3aC1wJlsZroS91E7fh7WUyedS6sNIeDc1OAAg"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoice retrieved successfully",
  "data": {
    "senderDetails": {
      "businessName": "My Awesome Biz",
      "email": "contact@mybiz.com",
      "phoneNumber": "9876543210",
      "website": "https://mybiz.com",
      "address": "456 Tech Park, Sillicon Valley",
      "logo": "https://mybiz.com/logo.png"
    },
    "invoiceAmount": 500,
    "issueDate": "2026-08-09T05:45:59.792Z",
    "dueDateType": "custom",
    "customDueDate": "2026-08-16T05:45:59.793Z",
    "currency": "USD",
    "clientName": "Acme Corp",
    "businessName": "Acme LLC",
    "emailAddress": "client@acme.com",
    "phoneNumber": "+1-555-0198",
    "billingAddress": {
      "streetAddress": "123 Main St",
      "city": "Metropolis",
      "state": "NY",
      "zipCode": "10001",
      "country": "USA"
    },
    "description": "Web development services",
    "messageToClient": "Thank you for your business!",
    "status": "unpaid",
    "user": "6a781417ac09d3bdaec837e2",
    "createdAt": "2026-08-09T05:45:59.813Z",
    "updatedAt": "2026-08-09T05:45:59.813Z",
    "invoiceNumber": "INV-000001",
    "id": "6a781417ac09d3bdaec83816"
  }
}


11:45:59 AM | Invoice BDD Flow > STEP 4 — Update an invoice | stdout

📝 USER STORY:
As a user
I want to update an existing invoice
So that I can correct mistakes

📖 BDD SCENARIO: 4. UPDATE INVOICE
Feature: Invoices

Given I am an authenticated user
And I have an existing invoice ID
When I PATCH /api/v1/invoices/:invoiceId
Then I receive a 200 OK response
And the response contains the updated invoice details

11:45:59 AM | Invoice BDD Flow > STEP 4 — Update an invoice | stdout


 PATCH   /api/v1/invoices/6a781417ac09d3bdaec83816 [BDD-04-UPDATE-INVOICE] - Update an existing invoice
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "invoiceAmount": 600,
    "status": "paid"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgxNDE3YWMwOWQzYmRhZWM4MzdlMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNTQzNTksImV4cCI6MTc4NjI1Nzk1OX0.5dhUfG3aC1wJlsZroS91E7fh7WUyedS6sNIeDc1OAAg"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoice updated successfully",
  "data": {
    "senderDetails": {
      "businessName": "My Awesome Biz",
      "email": "contact@mybiz.com",
      "phoneNumber": "9876543210",
      "website": "https://mybiz.com",
      "address": "456 Tech Park, Sillicon Valley",
      "logo": "https://mybiz.com/logo.png"
    },
    "invoiceAmount": 600,
    "issueDate": "2026-08-09T05:45:59.792Z",
    "dueDateType": "custom",
    "customDueDate": "2026-08-16T05:45:59.793Z",
    "currency": "USD",
    "clientName": "Acme Corp",
    "businessName": "Acme LLC",
    "emailAddress": "client@acme.com",
    "phoneNumber": "+1-555-0198",
    "billingAddress": {
      "streetAddress": "123 Main St",
      "city": "Metropolis",
      "state": "NY",
      "zipCode": "10001",
      "country": "USA"
    },
    "description": "Web development services",
    "messageToClient": "Thank you for your business!",
    "status": "paid",
    "user": "6a781417ac09d3bdaec837e2",
    "createdAt": "2026-08-09T05:45:59.813Z",
    "updatedAt": "2026-08-09T05:45:59.869Z",
    "invoiceNumber": "INV-000001",
    "id": "6a781417ac09d3bdaec83816"
  }
}


11:45:59 AM | Invoice BDD Flow > STEP 5 — Delete an invoice | stdout

📝 USER STORY:
As a user
I want to delete an existing invoice
So that I can remove incorrect records

📖 BDD SCENARIO: 5. DELETE INVOICE
Feature: Invoices

Given I am an authenticated user
And I have an existing invoice ID
When I DELETE /api/v1/invoices/:invoiceId
Then I receive a 200 OK response
And the invoice is removed from my list

11:45:59 AM | Invoice BDD Flow > STEP 5 — Delete an invoice | stdout


 DELETE   /api/v1/invoices/6a781417ac09d3bdaec83816 [BDD-05-DELETE-INVOICE] - Delete an existing invoice
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgxNDE3YWMwOWQzYmRhZWM4MzdlMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNTQzNTksImV4cCI6MTc4NjI1Nzk1OX0.5dhUfG3aC1wJlsZroS91E7fh7WUyedS6sNIeDc1OAAg"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoice deleted successfully",
  "data": {
    "senderDetails": {
      "businessName": "My Awesome Biz",
      "email": "contact@mybiz.com",
      "phoneNumber": "9876543210",
      "website": "https://mybiz.com",
      "address": "456 Tech Park, Sillicon Valley",
      "logo": "https://mybiz.com/logo.png"
    },
    "invoiceAmount": 600,
    "issueDate": "2026-08-09T05:45:59.792Z",
    "dueDateType": "custom",
    "customDueDate": "2026-08-16T05:45:59.793Z",
    "currency": "USD",
    "clientName": "Acme Corp",
    "businessName": "Acme LLC",
    "emailAddress": "client@acme.com",
    "phoneNumber": "+1-555-0198",
    "billingAddress": {
      "streetAddress": "123 Main St",
      "city": "Metropolis",
      "state": "NY",
      "zipCode": "10001",
      "country": "USA"
    },
    "description": "Web development services",
    "messageToClient": "Thank you for your business!",
    "status": "paid",
    "user": "6a781417ac09d3bdaec837e2",
    "createdAt": "2026-08-09T05:45:59.813Z",
    "updatedAt": "2026-08-09T05:45:59.869Z",
    "invoiceNumber": "INV-000001",
    "id": "6a781417ac09d3bdaec83816"
  }
}