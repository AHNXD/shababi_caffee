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
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
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
              opacity: 0.05,
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
// UPDATED TEAM CARD (StatefulWidget)
// -----------------------------------------------------------------------------

class TeamControlCard extends StatefulWidget {
  final Map teamData;
  final VoidCallback onUpdate;

  const TeamControlCard({
    super.key,
    required this.teamData,
    required this.onUpdate,
  });

  @override
  State<TeamControlCard> createState() => _TeamControlCardState();
}

class _TeamControlCardState extends State<TeamControlCard> {
  // State to hold the slider value (1 to 25)
  double _selectedValue = 5.0;

  @override
  Widget build(BuildContext context) {
    Color teamColor = toColor(widget.teamData['color']);
    String teamId = widget.teamData['ID'].toString();
    int currentPoints = int.tryParse(widget.teamData['points'].toString()) ?? 0;

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          children: [
            // --- 1. Header: Name & Score ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.teamData['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: teamColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "فريق ${widget.teamData['ID']}",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: teamColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "$currentPoints",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: teamColor,
                          height: 1.0,
                        ),
                      ),
                      Text("نقطة",
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Divider(height: 1, color: Colors.grey.shade200),
            ),

            // --- 2. The Value Selector (Slider) ---
            Column(
              children: [
                // Label showing selected value
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("قيمة التغيير:",
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.grey.shade600)),
                    SizedBox(width: 8.w),
                    Text(
                      "${_selectedValue.toInt()}",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Slider Row with Buttons
                Row(
                  children: [
                    // Minus Button (Fine tune)
                    _buildCircleBtn(Icons.remove, () {
                      setState(() {
                        if (_selectedValue > 1) _selectedValue--;
                      });
                    }),

                    // The Slider
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: teamColor,
                          inactiveTrackColor: teamColor.withOpacity(0.15),
                          thumbColor: teamColor,
                          overlayColor: teamColor.withOpacity(0.1),
                          trackHeight: 6.h,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10.r),
                        ),
                        child: Slider(
                          value: _selectedValue,
                          min: 1,
                          max: 25,
                          divisions: 24, // Snaps to integers
                          label: _selectedValue.toInt().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _selectedValue = value;
                            });
                          },
                        ),
                      ),
                    ),

                    // Plus Button (Fine tune)
                    _buildCircleBtn(Icons.add, () {
                      setState(() {
                        if (_selectedValue < 25) _selectedValue++;
                      });
                    }),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // --- 3. Action Buttons (Add / Remove) ---
            Row(
              children: [
                // REMOVE BUTTON (Red)
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: "خصم",
                    value: _selectedValue.toInt(),
                    color: Colors.red.shade400,
                    icon: Icons.remove_circle_outline,
                    onTap: () => _handlePointsUpdate(
                        context, teamId, 'sub', _selectedValue.toInt()),
                  ),
                ),

                SizedBox(width: 16.w),

                // ADD BUTTON (Green)
                Expanded(
                  child: _buildActionButton(
                    context,
                    label: "إضافة",
                    value: _selectedValue.toInt(),
                    color: Colors.green,
                    icon: Icons.add_circle_outline,
                    isFilled: true,
                    onTap: () => _handlePointsUpdate(
                        context, teamId, 'add', _selectedValue.toInt()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 36.w,
          height: 36.w,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.grey.shade700, size: 20.sp),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required int value,
      required Color color,
      required IconData icon,
      required VoidCallback onTap,
      bool isFilled = false}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFilled ? color : Colors.white,
        foregroundColor: isFilled ? Colors.white : color,
        elevation: isFilled ? 4 : 0,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        side: isFilled ? null : BorderSide(color: color, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            "$label $value", // "Add 5" or "Remove 5"
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePointsUpdate(
      BuildContext context, String teamId, String type, int value) async {
    // 1. Call API
    await ApiService.editTeam(teamId, value, type);

    // 2. Refresh UI (Parent)
    widget.onUpdate();

    // 3. Show Feedback
    bool isAdd = type == 'add';
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        isAdd ? "تم إضافة $value نقاط بنجاح" : "تم خصم $value نقاط بنجاح",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
      backgroundColor: isAdd ? Colors.green : Colors.red.shade400,
      duration: const Duration(milliseconds: 800),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(20.w),
    ));
  }
}
