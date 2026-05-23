import 'package:flutter/material.dart';
import '../../core/component/conests.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/cache_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kDividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: kPrimaryColor.withOpacity(0.1),
                        child: const Text(
                          'AM',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: kPrimaryColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/edit-profile');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Abdelrahman Ibrahim',
                    style: TextStyle(
                      color: kDarkColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'abdelrahman@gmail.com',
                    style: TextStyle(color: kGreyColor, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: kDividerColor, height: 1),
                  const SizedBox(height: 16),
                  // Simple dashboard counters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCounterItem('Orders', '24'),
                      _buildCounterItem('Coupons', '3'),
                      _buildCounterItem('Wishlist', '15'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Settings Section
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Account Settings',
                  style: TextStyle(
                    color: kDarkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Settings Card list
            Container(
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kDividerColor),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    Icons.person_pin_rounded,
                    'Personal Details',
                    'Edit account details & info',
                    kPrimaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  const Divider(color: kDividerColor, height: 1),
                  _buildSettingTile(
                    Icons.history_edu_rounded,
                    'Order History',
                    'View and track all past orders',
                    Colors.orange,
                  ),
                  const Divider(color: kDividerColor, height: 1),
                  _buildSettingTile(
                    Icons.location_on_rounded,
                    'Shipping Addresses',
                    'Manage your primary delivery locations',
                    Colors.teal,
                  ),
                  const Divider(color: kDividerColor, height: 1),
                  _buildSettingTile(
                    Icons.payment_rounded,
                    'Payment Methods',
                    'Linked cards and digital wallets',
                    Colors.purple,
                  ),
                  const Divider(color: kDividerColor, height: 1),
                  _buildSettingTile(
                    Icons.notifications_active_rounded,
                    'Notifications',
                    'Push alerts and preferences',
                    Colors.red,
                  ),
                  const Divider(color: kDividerColor, height: 1),
                  _buildSettingTile(
                    Icons.logout_rounded,
                    'Sign Out',
                    'Safely log out of your session',
                    kGreyColor,
                    onTap: () {
                      CacheHelper.removeData(key: AppConstants.tokenKey).then((value) {
                        if (value) {
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: kGreyColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    void Function()? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kDarkColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: kGreyColor, fontSize: 11),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: kGreyColor,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
