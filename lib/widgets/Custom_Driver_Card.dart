import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDriverCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String rating;
  final String? vehicleNumber;
  final String? vehicleInfo;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onButtonPressed;
  final bool showVehicleInfo;

  const CustomDriverCard({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.rating,
    this.vehicleNumber,
    this.vehicleInfo,
    required this.buttonText,
    required this.buttonIcon,
    required this.onButtonPressed,
    this.showVehicleInfo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: AssetImage(profileImage),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 20.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (vehicleNumber != null)
                Text(
                  vehicleNumber!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),

          // Vehicle Info Section
          if (showVehicleInfo && vehicleInfo != null) ...[
            SizedBox(height: 24.h),
            Row(
              children: [
                Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  vehicleInfo!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],

          // Button Section
          SizedBox(height: 24.h),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onButtonPressed,
        icon: Icon(
          buttonIcon,
          color: Colors.black,
          size: 20.sp,
        ),
        label: Text(
          buttonText,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}