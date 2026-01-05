import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shababi_caffee/const.dart';
import 'package:shababi_caffee/services/apiService.dart';

class AddRemoveTeam extends StatefulWidget {
  static String id = "/ARTeam";
  const AddRemoveTeam({super.key});

  @override
  State<AddRemoveTeam> createState() => _AddRemoveTeamState();
}

class _AddRemoveTeamState extends State<AddRemoveTeam> {
  // Helper to refresh the list manually
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevents background squishing
        appBar: AppBar(
          backgroundColor: appColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "إدارة الـفـرق",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: appColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "إضـافـة فـريـق",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AddTeamDialog(onTeamAdded: _refreshData),
            );
          },
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.15, // Lowered opacity for better text readability
              image: AssetImage("assets/images/logo_robo.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            color: appColor,
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
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: teams.length,
                    separatorBuilder: (ctx, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return TeamCard(
                        teamData: teams[index],
                        onDelete: () => _refreshData(),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "حدث خطأ في الاتصال بالخادم",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "لا يـوجـد فـرق مـضـافـة حـالـيـاً",
            style: TextStyle(
                fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WIDGET 1: Team Card (Displays the individual team)
// ---------------------------------------------------------------------------
class TeamCard extends StatelessWidget {
  final Map teamData;
  final VoidCallback onDelete;

  const TeamCard({super.key, required this.teamData, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    // Helper to safely parse color
    Color teamColor = toColor(teamData['color']);

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          // Leading: Team Number inside a colored circle
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: teamColor.withOpacity(0.2),
            child: Text(
              teamData['ID']
                  .toString(), // Or team number if you have a separate field
              style: TextStyle(
                color: teamColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Title: Team Name
          title: Text(
            teamData['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          // Subtitle: Current Points
          subtitle: Text(
            "النقاط: ${teamData['points']}",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          // Trailing: Delete Action
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text("حـذف الـفـريـق"),
          content: Text("هل أنت متأكد من حذف فريق '${teamData['name']}'؟"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(ctx);
                await ApiService.deleteTeam(teamData['ID']);
                onDelete(); // Refresh list
              },
              child: const Text("حـذف", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WIDGET 2: Add Team Dialog (Handles Input Logic)
// ---------------------------------------------------------------------------
class AddTeamDialog extends StatefulWidget {
  final VoidCallback onTeamAdded;
  const AddTeamDialog({super.key, required this.onTeamAdded});

  @override
  State<AddTeamDialog> createState() => _AddTeamDialogState();
}

class _AddTeamDialogState extends State<AddTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Color _selectedColor = Colors.blue;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.app_registration, color: appColor),
            const SizedBox(width: 10),
            const Text("بيانات الفريق الجديد",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: _numberController,
                label: "رقم الفريق",
                icon: Icons.format_list_numbered,
                inputType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "الرجاء إدخال الرقم" : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _nameController,
                label: "اسم الفريق",
                icon: Icons.badge,
                inputType: TextInputType.text,
                validator: (val) => val!.isEmpty ? "الرجاء إدخال الاسم" : null,
              ),
              const SizedBox(height: 20),
              const Text("اختر لون الفريق",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickColor,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ]),
                  child: Center(
                    child: Text(
                      "اضغط لتغيير اللون",
                      style: TextStyle(
                        color: useWhiteForeground(_selectedColor)
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            ),
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Text("إضـافـة",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType inputType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: appColor),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: appColor, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اختر اللون"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() => _selectedColor = color);
              },
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("تم",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Generate clean Hex string without #
      String colorCode = _selectedColor.value.toRadixString(16).padLeft(8, '0');

      try {
        await ApiService.addTeam(
          _numberController.text,
          _nameController.text,
          colorCode,
        );
        if (mounted) {
          Navigator.pop(context); // Close dialog
          widget.onTeamAdded(); // Refresh parent list
        }
      } catch (e) {
        // Handle error (show snackbar ideally)
        debugPrint("Error adding team: $e");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
