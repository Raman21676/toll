import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../services/user_service.dart';

class UserProfileScreen extends StatefulWidget {
  final String? userId;
  
  const UserProfileScreen({super.key, this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final StorageService _storageService = StorageService();
  final UserService _userService = UserService();
  bool _isUploadingImage = false;

  Future<void> _changeProfileImage() async {
    // Show image source bottom sheet
    final File? imageFile = await _storageService.showImageSourceBottomSheet(context);
    
    if (imageFile == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    
    if (currentUser == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    // Upload image
    final result = await _storageService.uploadProfileImage(
      imageFile: imageFile,
      userId: currentUser.uid,
    );

    if (result['success']) {
      // Update user profile with new image URL
      await _userService.updateUserProfile(
        uid: currentUser.uid,
        profileImageUrl: result['url'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to upload image'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }

    setState(() {
      _isUploadingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    final isOwnProfile = widget.userId == null || widget.userId == currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwnProfile ? 'My Profile' : 'Profile'),
        actions: [
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
            ),
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to settings
              },
            ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Profile header
                SliverToBoxAdapter(
                  child: _buildProfileHeader(currentUser, isOwnProfile),
                ),
                // Stats
                SliverToBoxAdapter(
                  child: _buildStats(currentUser),
                ),
                // Interests & Hobbies
                SliverToBoxAdapter(
                  child: _buildInterestsAndHobbies(currentUser),
                ),
                // Astrology info
                SliverToBoxAdapter(
                  child: _buildAstrologyInfo(currentUser),
                ),
                // Logout button (own profile only)
                if (isOwnProfile)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await authProvider.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.welcome,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(dynamic user, bool isOwnProfile) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile picture
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppTheme.primaryLight,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl)
                    : null,
                child: user.profileImageUrl == null
                    ? Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : _isUploadingImage
                        ? const CircularProgressIndicator(color: Colors.white)
                        : null,
              ),
              if (isOwnProfile && !_isUploadingImage)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeProfileImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Nickname
          Text(
            '@${user.nickname}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          // Location
          if (user.address != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  user.address,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStats(dynamic user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('Posts', '0'),
            _buildStatColumn('Friends', '0'),
            _buildStatColumn('Matches', '0'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsAndHobbies(dynamic user) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interests
          const Text(
            'Interests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.interests.map<Widget>((interest) {
              return Chip(
                label: Text(interest),
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Hobbies
          const Text(
            'Hobbies',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.hobbies.map<Widget>((hobby) {
              return Chip(
                label: Text(hobby),
                backgroundColor: AppTheme.accentGold.withValues(alpha: 0.1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologyInfo(dynamic user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Astrology Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user.kundaliId == null)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.birthDetails);
                    },
                    child: const Text('Create'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (user.kundaliId == null)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No Kundali yet',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.birthDetails);
                      },
                      child: const Text('Create Kundali'),
                    ),
                  ],
                ),
              )
            else
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primaryColor,
                  ),
                ),
                title: const Text('View Kundali'),
                subtitle: const Text('Your birth chart is ready'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.kundali);
                },
              ),
          ],
        ),
      ),
    );
  }
}
