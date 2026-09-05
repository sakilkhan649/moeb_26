import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:moeb_26/config/constants/storage_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';
import 'package:moeb_26/core/services/storege_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/repositories/subscription_repository.dart';

/// Product IDs – must match exactly what is set in App Store Connect & Google Play
class SubscriptionProductIds {
  static const String yearlyPremium = 'ekkali_premium_yearly';
  static const Set<String> all = {yearlyPremium};
}

class SubscriptionService extends GetxService {
  late final SubscriptionRepo _repo;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  // ─── Observable State ───────────────────────────────────────────────────────
  final RxBool isPremium = false.obs;
  final RxBool isAvailable = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<ProductDetails?> yearlyProduct = Rx<ProductDetails?>(null);
  final RxString subscriptionExpiry = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = SubscriptionRepo(apiClient: Get.find<ApiClient>());
    _initService();
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }

  // ─── Initialization ──────────────────────────────────────────────────────────
  Future<void> _initService() async {
    // 1. Load cached premium status first so UI is instant
    await _loadCachedStatus();

    // 2. Check if store is available
    isAvailable.value = await _iap.isAvailable();
    if (!isAvailable.value) {
      debugPrint('[SubscriptionService] Store not available.');
      return;
    }

    // 3. iOS: enable pending transactions
    if (Platform.isIOS) {
      final iosPlatformAddition = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // 4. Listen to purchase updates
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _purchaseSubscription = purchaseUpdated.listen(
      _onPurchaseUpdated,
      onDone: () => _purchaseSubscription?.cancel(),
      onError: (Object e) {
        debugPrint('[SubscriptionService] Purchase stream error: $e');
      },
    );

    // 5. Load products from store
    await loadProducts();

    // 6. Sync status with backend (non-blocking)
    _syncStatusWithBackend();
  }

  /// Load previously cached premium status from SharedPreferences
  Future<void> _loadCachedStatus() async {
    final cached = (await StorageService.getBool(StorageConstants.isPremium)) ?? false;
    isPremium.value = cached;
    final expiry =
        await StorageService.getString(StorageConstants.subscriptionExpiry);
    if (expiry.isNotEmpty) {
      subscriptionExpiry.value = expiry;
      // Auto-expire if past expiry date
      try {
        final expiryDate = DateTime.parse(expiry);
        if (DateTime.now().isAfter(expiryDate)) {
          await _setNotPremium();
        }
      } catch (_) {}
    }
  }

  /// Fetch product details from the stores
  Future<void> loadProducts() async {
    try {
      if (!isAvailable.value) {
        isAvailable.value = await _iap.isAvailable();
      }
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        SubscriptionProductIds.all,
      );
      if (response.error != null) {
        debugPrint('[SubscriptionService] Product query error: ${response.error}');
        return;
      }
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint(
          '[SubscriptionService] Warning: Product IDs not found in Store: ${response.notFoundIDs}. Make sure "ekkali_premium_yearly" is created & active in Play Console / App Store Connect.',
        );
      }
      if (response.productDetails.isNotEmpty) {
        yearlyProduct.value = response.productDetails.firstWhere(
          (p) => p.id == SubscriptionProductIds.yearlyPremium,
          orElse: () => response.productDetails.first,
        );
        debugPrint('[SubscriptionService] Product loaded: ${yearlyProduct.value?.title} (${yearlyProduct.value?.price})');
      }
    } catch (e) {
      debugPrint('[SubscriptionService] loadProducts error: $e');
    }
  }

  // ─── Purchase Flow ──────────────────────────────────────────────────────────

  /// Call this when user taps "Subscribe Now"
  Future<void> buySubscription() async {
    if (!isAvailable.value) {
      isAvailable.value = await _iap.isAvailable();
      if (!isAvailable.value) {
        Helpers.showCustomSnackBar(
          'Store is not available on this device.',
          isError: true,
        );
        return;
      }
    }

    if (yearlyProduct.value == null) {
      isLoading.value = true;
      await loadProducts();
      isLoading.value = false;
    }

    final product = yearlyProduct.value;
    if (product == null) {
      Helpers.showCustomSnackBar(
        'Product not found in Store (ID: ekkali_premium_yearly).',
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      // Result handled in _onPurchaseUpdated
    } catch (e) {
      isLoading.value = false;
      debugPrint('[SubscriptionService] buySubscription error: $e');
      Helpers.showCustomSnackBar(
        '$e',
        isError: true,
      );
    }
  }

  /// Call this when user taps "Restore Purchases"
  Future<void> restorePurchases() async {
    if (!isAvailable.value) return;
    isLoading.value = true;
    try {
      await _iap.restorePurchases();
      // Result handled in _onPurchaseUpdated
    } catch (e) {
      isLoading.value = false;
      debugPrint('[SubscriptionService] restorePurchases error: $e');
      Helpers.showCustomSnackBar(
        '$e',
        isError: true,
      );
    }
  }

  // ─── Purchase Stream Handler ─────────────────────────────────────────────────

  Future<void> _onPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails details in purchaseDetailsList) {
      debugPrint(
        '[SubscriptionService] Purchase update: ${details.productID} | ${details.status}',
      );

      if (details.status == PurchaseStatus.pending) {
        // No action needed – waiting for user to confirm (e.g., Ask to Buy)
        continue;
      }

      if (details.status == PurchaseStatus.error) {
        isLoading.value = false;
        final errMsg = details.error?.message ?? 'Purchase error';
        // Don't show error for user cancellation
        if (details.error?.code != 'storekit_duplicate_product_object') {
          Helpers.showCustomSnackBar(errMsg, isError: true);
        }
        await _iap.completePurchase(details);
        continue;
      }

      if (details.status == PurchaseStatus.canceled) {
        isLoading.value = false;
        await _iap.completePurchase(details);
        continue;
      }

      if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        // Verify with backend
        final verified = await _verifyWithBackend(details);
        if (verified) {
          await _setIsPremium(details);
          if (details.status == PurchaseStatus.purchased) {
            Helpers.showCustomSnackBar(
              'Welcome to Ekkali Premium! 🎉',
              isError: false,
            );
          } else {
            Helpers.showCustomSnackBar(
              'Purchase restored successfully!',
              isError: false,
            );
          }
        } else {
          Helpers.showCustomSnackBar(
            'Purchase verification failed. Contact support.',
            isError: true,
          );
        }
        isLoading.value = false;
        await _iap.completePurchase(details);
      }
    }
  }

  // ─── Backend Verification ────────────────────────────────────────────────────

  /// Returns true if purchase is valid (either backend verified OR fallback local trust)
  Future<bool> _verifyWithBackend(PurchaseDetails details) async {
    try {
      if (Platform.isIOS) {
        // iOS: send receipt data to backend
        final receiptData = await SKReceiptManager.retrieveReceiptData();
        if (receiptData.isEmpty) {
          debugPrint('[SubscriptionService] No iOS receipt data available');
          // Fallback: trust StoreKit (purchase came from Apple's servers)
          return true;
        }
        final response =
            await _repo.verifyAppleReceipt(receiptData: receiptData);
        final data = response.data;
        if (data is Map && data['success'] == true) {
          // Save expiry from backend if available
          final expiry = data['data']?['expiresAt'] as String?;
          if (expiry != null) {
            await StorageService.setString(
                StorageConstants.subscriptionExpiry, expiry);
            subscriptionExpiry.value = expiry;
          }
          return true;
        }
        // If backend unreachable/500 → trust Apple's StoreKit confirmation
        return true;
      } else if (Platform.isAndroid) {
        // Android: send purchase token to backend
        final androidDetails = details.verificationData;
        final response = await _repo.verifyGooglePurchase(
          purchaseToken: androidDetails.serverVerificationData,
          productId: details.productID,
          orderId: details.purchaseID ?? '',
        );
        final data = response.data;
        if (data is Map && data['success'] == true) {
          final expiry = data['data']?['expiresAt'] as String?;
          if (expiry != null) {
            await StorageService.setString(
                StorageConstants.subscriptionExpiry, expiry);
            subscriptionExpiry.value = expiry;
          }
          return true;
        }
        // Fallback for Android too
        return true;
      }
    } catch (e) {
      debugPrint('[SubscriptionService] Backend verification error: $e');
      // Network error → fallback: trust the store
      return true;
    }
    return false;
  }

  /// Sync subscription status from backend on app start (non-blocking)
  Future<void> _syncStatusWithBackend() async {
    try {
      final response = await _repo.getSubscriptionStatus();
      final data = response.data;
      if (data is Map && data['success'] == true) {
        final isPrem = data['data']?['isPremium'] as bool? ?? false;
        final expiry = data['data']?['expiresAt'] as String?;
        await StorageService.setBool(StorageConstants.isPremium, isPrem);
        isPremium.value = isPrem;
        if (expiry != null) {
          await StorageService.setString(
              StorageConstants.subscriptionExpiry, expiry);
          subscriptionExpiry.value = expiry;
        }
      }
    } catch (e) {
      // Backend not available – keep cached status
      debugPrint('[SubscriptionService] Status sync error (using cached): $e');
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Future<void> _setIsPremium(PurchaseDetails details) async {
    await StorageService.setBool(StorageConstants.isPremium, true);
    isPremium.value = true;
  }

  Future<void> _setNotPremium() async {
    await StorageService.setBool(StorageConstants.isPremium, false);
    await StorageService.remove(StorageConstants.subscriptionExpiry);
    isPremium.value = false;
    subscriptionExpiry.value = '';
  }
}

/// iOS StoreKit delegate – required for iOS 14+ to handle payment queue
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() => false;
}
