import 'package:get/get.dart';
import '../../../../Services/user_profile_service.dart';

class LegalContentController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();

  var isLoading = false.obs;
  var title = "".obs;
  var content = "".obs;
  var slug = "".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['slug'] != null) {
      slug.value = args['slug'];
      fetchLegalContent(slug.value);
    }
  }

  Future<void> fetchLegalContent(String slug) async {
    isLoading.value = true;
    try {
      var response = await _profileService.getLegalBySlug(slug);
      if (response.statusCode == 200) {
        var data = response.data['data'];
        title.value = data['title'] ?? "";
        content.value = data['content'] ?? "";
      }
    } catch (e) {
      print("Error fetching legal content: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
