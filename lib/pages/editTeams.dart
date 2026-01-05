// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/services/apiService.dart';

class EditTeamsPage extends StatefulWidget {
  static String id = "/edit";
  const EditTeamsPage({super.key});

  @override
  State<EditTeamsPage> createState() => _EditTeamsPageState();
}

class _EditTeamsPageState extends State<EditTeamsPage> {
  // Method to refresh the list
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Soft background
        appBar: AppBar(
          backgroundColor: appColor,
          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
          ),
          title: Text(
            "لوحة تحكم النقاط",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.1, // Subtler opacity for better readability
              image: AssetImage("assets/images/logo_robo.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: RefreshIndicator(
            color: appColor,
            onRefresh: _refreshData,
            child: FutureBuilder(
              future: ApiService.getTeams(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: appColor));
                }

                if (snapshot.hasData && snapshot.data['status'] == "success") {
                  var teams = snapshot.data['teams'];

                  if (teams.isEmpty) {
                    return Center(
                        child: Text("لا توجد فرق مضافة",
                            style: TextStyle(fontSize: 18.sp)));
                  }

                  return ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    itemCount: teams.length,
                    separatorBuilder: (ctx, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      return TeamControlCard(
                        teamData: teams[index],
                        onUpdate: _refreshData,
                      );
                    },
                  );
                }

                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 50.sp, color: Colors.grey),
                      SizedBox(height: 10.h),
                      const Text("فشل في تحميل البيانات"),
                      TextButton(
                        onPressed: _refreshData,
                        child: Text("أعد المحاولة",
                            style: TextStyle(color: appColor)),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SEPARATE WIDGET FOR CLEANER CODE
// -----------------------------------------------------------------------------

class TeamControlCard extends StatelessWidget {
  final Map teamData;
  final VoidCallback onUpdate;

  const TeamControlCard({
    super.key,
    required this.teamData,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Helper to get color safely
    Color teamColor = toColor(teamData['color']);
    String teamId = teamData['ID'].toString();

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border(
              right: BorderSide(
                  color: teamColor, width: 6.w)), // Colored accent strip
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // --- Header: Name and Current Score ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamData['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "الفريق رقم ${teamData['ID']}",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: teamColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    "${teamData['points']} ⭐️",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      color: teamColor, // Text matches team color
                    ),
                  ),
                ),
              ],
            ),

            Divider(height: 24.h, thickness: 1),

            // --- Action Buttons (Add) ---
            _buildActionRow(context, teamId, 'add', Colors.green, "إضافة نقاط"),

            SizedBox(height: 12.h),

            // --- Action Buttons (Subtract) ---
            _buildActionRow(context, teamId, 'sub', Colors.red, "خصم نقاط"),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, String teamId, String type,
      Color color, String label) {
    final List<int> values = [5, 10, 15, 20];
    bool isAdd = type == 'add';

    return Row(
      children: [
        // Label Icon
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), shape: BoxShape.circle),
          child:
              Icon(isAdd ? Icons.add : Icons.remove, color: color, size: 20.sp),
        ),
        SizedBox(width: 10.w),

        // Buttons
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: values.map((val) {
              return InkWell(
                onTap: () async {
                  // Show loading or optimistic update could go here
                  await ApiService.editTeam(teamId, val, type);

                  // Optional: Show feedback
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      isAdd
                          ? "تم إضافة $val نقاط لـ ${teamData['name']}"
                          : "تم خصم $val نقاط من ${teamData['name']}",
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: color,
                    duration: const Duration(milliseconds: 700),
                    behavior: SnackBarBehavior.floating,
                  ));

                  onUpdate(); // Refresh parent
                },
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  width: 55.w,
                  height: 35.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border:
                          Border.all(color: color.withOpacity(0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: color.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ]),
                  child: Text(
                    "$val",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
