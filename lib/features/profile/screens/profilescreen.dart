import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/profile/settings/screens/change_password_screen.dart';
import 'package:fooddeliveryapp/features/profile/settings/screens/delivery_locations_screen.dart';
import '../../auth/screens/login_screen.dart';
import '../settings/screens/faq_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/screens/account_information_screen.dart';
import '../settings/screens/invite_friends_screem.dart';
import '../settings/screens/payment_method_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showRateUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(child: Text('Enjoying Coody?')),
          content: const Text(
            'If you like our app, please take a moment to rate it on the App Store.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Maybe Later',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3A938),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Rate Now'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final bool? didRequestSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (didRequestSignOut == true) {
      try {
        await FirebaseAuth.instance.signOut();

        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: ${e.message}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/Images/person_profile.png"),
            ),
            const SizedBox(height: 12),
            const Text(
              'Philippe Troussier',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A4F6A),
              ),
            ),
            const SizedBox(height: 30),

            _buildSectionCard(
              title: 'General',
              children: [
                _buildListTile(
                  Icons.person_outline,
                  'Account Information',
                  'Change your account information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountInformationScreen(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  Icons.lock_outline,
                  'Password',
                  'Change your password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  Icons.payment_outlined,
                  'Payment Methods',
                  'Add your Credit & Debit cards',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodsScreen(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  Icons.location_on_outlined,
                  'Delivery Locations',
                  'Change your Delivery Locations',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeliveryLocationsScreen(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  Icons.people_outline,
                  'Invite your friends',
                  'Get \$20 for each invitation!',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InviteFriendsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSectionCard(
              title: 'Notifications',
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF3A4F6A),
                  ),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'You will receive daily updates.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: const Color(0xFFF3A938),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.campaign_outlined,
                    color: Color(0xFF3A4F6A),
                  ),
                  title: const Text(
                    'Promotional Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Get notified about new promotions.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSectionCard(
              title: 'More',
              children: [
                _buildListTile(
                  Icons.star_outline,
                  'Rate Us',
                  'You will receive daily updates.',
                  onTap: () {
                    _showRateUsDialog(context);
                  },
                ),
                _buildListTile(
                  Icons.help_outline,
                  'FAQ',
                  'Frequently Asked Questions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FaqScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildListTile(
                Icons.logout,
                'Log Out',
                '',
                isLogout: true,
                onTap: () {
                  _signOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: children,
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(
      IconData icon,
      String title,
      String subtitle, {
        VoidCallback? onTap,
        bool isLogout = false,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : const Color(0xFF3A4F6A),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isLogout ? Colors.red : null,
        ),
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: isLogout
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red)
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}