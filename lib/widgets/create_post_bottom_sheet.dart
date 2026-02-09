import 'package:flutter/material.dart';

class CreatePostBottomSheet extends StatelessWidget {
  const CreatePostBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.blue),
              ),
              title: const Text('Create Post'),
              subtitle: const Text('Share your thoughts with the community'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to create post screen
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.video_camera_back, color: Colors.purple),
              ),
              title: const Text('Upload Reel'),
              subtitle: const Text('Share a short video'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to create reel screen
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.orange),
              ),
              title: const Text('Generate Kundali'),
              subtitle: const Text('Create your birth chart'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to birth details screen
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
