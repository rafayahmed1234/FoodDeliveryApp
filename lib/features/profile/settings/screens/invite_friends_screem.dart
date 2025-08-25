import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  String? _referralCode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrGenerateReferralCode();
  }

  Future<void> _fetchOrGenerateReferralCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      final doc = await userDocRef.get();
      if (doc.exists && doc.data()!.containsKey('referralCode')) {
        _referralCode = doc.data()!['referralCode'];
      } else {
        _referralCode = 'COODY-${_generateRandomChars(6)}';
        await userDocRef.set({'referralCode': _referralCode}, SetOptions(merge: true));
      }
    } catch (e) {
      _referralCode = "Error";
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _generateRandomChars(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Invite your friends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Images/gift.png', height: 150),
              const SizedBox(height: 32),
              const Text(
                'Get \$20 for each invitation!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Share your referral code and invite your friends to join. They get a discount and you get a bonus!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 40),
              const Text('YOUR REFERRAL CODE', style: TextStyle(color: Colors.grey, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (_referralCode != null && !_isLoading) {
                    Clipboard.setData(ClipboardData(text: _referralCode!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral code copied to clipboard!')),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: _isLoading
                      ? const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2)))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _referralCode ?? 'No Code',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF3A4F6A)),
                      ),
                      const Icon(Icons.copy_outlined, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_referralCode != null && !_isLoading) {
                      final shareText = 'Hey! I\'m inviting you to join Coody. Use my referral code to get a discount on your first order!\n\nMy code is: $_referralCode';
                      Share.share(shareText);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3A938),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Share my code', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}