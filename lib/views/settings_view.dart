import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/settings_controller.dart';
import '../controllers/login_controller.dart';
import '../app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (controller) {
        final now = DateTime.now();

        // Initialize amount controller with current value if empty
        if (controller.amountController.text.isEmpty) {
          controller.amountController.text = controller.perPersonAmount.toStringAsFixed(0);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: AppColors.white,
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => _showLogoutDialog(context),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Date Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM dd, yyyy').format(now),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE').format(now),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                AppColors.secondaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.settings_rounded,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Room Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Per Person Amount Card
                  _settingsCard(
                    title: 'Per Person Amount',
                    subtitle: controller.isCurrentUserAdmin()
                        ? 'Current: ₹${controller.perPersonAmount.toStringAsFixed(0)} | Set monthly room contribution'
                        : 'Monthly room contribution amount',
                    child: controller.isCurrentUserAdmin()
                        ? Column(
                            children: [
                              TextFormField(
                                controller: controller.amountController,
                                keyboardType: TextInputType.number,
                                enabled: controller.isCurrentUserAdmin(),
                                readOnly: !controller.isCurrentUserAdmin(),
                                decoration: _inputDecoration(
                                  label: 'Room Amount per Person',
                                  icon: Icons.currency_rupee_rounded,
                                ).copyWith(
                                  filled: controller.isCurrentUserAdmin(),
                                  fillColor: controller.isCurrentUserAdmin()
                                      ? Colors.grey.shade100
                                      : Colors.grey.shade200,
                                ),
                              ),
                              if (controller.isCurrentUserAdmin()) ...[
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () => controller.setPerPersonAmount(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondaryColor,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save Amount',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.secondaryColor.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.currency_rupee_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${controller.perPersonAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'per person per month',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Send Message Card
                  _settingsCard(
                    title: 'Send Message',
                    subtitle: 'Notify all room members',
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.messageController,
                          maxLines: 4,
                          decoration: _inputDecoration(
                            label: 'Enter your message',
                            icon: Icons.message_rounded,
                          ).copyWith(
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.sendMessage(context),
                            icon: const Icon(Icons.send_rounded, color: Colors.white,),
                            label: const Text('Send', style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.secondaryColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final loginController = Get.find<LoginController>();
                loginController.logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Reusable Card
  Widget _settingsCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // 🔹 Reusable Input Decoration
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.secondaryColor),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.secondaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}
