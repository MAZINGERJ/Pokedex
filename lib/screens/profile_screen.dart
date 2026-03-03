import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildPhotoSection(context, profile),
                const SizedBox(height: 32),
                _buildNameSection(context, profile),
                const SizedBox(height: 32),
                _buildStatsCard(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context, ProfileProvider profile) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _showPhotoOptions(context, profile),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: profile.hasPhoto
                    ? Image.file(
                        File(profile.photoPath!),
                        fit: BoxFit.cover,
                        width: 140,
                        height: 140,
                      )
                    : Icon(
                        Icons.person,
                        size: 80,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => _showPhotoOptions(context, profile),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, ProfileProvider profile) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                profile.setPhotoFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                profile.setPhotoFromCamera();
              },
            ),
            if (profile.hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Eliminar foto', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  profile.removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection(BuildContext context, ProfileProvider profile) {
    return _NameEditor(profile: profile);
  }

  static Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Tu Pokédex',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, 'Favoritos', '0', Icons.favorite),
                _buildStatItem(context, 'Vistos', '0', Icons.visibility),
                _buildStatItem(context, 'Capturados', '0', Icons.pest_control),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NameEditor extends StatefulWidget {
  final ProfileProvider profile;

  const _NameEditor({required this.profile});

  @override
  State<_NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<_NameEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.profile.userName);
  }

  @override
  void didUpdateWidget(_NameEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.userName != widget.profile.userName &&
        _controller.text != widget.profile.userName) {
      _controller.text = widget.profile.userName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.badge, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Nombre de entrenador',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              onSubmitted: (value) => widget.profile.setUserName(value.trim()),
              onChanged: (value) => widget.profile.setUserName(value.trim()),
            ),
          ],
        ),
      ),
    );
  }
}
