import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final RxString selectedPlan = 'yearly'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubscribed = false.obs;

  // Plan Details
  final String planName = 'Ekkali Premium';
  final String planPrice = '\$89.99';
  final String planPeriod = '/ Year';
  final String billingDescription =
      'Billed annually at \$89.99 USD (Less than \$7.50/mo)';

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

  void selectPlan(String planId) {
    selectedPlan.value = planId;
  }

  Future<void> subscribe() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isSubscribed.value = true;
      Get.snackbar(
        'Success',
        'Welcome to Ekkali Premium!',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process subscription. Please try again.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
