class RideDetailsModel {
  final String posterName;
  final String rating;
  final String posterId;
  final String vehicleName;
  final String? avatarPath;

  RideDetailsModel({
    required this.posterName,
    required this.rating,
    required this.posterId,
    required this.vehicleName,
    this.avatarPath,
  });
}
