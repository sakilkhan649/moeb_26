import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:moeb_26/core/services/subscription_service.dart';

class SubscriptionController extends GetxController {
  late final SubscriptionService _subscriptionService;

  // ─── Delegates from SubscriptionService ─────────────────────────────────────
  RxBool get isPremium => _subscriptionService.isPremium;
  RxBool get isLoading => _subscriptionService.isLoading;
  RxBool get isAvailable => _subscriptionService.isAvailable;
  Rx<ProductDetails?> get yearlyProduct => _subscriptionService.yearlyProduct;

  // Keep isSubscribed as alias for backward compat with any older UI references
  RxBool get isSubscribed => _subscriptionService.isPremium;

  // ─── Plan Display Info ────────────────────────────────────────────────────────
  final String planName = 'Ekkali Premium';
  final String planPeriod = '/ Year';

  String get planPrice {
    final product = _subscriptionService.yearlyProduct.value;
    return product?.price ?? '\$89.99';
  }

  String get billingDescription {
    final product = _subscriptionService.yearlyProduct.value;
    if (product != null) {
      return 'Billed annually at ${product.price} (Less than \$7.50/mo)';
    }
    return 'Billed annually at \$89.99 USD (Less than \$7.50/mo)';
  }

  // ─── Feature List ─────────────────────────────────────────────────────────────
  final List<Map<String, String>> features = [
    {
      'title': 'Job Opportunities & Overflow',
      'subtitle': 'Access jobs posted by other chauffeurs and grow your business',
      'icon': 'job',
    },
    {
      'title': 'Preferred Chauffeur Network',
      'subtitle': 'Build your trusted network and connect with top chauffeurs',
      'icon': 'network',
    },
    {
      'title': 'Live State & Regional Chats',
      'subtitle': 'Communicate in real-time with chauffeurs in your area',
      'icon': 'chat',
    },
    {
      'title': 'Invoice Creator & Schedule',
      'subtitle': 'Manage private bookings and create professional invoices easily',
      'icon': 'invoice',
    },
    {
      'title': 'Meet & Greet Sign Creator',
      'subtitle': 'Create professional airport and client welcome signs',
      'icon': 'flight',
    },
    {
      'title': 'Marketplace – Buy & Sell',
      'subtitle': 'Buy and sell items or services related to your business',
      'icon': 'marketplace',
      'isNew': 'true',
    },
    {
      'title': 'Deals & Exclusive Offers',
      'subtitle': 'Access exclusive deals, discounts, and tools for chauffeurs',
      'icon': 'deals',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _subscriptionService = Get.find<SubscriptionService>();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────────

  /// Triggers the real in-app purchase flow
  Future<void> subscribe() async {
    await _subscriptionService.buySubscription();
  }

  /// Restores previously purchased subscriptions
  Future<void> restorePurchases() async {
    await _subscriptionService.restorePurchases();
  }

  /// Legacy plan selector (kept for UI compatibility)
  void selectPlan(String planId) {}
}
