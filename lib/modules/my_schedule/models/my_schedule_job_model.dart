class MyScheduleJobModel {
  final String id;
  final String clientName;
  final String clientPhone;
  final DateTime pickupDateTime;
  final String pickupLocation;
  final String dropoffLocation;
  final String vehicleType; // e.g. Sedan, SUV, Executive
  final String fare;
  final String notes;
  bool isDispatchedToNetwork;
  String status; // e.g. "Scheduled", "Dispatched", "Completed", "Cancelled"

  MyScheduleJobModel({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.pickupDateTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.vehicleType,
    this.fare = "",
    this.notes = "",
    this.isDispatchedToNetwork = false,
    this.status = "Scheduled",
  });

  MyScheduleJobModel copyWith({
    String? id,
    String? clientName,
    String? clientPhone,
    DateTime? pickupDateTime,
    String? pickupLocation,
    String? dropoffLocation,
    String? vehicleType,
    String? fare,
    String? notes,
    bool? isDispatchedToNetwork,
    String? status,
  }) {
    return MyScheduleJobModel(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      vehicleType: vehicleType ?? this.vehicleType,
      fare: fare ?? this.fare,
      notes: notes ?? this.notes,
      isDispatchedToNetwork:
          isDispatchedToNetwork ?? this.isDispatchedToNetwork,
      status: status ?? this.status,
    );
  }
}
