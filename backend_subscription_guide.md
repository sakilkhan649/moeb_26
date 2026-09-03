# 📘 Backend Subscription Integration Guide
**Project:** Ekkali App  
**Prepared for:** Backend Developer  
**Last Updated:** September 2026

---

## 📌 Table of Contents
1. [Overview & Architecture](#overview)
2. [Credentials](#credentials)
3. [API Endpoints](#api-endpoints)
   - [1. Verify Apple Receipt (iOS)](#1-verify-apple-receipt-ios)
   - [2. Verify Google Play Purchase (Android)](#2-verify-google-play-purchase-android)
   - [3. Restore Purchases](#3-restore-purchases)
   - [4. Get Subscription Status](#4-get-subscription-status)
   - [5. Apple Webhook (Server Notifications)](#5-apple-webhook-server-notifications)
4. [Database Schema](#database-schema)
5. [Apple Verification – Step by Step](#apple-verification--step-by-step)
6. [Google Play Verification – Step by Step](#google-play-verification--step-by-step)
7. [Apple Status Codes Reference](#apple-status-codes-reference)
8. [Security Checklist](#security-checklist)
9. [Testing Guide](#testing-guide)

---

## Overview

### How It Works

```
Flutter App (iOS/Android)
        │
        │ User completes purchase via App Store / Play Store
        │
        ▼
Backend API  (this server)
        │
        │ Sends receipt/token to Apple or Google for verification
        │
        ▼
Apple (itunes.apple.com/verifyReceipt)
Google (androidpublisher.googleapis.com)
        │
        │ Returns: is valid? expires when?
        │
        ▼
Backend saves subscription to DB
        │
        ▼
Returns { isPremium: true/false, expiresAt: "..." } to Flutter app
```

### Key Facts
- **Product ID (both stores):** `ekkali_premium_yearly`
- **Plan:** Yearly subscription (auto-renewing)
- **Price:** $89.99 USD / year
- **Base URL:** `https://nayem5001.binarybards.online/api/v1`
- All endpoints require existing **JWT Bearer token** authentication (same auth system already in the app)

---

## Credentials

> ⚠️ **IMPORTANT:** Keep these credentials strictly on the server. Never expose them in any client app or public repository.

### Apple / iOS Credentials

| Field | Value |
|-------|-------|
| **App-Specific Shared Secret** | `d80a9f618b89421caa13ca23b2c8c996` |
| **Issuer ID** | `f9ed49c4-524c-4933-867e-beff6c0e005d` |
| **Key ID** | `6GCW7YAAQC` |
| **Team ID** | `L2S8P8TC9Z` |
| **Private Key File** | `SubscriptionKey_6GCW7YAAQC.p8` |
| **Bundle ID** | Check `ios/Runner/Info.plist` → `CFBundleIdentifier` |

> The `.p8` private key file is located in the `ios/` folder of the project. Store it securely on the server (e.g., environment variable or secret manager).

### Google Play / Android Credentials

| Field | Value |
|-------|-------|
| **Project ID** | `ekkali-ed609` |
| **Service Account Email** | `play-store-subscriptions@ekkali-ed609.iam.gserviceaccount.com` |
| **Key ID** | `4a62cb55db39201314c64a96fb3ba667dbe21176` |
| **Package Name (Application ID)** | `com.moeb26.app` |
| **Service Account Key File** | `google-service-account.json` (located in project root) |

> ⚠️ **IMPORTANT:** The `google-service-account.json` file must be kept securely on your backend server. Do not commit it to public repositories or expose it to client apps.

---

## API Endpoints

All endpoints:
- **Base URL:** `https://nayem5001.binarybards.online/api/v1`
- **Authentication:** `Authorization: Bearer <user_jwt_token>` (user must be logged in)
- **Content-Type:** `application/json`

---

### 1. Verify Apple Receipt (iOS)

**`POST /subscriptions/verify-apple`**

Called immediately after a successful iOS purchase. The Flutter app sends the device receipt to your server, which then validates it with Apple.

#### Request Headers
```
Authorization: Bearer <user_jwt_token>
Content-Type: application/json
```

#### Request Body
```json
{
  "receipt": "MIIUKgYJKoZIhvcNAQcCoIIU..."
}
```
> `receipt` is a Base64-encoded string — Apple's receipt data retrieved from the device.

#### What Your Server Must Do

**Step 1:** Send the receipt to Apple's verification server.

> **Important Rule:** Always try **Production** first. If Apple returns `status: 21007`, retry with **Sandbox**. This handles TestFlight builds automatically.

```
POST https://buy.itunes.apple.com/verifyReceipt
Content-Type: application/json

{
  "receipt-data": "<receipt from Flutter app>",
  "password": "d80a9f618b89421caa13ca23b2c8c996",
  "exclude-old-transactions": true
}
```

**Step 2:** Check Apple's response:
- `status == 0` → Receipt is valid ✅
- Any other status → Invalid (see [Apple Status Codes](#apple-status-codes-reference))

**Step 3:** Find the subscription transaction in `latest_receipt_info` array:
```json
{
  "latest_receipt_info": [
    {
      "product_id": "ekkali_premium_yearly",
      "transaction_id": "1000000987654321",
      "original_transaction_id": "1000000123456789",
      "expires_date": "2027-09-01 12:00:00 Etc/GMT",
      "expires_date_ms": "1756728000000",
      "is_trial_period": "false"
    }
  ]
}
```

**Step 4:** Check if `expires_date_ms > Date.now()` → subscription is active

**Step 5:** Save or update the subscription record in your database

**Step 6:** Return response to Flutter app

#### Success Response (HTTP 200)
```json
{
  "success": true,
  "message": "Subscription verified successfully",
  "data": {
    "isPremium": true,
    "expiresAt": "2027-09-01T12:00:00.000Z",
    "productId": "ekkali_premium_yearly",
    "platform": "ios",
    "transactionId": "1000000987654321"
  }
}
```

#### Failure Response (HTTP 200 with success: false)
```json
{
  "success": false,
  "message": "Receipt validation failed. Subscription may be expired or invalid."
}
```

---

### 2. Verify Google Play Purchase (Android)

**`POST /subscriptions/verify-google`**

Called after a successful Android purchase. The Flutter app sends the purchase token to your server.

#### Request Headers
```
Authorization: Bearer <user_jwt_token>
Content-Type: application/json
```

#### Request Body
```json
{
  "purchaseToken": "oiefhbak.AO-J1OxnF3zO...",
  "productId": "ekkali_premium_yearly",
  "orderId": "GPA.1234-5678-9012-34567"
}
```

#### What Your Server Must Do

**Step 1:** Call the Google Play Developer API using a Service Account:
```
GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{purchaseToken}
```
- Replace `{packageName}` with your Android app's package name (`com.moeb26.app`)
- Replace `{purchaseToken}` with the token from the request body

**Step 2:** Check the response:
```json
{
  "subscriptionState": "SUBSCRIPTION_STATE_ACTIVE",
  "lineItems": [
    {
      "productId": "ekkali_premium_yearly",
      "expiryTime": "2027-09-01T12:00:00.000Z"
    }
  ]
}
```
- `subscriptionState == "SUBSCRIPTION_STATE_ACTIVE"` → Active ✅
- `subscriptionState == "SUBSCRIPTION_STATE_EXPIRED"` → Expired ❌

**Step 3:** Acknowledge the purchase (required within 3 days or Google will refund):
```
POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{purchaseToken}:acknowledge
```

**Step 4:** Save subscription to DB and return response

#### Success Response (HTTP 200)
```json
{
  "success": true,
  "message": "Subscription verified successfully",
  "data": {
    "isPremium": true,
    "expiresAt": "2027-09-01T12:00:00.000Z",
    "productId": "ekkali_premium_yearly",
    "platform": "android",
    "orderId": "GPA.1234-5678-9012-34567"
  }
}
```

---

### 3. Restore Purchases

**`POST /subscriptions/restore`**

Called when the user taps "Restore Purchases". Look up their existing subscription record in your DB and return its current status.

#### Request Headers
```
Authorization: Bearer <user_jwt_token>
Content-Type: application/json
```

#### Request Body
```json
{}
```
*(Empty body — the user is identified from the JWT token)*

#### What Your Server Must Do

1. Extract `user_id` from the JWT token
2. Query the `subscriptions` table for that user
3. If a record exists AND `expires_at > NOW()` → they are still premium
4. Optionally: re-validate with Apple/Google if `expires_at` is within the next 7 days
5. Return the current status

#### Success Response – Active Subscription (HTTP 200)
```json
{
  "success": true,
  "message": "Subscription restored successfully",
  "data": {
    "isPremium": true,
    "expiresAt": "2027-09-01T12:00:00.000Z",
    "platform": "ios",
    "productId": "ekkali_premium_yearly"
  }
}
```

#### Success Response – No Active Subscription (HTTP 200)
```json
{
  "success": true,
  "message": "No active subscription found",
  "data": {
    "isPremium": false
  }
}
```

---

### 4. Get Subscription Status

**`GET /subscriptions/status`**

Called on every app launch (background, non-blocking). Returns the user's current subscription status from your DB.

#### Request Headers
```
Authorization: Bearer <user_jwt_token>
```

#### What Your Server Must Do

1. Extract `user_id` from JWT
2. Query `subscriptions` table for that user
3. Check `is_active == true` AND `expires_at > NOW()`
4. Return status

#### Response – Premium User (HTTP 200)
```json
{
  "success": true,
  "data": {
    "isPremium": true,
    "expiresAt": "2027-09-01T12:00:00.000Z",
    "platform": "ios",
    "productId": "ekkali_premium_yearly"
  }
}
```

#### Response – Free User (HTTP 200)
```json
{
  "success": true,
  "data": {
    "isPremium": false
  }
}
```

---

### 5. Apple Webhook (Server Notifications)

**`POST /subscriptions/apple-webhook`**

> This endpoint is optional but **strongly recommended**. Apple calls this automatically when a subscription renews, expires, or is refunded — keeping your DB always in sync even when the user doesn't open the app.

**Setup:** In App Store Connect → Your App → App Information → App Store Server Notifications:
```
https://your-production-domain.com/api/v1/subscriptions/apple-webhook
```

#### Apple Will Send Events Like:
```json
{
  "notificationType": "DID_RENEW",
  "subtype": "INITIAL_BUY",
  "data": {
    "signedTransactionInfo": "...",
    "signedRenewalInfo": "..."
  }
}
```

#### Key Notification Types to Handle:
| Type | Action |
|------|--------|
| `SUBSCRIBED` | New subscription – set `is_active = true` |
| `DID_RENEW` | Auto-renewed – update `expires_at` |
| `EXPIRED` | Expired – set `is_active = false` |
| `DID_FAIL_TO_RENEW` | Payment failed – optionally notify user |
| `REFUND` | Refunded – set `is_active = false` |
| `GRACE_PERIOD_EXPIRED` | Grace period over – set `is_active = false` |

> For webhook validation, decode the JWS (JSON Web Signature) payload using Apple's public key. Use a library like `node-jsonwebtoken` (Node.js) or `PyJWT` (Python).

---

## Database Schema

```sql
-- Subscriptions table
CREATE TABLE subscriptions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform              VARCHAR(10) NOT NULL CHECK (platform IN ('ios', 'android')),
  product_id            VARCHAR(100) NOT NULL DEFAULT 'ekkali_premium_yearly',
  
  -- iOS fields
  original_transaction_id  VARCHAR(255),     -- Apple's original_transaction_id (use this as unique identifier for renewals)
  receipt_data             TEXT,              -- Optional: store latest receipt for re-validation
  
  -- Android fields
  purchase_token           TEXT,              -- Google's purchaseToken
  order_id                 VARCHAR(255),      -- Google's orderId
  
  -- Status
  is_active                BOOLEAN DEFAULT TRUE,
  expires_at               TIMESTAMP WITH TIME ZONE NOT NULL,
  
  -- Metadata
  created_at               TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at               TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for fast lookup
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_expires_at ON subscriptions(expires_at);
CREATE UNIQUE INDEX idx_subscriptions_original_txn ON subscriptions(original_transaction_id) 
  WHERE original_transaction_id IS NOT NULL;

-- Auto-update the updated_at field
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

> **Note for iOS renewals:** Apple uses the same `original_transaction_id` for all renewals of the same subscription. Use `INSERT ... ON CONFLICT (original_transaction_id) DO UPDATE` to handle renewals correctly without creating duplicate rows.

---

## Apple Verification – Step by Step

Here is a complete Node.js pseudocode example:

```javascript
async function verifyAppleReceipt(receiptData, userId) {
  // Step 1: Try Production first
  let appleResponse = await fetch('https://buy.itunes.apple.com/verifyReceipt', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      'receipt-data': receiptData,
      'password': 'd80a9f618b89421caa13ca23b2c8c996',
      'exclude-old-transactions': true
    })
  });
  let appleData = await appleResponse.json();

  // Step 2: If status 21007, retry with Sandbox (TestFlight / sandbox testers)
  if (appleData.status === 21007) {
    appleResponse = await fetch('https://sandbox.itunes.apple.com/verifyReceipt', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        'receipt-data': receiptData,
        'password': 'd80a9f618b89421caa13ca23b2c8c996',
        'exclude-old-transactions': true
      })
    });
    appleData = await appleResponse.json();
  }

  // Step 3: Check if valid
  if (appleData.status !== 0) {
    throw new Error(`Apple receipt invalid. Status: ${appleData.status}`);
  }

  // Step 4: Find the latest active subscription transaction
  const transactions = appleData.latest_receipt_info || [];
  const sorted = transactions
    .filter(t => t.product_id === 'ekkali_premium_yearly')
    .sort((a, b) => Number(b.expires_date_ms) - Number(a.expires_date_ms));

  if (sorted.length === 0) {
    throw new Error('No subscription transaction found');
  }

  const latest = sorted[0];
  const expiresAt = new Date(Number(latest.expires_date_ms));
  const isPremium = expiresAt > new Date();

  // Step 5: Save to database
  await db.subscriptions.upsert({
    where: { original_transaction_id: latest.original_transaction_id },
    update: { expires_at: expiresAt, is_active: isPremium, updated_at: new Date() },
    create: {
      user_id: userId,
      platform: 'ios',
      product_id: latest.product_id,
      original_transaction_id: latest.original_transaction_id,
      is_active: isPremium,
      expires_at: expiresAt
    }
  });

  return { isPremium, expiresAt };
}
```

---

## Google Play Verification – Step by Step

```javascript
async function verifyGooglePurchase(purchaseToken, productId, orderId, userId) {
  // Step 1: Get Google OAuth2 access token using Service Account
  const authClient = new google.auth.GoogleAuth({
    keyFile: './google-service-account.json',   // Your service account JSON
    scopes: ['https://www.googleapis.com/auth/androidpublisher']
  });
  const token = await authClient.getAccessToken();

  // Step 2: Call Google Play API
  const packageName = 'com.moeb26.app'; // your Android package name
  const url = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/subscriptionsv2/tokens/${purchaseToken}`;
  
  const response = await fetch(url, {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  const purchaseData = await response.json();

  // Step 3: Check subscription state
  if (purchaseData.subscriptionState !== 'SUBSCRIPTION_STATE_ACTIVE') {
    throw new Error(`Subscription not active. State: ${purchaseData.subscriptionState}`);
  }

  // Step 4: Get expiry from lineItems
  const lineItem = purchaseData.lineItems?.find(i => i.productId === 'ekkali_premium_yearly');
  const expiresAt = new Date(lineItem.expiryTime);

  // Step 5: Acknowledge the purchase (REQUIRED – must do within 3 days)
  await fetch(`${url}:acknowledge`, {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${token}` }
  });

  // Step 6: Save to database
  await db.subscriptions.upsert({
    where: { purchase_token: purchaseToken },
    update: { expires_at: expiresAt, is_active: true, updated_at: new Date() },
    create: {
      user_id: userId,
      platform: 'android',
      product_id: productId,
      purchase_token: purchaseToken,
      order_id: orderId,
      is_active: true,
      expires_at: expiresAt
    }
  });

  return { isPremium: true, expiresAt };
}
```

---

## Apple Status Codes Reference

| Status Code | Meaning | Action |
|-------------|---------|--------|
| `0` | ✅ Valid receipt | Proceed normally |
| `21000` | JSON malformed | Check request body |
| `21002` | Receipt data malformed | Bad receipt from app |
| `21003` | Receipt not authenticated | Invalid receipt |
| `21004` | Shared secret mismatch | ⚠️ Check `password` field – use `d80a9f618b89421caa13ca23b2c8c996` |
| `21005` | Receipt server unavailable | Retry later |
| `21006` | Subscription expired | Return `isPremium: false` |
| `21007` | Sandbox receipt sent to Production | Retry with Sandbox URL |
| `21008` | Production receipt sent to Sandbox | Retry with Production URL |
| `21010` | User account not found | Invalid receipt |

---

## Security Checklist

- [ ] **Shared Secret** is stored as environment variable, never in code
- [ ] **`.p8` key file** is stored in secret manager (e.g., AWS Secrets Manager, Vault), not in repository
- [ ] All endpoints require valid JWT token – extract `user_id` from it, never from request body
- [ ] Receipt/token verification is done **server-side only** – never trust the client's claim of being premium
- [ ] Webhook endpoint validates the JWS signature from Apple before processing
- [ ] Log all purchase events for audit trail (transaction ID, user ID, timestamp, status)
- [ ] HTTPS only – no HTTP

---

## Testing Guide

### iOS Sandbox Testing

1. **Create Sandbox Tester:** App Store Connect → Users & Access → Sandbox → Testers → Add Tester (use a fresh email)
2. **On iPhone:** Settings → App Store → Sign Out → Sign in with sandbox email
3. **Make a test purchase** in the app → It will show "Environment: Sandbox" in receipt
4. **Your server** will receive receipt with `status: 21007` on Production URL → retry Sandbox URL → should return `status: 0`
5. Sandbox subscriptions expire much faster (yearly = 5 minutes in sandbox for testing)

### Android Testing (when credentials available)

1. Add tester email in Google Play Console → License Testing
2. Publish app to Internal Testing track
3. Test purchase with the tester account → No real charge

### Testing the API directly (using curl)

```bash
# Get subscription status
curl -X GET https://nayem5001.binarybards.online/api/v1/subscriptions/status \
  -H "Authorization: Bearer <your_jwt_token>"

# Restore purchases
curl -X POST https://nayem5001.binarybards.online/api/v1/subscriptions/restore \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{}'
```

---

*Questions? Contact the Flutter developer.*
