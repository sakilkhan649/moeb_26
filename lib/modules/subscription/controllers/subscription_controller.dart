import 'package:get/get.dart';
import 'package:moeb_26/core/utils/helpers.dart';

class SubscriptionController extends GetxController {
  final RxString selectedPlan = 'yearly'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubscribed = false.obs;

  // Plan Details
  final String planName = 'Ekkali Premium';
  final String planPrice = '\$29';
  final String planPeriod = '/ Year';
  final String billingDescription =
      'Billed annually at \$29.00 USD (\$2.41/mo)';

  final List<Map<String, String>> features = [
    {
      'title': 'Priority Job Matching',
      'subtitle': 'First access to high-value client requests & premium rides',
      'icon': 'crown',
    },
    {
      'title': '0% Platform Commission',
      'subtitle': 'Keep 100% of your earnings on direct bookings & invoices',
      'icon': 'percent',
    },
    {
      'title': 'VIP Verified Badge',
      'subtitle': 'Exclusive golden partner badge displayed on profile',
      'icon': 'badge',
    },
    {
      'title': '24/7 VIP Concierge Support',
      'subtitle': 'Direct line to dedicated chauffeur assistance team',
      'icon': 'support',
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
      Helpers.showCustomSnackBar(
        'Welcome to Ekkali Premium!',
        isError: false,
      );
    } catch (e) {
      Helpers.showCustomSnackBar(
        'Failed to process subscription. Please try again.',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
