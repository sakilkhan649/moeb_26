# Ekkali Subscription Setup Information

This document contains all details, product IDs, pricing, names, and localization configurations required for setting up the **Ekkali Premium Yearly Subscription** on both Apple App Store Connect and Google Play Console, as well as in the Flutter app code.

---

## 📌 Subscription Overview

| Property | Value |
| :--- | :--- |
| **Subscription Plan Name** | Ekkali Premium / Annual Membership |
| **Billing Cycle** | 1 Year (Annual / Yearly) |
| **Price (USD)** | **$89.99 / Year** |
| **Monthly Equivalent** | Less than $7.50 / month |
| **Unified Product ID** | `ekkali_premium_yearly` |

---

## 🍏 1. Apple App Store Connect Setup

| Setting / Field | Configured Value |
| :--- | :--- |
| **Subscription Group** | `Ekkali Premium Subscriptions` |
| **Reference Name** | `Ekkali Premium Yearly` |
| **Product ID** | `ekkali_premium_yearly` |
| **Subscription Duration** | `1 Year` |
| **Subscription Price** | `$89.99` (Tier / USD) |
| **Localization Language** | `English (U.S.)` |
| **Localization Display Name** | `Ekkali Annual Membership` *(max 35 chars)* |
| **Localization Description** | `Unlock job opportunities, live chats & chauffeur tools.` *(max 55 chars)* |

---

## 🤖 2. Google Play Console Setup

| Setting / Field | Configured Value |
| :--- | :--- |
| **Subscription ID** | `ekkali_premium_yearly` |
| **Name** | `Ekkali Premium` |
| **Base Plan ID** | `yearly-plan` |
| **Renewal Type** | Auto-renewing |
| **Billing Period** | `1 Year` |
| **Price** | `$89.99` (USD, Tax Included) |
| **Status** | Active |

---

## 💻 3. Flutter App Code Reference

In your Flutter app (using `in_app_purchase` package), use the following constant Product ID:

```dart
class SubscriptionConstants {
  static const String yearlyProductId = 'ekkali_premium_yearly';
  static const Set<String> productIds = {yearlyProductId};
}
```

---

*Document generated on: September 1, 2026*
