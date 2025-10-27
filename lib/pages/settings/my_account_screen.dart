import 'package:flutter/material.dart';
import 'package:dejurebook/services/auth_service.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'package:dejurebook/models/user_profile.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await ProfileService.getCurrentUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAccountItem(
                        'Name',
                        _userProfile?.fullName ?? 'Not provided',
                      ),
                      _buildAccountItem(
                        'Email',
                        AuthService.currentUser?.email ?? 'Not provided',
                      ),
                      _buildAccountItem(
                        'Phone',
                        AuthService.currentUser?.userMetadata?['phone'] ??
                            'Not provided',
                      ),
                      _buildAccountItem(
                        'Profession',
                        _userProfile?.profession ?? 'Not specified',
                      ),
                      _buildAccountItem(
                        'User Type',
                        _getUserTypeDisplayName(_userProfile?.userType),
                      ),
                      _buildAccountItem(
                        'Member Since',
                        _userProfile?.createdAt != null
                            ? '${_userProfile!.createdAt!.month}/${_userProfile!.createdAt!.year}'
                            : 'Not available',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Signed in as ${AuthService.currentUser?.email ?? 'Unknown'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Version 0.0.1',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAccountItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getUserTypeDisplayName(String? userType) {
    if (userType == null) return 'Not specified';
    switch (userType) {
      case 'consumer':
        return 'Consumer';
      case 'lawyer':
        return 'Lawyer';
      case 'law_student':
        return 'Law Student';
      default:
        return userType;
    }
  }
}
