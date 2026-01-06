import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/entities.dart';

/// Unified profile sheet that works from any listing
/// Shows consistent statistical information regardless of where it's opened from
class UnifiedProfileSheet extends StatelessWidget {
  final String username;
  final bool? isFollower;
  final bool? isFollowing;
  final DateTime? timestamp;
  
  // Optional interaction data (statistics only)
  final int? likesCount;
  final int? commentsCount;
  final int? storyLikesCount;

  const UnifiedProfileSheet({
    super.key,
    required this.username,
    this.isFollower,
    this.isFollowing,
    this.timestamp,
    this.likesCount,
    this.commentsCount,
    this.storyLikesCount,
  });

  /// Create from InstagramProfile
  factory UnifiedProfileSheet.fromProfile({
    required InstagramProfile profile,
    bool? isFollower,
    bool? isFollowing,
    int? likesCount,
    int? commentsCount,
    int? storyLikesCount,
  }) {
    return UnifiedProfileSheet(
      username: profile.username,
      isFollower: isFollower,
      isFollowing: isFollowing,
      timestamp: profile.timestamp,
      likesCount: likesCount,
      commentsCount: commentsCount,
      storyLikesCount: storyLikesCount,
    );
  }

  /// Create from UserInteractionScore
  factory UnifiedProfileSheet.fromInteraction({
    required UserInteractionScore user,
    bool? isFollower,
    bool? isFollowing,
    DateTime? timestamp,
  }) {
    return UnifiedProfileSheet(
      username: user.username,
      isFollower: isFollower,
      isFollowing: isFollowing,
      timestamp: timestamp,
      likesCount: user.likesCount,
      commentsCount: user.commentsCount,
      storyLikesCount: user.storyLikesCount,
    );
  }

  bool get isMutual => isFollower == true && isFollowing == true;
  
  bool get hasInteractionData => 
      (likesCount ?? 0) > 0 || 
      (commentsCount ?? 0) > 0 || 
      (storyLikesCount ?? 0) > 0;

  int get totalScore => 
      (likesCount ?? 0) + ((commentsCount ?? 0) * 2) + (storyLikesCount ?? 0);

  Future<void> _openInstagram() async {
    final url = Uri.parse('https://www.instagram.com/$username');
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

          // Avatar
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
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Username
          Text(
            '@$username',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 8),

          // Relationship status badge
          _buildRelationshipBadge(context),

          const SizedBox(height: 24),

          // Statistics section
          if (hasInteractionData) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Tus interacciones',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          icon: Icons.favorite,
                          value: likesCount ?? 0,
                          label: 'Likes',
                          color: AppColors.error,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.border,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          icon: Icons.chat_bubble,
                          value: commentsCount ?? 0,
                          label: 'Comentarios',
                          color: AppColors.info,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.border,
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          icon: Icons.auto_awesome,
                          value: storyLikesCount ?? 0,
                          label: 'Stories',
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.insights, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Score total: $totalScore',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Date info section
          if (timestamp != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: _getTimestampLabel(),
                    value: DateFormatter.formatDateOnly(timestamp!),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time,
                    label: 'Hace',
                    value: DateFormatter.formatTimestampRelative(
                      timestamp!.millisecondsSinceEpoch ~/ 1000,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // No data message
          if (!hasInteractionData && timestamp == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No hay datos de interacción registrados con este usuario.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Primary action: Open in Instagram
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openInstagram,
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text('Ver en Instagram'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Secondary action: Close
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Cerrar'),
            ),
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
    } else if (isMutual) {
      return 'Mutuos desde';
    }
    return 'Fecha';
  }

  Widget _buildRelationshipBadge(BuildContext context) {
    String text;
    IconData icon;
    Color bgColor;

    if (isMutual) {
      text = 'Se siguen mutuamente';
      icon = Icons.people;
      bgColor = AppColors.success.withValues(alpha: 0.15);
    } else if (isFollower == true) {
      text = 'Te sigue';
      icon = Icons.person_add;
      bgColor = AppColors.info.withValues(alpha: 0.15);
    } else if (isFollowing == true) {
      text = 'No te sigue de vuelta';
      icon = Icons.person_remove;
      bgColor = AppColors.warning.withValues(alpha: 0.15);
    } else {
      text = 'Sin relación';
      icon = Icons.person_outline;
      bgColor = AppColors.surfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
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
        const SizedBox(width: 12),
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

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}

/// Helper function to show unified profile sheet from InstagramProfile
void showUnifiedProfileSheet(
  BuildContext context, {
  required InstagramProfile profile,
  bool? isFollower,
  bool? isFollowing,
  int? likesCount,
  int? commentsCount,
  int? storyLikesCount,
  UserInteractionDetails? details, // Kept for compatibility but not used
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => UnifiedProfileSheet.fromProfile(
      profile: profile,
      isFollower: isFollower,
      isFollowing: isFollowing,
      likesCount: likesCount ?? details?.likedPosts.length,
      commentsCount: commentsCount ?? details?.comments.length,
      storyLikesCount: storyLikesCount ?? details?.storyInteractions.length,
    ),
  );
}

/// Helper function to show unified profile sheet from UserInteractionScore
void showUnifiedProfileSheetFromInteraction(
  BuildContext context, {
  required UserInteractionScore user,
  bool? isFollower,
  bool? isFollowing,
  DateTime? timestamp,
  UserInteractionDetails? details, // Kept for compatibility but not used
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => UnifiedProfileSheet.fromInteraction(
      user: user,
      isFollower: isFollower,
      isFollowing: isFollowing,
      timestamp: timestamp,
    ),
  );
}
