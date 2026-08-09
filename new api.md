📝 USER STORY:
As a user
I want to create an invoice
So that I can bill my clients

📖 BDD SCENARIO: 1. CREATE INVOICE
Feature: Invoices

Given I am an authenticated user
When I POST /api/v1/invoices with valid payload
Then I receive a 201 Created response
And the response contains the newly created invoice

10:07:23 AM | Invoice BDD Flow > STEP 1 — Add an invoice successfully | stdout


 POST   /api/v1/invoices [BDD-01-CREATE-INVOICE] - Create an invoice
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "invoiceAmount": 500,
    "issueDate": "2026-08-09T04:07:23.654Z",
    "dueDateType": "custom",
    "customDueDate": "2026-08-16T04:07:23.654Z",
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
    "messageToClient": "Thank you for your business!"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzdmY2ZiNWU2OTQ2NjY1MGY5OWM3MiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNDg0NDMsImV4cCI6MTc4NjI1MjA0M30.Cv5gkea_7HuldXKh9dt5_VlVl_QZcx2BUWj_dfYxAnQ"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoice created successfully",
  "data": {
    "invoiceAmount": 500,
    "issueDate": "2026-08-09T04:07:23.654Z",
    "dueDateType": "custom",
    "customDueDate": "2026-08-16T04:07:23.654Z",
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
    "status": "draft",
    "user": "6a77fcfb5e69466650f99c72",
    "createdAt": "2026-08-09T04:07:23.698Z",
    "updatedAt": "2026-08-09T04:07:23.698Z",
    "invoiceNumber": "INV-000001",
    "id": "6a77fcfb5e69466650f99c9b"
  }
}




10:07:23 AM | Invoice BDD Flow > STEP 2 — Fetch summary of invoices | stdout

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

10:07:23 AM | Invoice BDD Flow > STEP 2 — Fetch summary of invoices | stdout


 GET   /api/v1/invoices [BDD-02-FETCH-INVOICES] - Retrieve a list of invoices
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzdmY2ZiNWU2OTQ2NjY1MGY5OWM3MiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNDg0NDMsImV4cCI6MTc4NjI1MjA0M30.Cv5gkea_7HuldXKh9dt5_VlVl_QZcx2BUWj_dfYxAnQ"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoices retrieved successfully",
  "data": [
    {
      "invoiceAmount": 500,
      "issueDate": "2026-08-09T04:07:23.654Z",
      "dueDateType": "custom",
      "customDueDate": "2026-08-16T04:07:23.654Z",
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
      "status": "draft",
      "user": "6a77fcfb5e69466650f99c72",
      "createdAt": "2026-08-09T04:07:23.698Z",
      "updatedAt": "2026-08-09T04:07:23.698Z",
      "invoiceNumber": "INV-000001",
      "id": "6a77fcfb5e69466650f99c9b"
    }
  ]
}






11:20:27 AM | Invoice BDD Flow > STEP 0.1 — Upsert an invoice profile | stdout

📝 USER STORY:
As a user
I want to create or update my invoice profile
So that my business details are automatically attached to new invoices

📖 BDD SCENARIO: 0.1. UPSERT INVOICE PROFILE
Feature: Invoices

Given I am an authenticated user
When I PUT /api/v1/invoices/profile with valid payload
Then I receive a 200 OK response
And the response contains my updated profile details

11:20:27 AM | Invoice BDD Flow > STEP 0.1 — Upsert an invoice profile | stdout


 PUT   /api/v1/invoices/profile [BDD-00-1-UPSERT-INVOICE-PROFILE] - Create or update an invoice profile
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "businessName": "My Awesome Biz",
    "email": "contact@mybiz.com",
    "phoneNumber": "9876543210",
    "website": "https://mybiz.com",
    "address": "456 Tech Park, Sillicon Valley",
    "logo": "https://mybiz.com/logo.png"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgwZTFiMzkwYzgzMjllNTQxYmMzOSIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNTI4MjcsImV4cCI6MTc4NjI1NjQyN30.eU1PiMthoeXd-532RwbA6C_jW0VKKfEzCdjR_8WbG9g"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoice profile saved successfully",
  "data": {
    "user": "6a780e1b390c8329e541bc39",
    "address": "456 Tech Park, Sillicon Valley",
    "businessName": "My Awesome Biz",
    "createdAt": "2026-08-09T05:20:27.753Z",
    "email": "contact@mybiz.com",
    "logo": "https://mybiz.com/logo.png",
    "phoneNumber": "9876543210",
    "updatedAt": "2026-08-09T05:20:27.753Z",
    "website": "https://mybiz.com",
    "id": "6a780e1bdfb619a9021e2c30"
  }
}


11:20:27 AM | Invoice BDD Flow > STEP 0.2 — Fetch my invoice profile | stdout

📝 USER STORY:
As a user
I want to view my invoice profile
So that I can verify my business details

📖 BDD SCENARIO: 0.2. FETCH INVOICE PROFILE
Feature: Invoices

Given I am an authenticated user
And I have an existing invoice profile
When I GET /api/v1/invoices/profile
Then I receive a 200 OK response
And the response contains my profile details

11:20:27 AM | Invoice BDD Flow > STEP 0.2 — Fetch my invoice profile | stdout


 GET   /api/v1/invoices/profile [BDD-00-2-FETCH-INVOICE-PROFILE] - Retrieve invoice profile
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgwZTFiMzkwYzgzMjllNTQxYmMzOSIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNTI4MjcsImV4cCI6MTc4NjI1NjQyN30.eU1PiMthoeXd-532RwbA6C_jW0VKKfEzCdjR_8WbG9g"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Invoice profile retrieved successfully",
  "data": {
    "user": "6a780e1b390c8329e541bc39",
    "address": "456 Tech Park, Sillicon Valley",
    "businessName": "My Awesome Biz",
    "createdAt": "2026-08-09T05:20:27.753Z",
    "email": "contact@mybiz.com",
    "logo": "https://mybiz.com/logo.png",
    "phoneNumber": "9876543210",
    "updatedAt": "2026-08-09T05:20:27.753Z",
    "website": "https://mybiz.com",
    "id": "6a780e1bdfb619a9021e2c30"
  }
}