import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/entities.dart';
import 'instagram_button.dart';

class ProfileDetailSheet extends StatelessWidget {
  final InstagramProfile profile;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;

  const ProfileDetailSheet({
    super.key,
    required this.profile,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
  });

  Future<void> _openInstagram() async {
    final url = Uri.parse(profile.profileUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),

          // Avatar - simple gray border
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2),
              color: AppColors.surfaceVariant,
            ),
            child: Center(
              child: Text(
                profile.username.isNotEmpty
                    ? profile.username[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Username with Instagram button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text(
            '@${profile.username}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _openInstagram,
                icon: const Icon(Icons.open_in_new, size: 20),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Relationship status
          if (isMutual != null || isFollower != null || isFollowing != null)
            _buildRelationshipBadge(context),

          const SizedBox(height: 20),

          // Info cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (profile.timestamp != null) ...[
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: _getTimestampLabel(),
                    value: DateFormatter.formatDateOnly(profile.timestamp!),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time,
                    label: 'Hace',
                    value: DateFormatter.formatTimestampRelative(
                      profile.timestamp!.millisecondsSinceEpoch ~/ 1000,
                    ),
                  ),
                ],
                if (profile.timestamp == null)
                  _buildInfoRow(
                    context,
                    icon: Icons.info_outline,
                    label: 'Información',
                    value: 'Sin fecha disponible',
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions
          InstagramButton(
            text: 'Cerrar',
            isOutlined: true,
            onPressed: () => Navigator.pop(context),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  String _getTimestampLabel() {
    if (isFollower == true && isFollowing != true) {
      return 'Te sigue desde';
    } else if (isFollowing == true && isFollower != true) {
      return 'Le sigues desde';
    } else if (isMutual == true) {
      return 'Mutuos desde';
    }
    return 'Fecha';
  }

  Widget _buildRelationshipBadge(BuildContext context) {
    String text;
    IconData icon;

    if (isMutual == true) {
      text = 'Se siguen mutuamente';
      icon = Icons.people;
    } else if (isFollower == true) {
      text = 'Te sigue';
      icon = Icons.person_add;
    } else if (isFollowing == true) {
      text = 'No te sigue de vuelta';
      icon = Icons.person_remove;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

// Helper function to show profile sheet
void showProfileDetailSheet(
  BuildContext context, {
  required InstagramProfile profile,
  bool? isFollower,
  bool? isFollowing,
  bool? isMutual,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ProfileDetailSheet(
      profile: profile,
      isFollower: isFollower,
      isFollowing: isFollowing,
      isMutual: isMutual,
    ),
  );
}

