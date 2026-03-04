import 'package:dio/dio.dart';
import '../Ripositoryes/user_profile_repository.dart';

class UserProfileService {
  final UserProfileRepo userProfileRepo;

  UserProfileService({required this.userProfileRepo});

  Future<Response> getUserProfile() {
    return userProfileRepo.getUserProfile();
  }

  Future<Response> patchProfile(Map<String, dynamic> body) {
    return userProfileRepo.patchProfile(body);
  }
}
