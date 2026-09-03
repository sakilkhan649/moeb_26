2:40:20 PM | Invoice BDD Flow > STEP 4.1 — Fetch auto-created client from invoice | stdout

📝 USER STORY:
As a user
I want to see the client that was automatically saved when I created an invoice
So that I don't have to manually re-enter their details later

📖 BDD SCENARIO: 4.1. FETCH AUTO-CREATED CLIENT
Feature: Invoice Clients

Given I am an authenticated user
And I have created an invoice for a new client
When I GET /api/v1/invoices/client
Then I receive a 200 OK response
And the list includes the client from the invoice

2:40:20 PM | Invoice BDD Flow > STEP 4.1 — Fetch auto-created client from invoice | stdout


 GET   /api/v1/invoices/client [BDD-04-1-FETCH-AUTO-CLIENT] - Retrieve automatically created client
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {},
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgzY2Y0NzMzMWY5N2Y3MTZiOWNmMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNjQ4MjAsImV4cCI6MTc4NjI2ODQyMH0.YFCK1WmlcXCEvpFuQxShWjQemuulyBW1E4GSbrGfcic"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Clients retrieved successfully",
  "pagination": {
    "total": 1,
    "limit": 10,
    "page": 1,
    "totalPage": 1
  },
  "data": [
    {
      "user": "6a783cf47331f97f716b9cf2",
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
      "createdAt": "2026-08-09T08:40:20.566Z",
      "updatedAt": "2026-08-09T08:40:20.566Z",
      "id": "6a783cf47331f97f716b9d2c"
    }
  ]
}


2:40:20 PM | Invoice BDD Flow > STEP 4.2 — Create a client manually | stdout

📝 USER STORY:
As a user
I want to manually add a client
So that I can invoice them later

📖 BDD SCENARIO: 4.2. CREATE CLIENT
Feature: Invoice Clients

Given I am an authenticated user
When I POST /api/v1/invoices/client
Then I receive a 201 Created response

2:40:20 PM | Invoice BDD Flow > STEP 4.2 — Create a client manually | stdout


 POST   /api/v1/invoices/client [BDD-04-2-CREATE-CLIENT] - Create a client manually
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "clientName": "Wayne Enterprises",
    "businessName": "Wayne Corp",
    "emailAddress": "contact@wayne.com",
    "phoneNumber": "+1-555-0000",
    "billingAddress": {
      "streetAddress": "1007 Mountain Drive",
      "city": "Gotham",
      "state": "NJ",
      "zipCode": "07001",
      "country": "USA"
    }
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgzY2Y0NzMzMWY5N2Y3MTZiOWNmMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNjQ4MjAsImV4cCI6MTc4NjI2ODQyMH0.YFCK1WmlcXCEvpFuQxShWjQemuulyBW1E4GSbrGfcic"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Client created successfully",
  "data": {
    "user": "6a783cf47331f97f716b9cf2",
    "clientName": "Wayne Enterprises",
    "businessName": "Wayne Corp",
    "emailAddress": "contact@wayne.com",
    "phoneNumber": "+1-555-0000",
    "billingAddress": {
      "streetAddress": "1007 Mountain Drive",
      "city": "Gotham",
      "state": "NJ",
      "zipCode": "07001",
      "country": "USA"
    },
    "createdAt": "2026-08-09T08:40:20.676Z",
    "updatedAt": "2026-08-09T08:40:20.676Z",
    "id": "6a783cf47331f97f716b9d46"
  }
}


2:40:20 PM | Invoice BDD Flow > STEP 4.3 — Update a client | stdout

📝 USER STORY:
As a user
I want to update client information
So that their details remain accurate

📖 BDD SCENARIO: 4.3. UPDATE CLIENT
Feature: Invoice Clients

Given I am an authenticated user
And I have an existing client
When I PATCH /api/v1/invoices/client/:clientId
Then I receive a 200 OK response

2:40:20 PM | Invoice BDD Flow > STEP 4.3 — Update a client | stdout


 PATCH   /api/v1/invoices/client/6a783cf47331f97f716b9d2c [BDD-04-3-UPDATE-CLIENT] - Update a client
 REQUEST 
{
  "params": {},
  "query": {},
  "body": {
    "clientName": "Acme Corporation Updated"
  },
  "headers": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhNzgzY2Y0NzMzMWY5N2Y3MTZiOWNmMiIsInJvbGUiOiJPV05FUiIsImVtYWlsIjoib3duZXJAdGVzdC5jb20iLCJpYXQiOjE3ODYyNjQ4MjAsImV4cCI6MTc4NjI2ODQyMH0.YFCK1WmlcXCEvpFuQxShWjQemuulyBW1E4GSbrGfcic"
  }
}
 RESPONSE SUCCESS 
{
  "success": true,
  "message": "Client updated successfully",
  "data": {
    "user": "6a783cf47331f97f716b9cf2",
    "clientName": "Acme Corporation Updated",
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
    "createdAt": "2026-08-09T08:40:20.566Z",
    "updatedAt": "2026-08-09T08:40:20.693Z",
    "id": "6a783cf47331f97f716b9d2c"
  }
}