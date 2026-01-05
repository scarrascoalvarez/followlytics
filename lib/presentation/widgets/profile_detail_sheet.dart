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

          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.instagramGradient,
            ),
            child: Center(
              child: Container(
                width: 74,
                height: 74,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
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
            ),
          ),

          const SizedBox(height: 16),

          // Username
          Text(
            '@${profile.username}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
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
            text: 'Abrir en Instagram',
            icon: Icons.open_in_new,
            onPressed: () {
              Navigator.pop(context);
              _openInstagram();
            },
          ),

          const SizedBox(height: 12),

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
    Color color;
    IconData icon;

    if (isMutual == true) {
      text = 'Se siguen mutuamente';
      color = AppColors.info;
      icon = Icons.people;
    } else if (isFollower == true) {
      text = 'Te sigue';
      color = AppColors.success;
      icon = Icons.person_add;
    } else if (isFollowing == true) {
      text = 'No te sigue de vuelta';
      color = AppColors.warning;
      icon = Icons.person_remove;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
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

class InteractionDetailSheet extends StatelessWidget {
  final UserInteractionScore user;
  final bool? isFollower;
  final bool? isFollowing;

  const InteractionDetailSheet({
    super.key,
    required this.user,
    this.isFollower,
    this.isFollowing,
  });

  Future<void> _openInstagram() async {
    final url = Uri.parse('https://www.instagram.com/${user.username}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMutual = isFollower == true && isFollowing == true;

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
              gradient: AppColors.instagramGradient,
            ),
            child: Center(
              child: Container(
                width: 74,
                height: 74,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                ),
                child: Center(
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Username
          Text(
            '@${user.username}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 8),

          // Relationship badge
          _buildRelationshipBadge(context, isMutual),

          const SizedBox(height: 20),

          // Interaction stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tus interacciones con esta cuenta',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  context,
                  icon: Icons.favorite,
                  label: 'Likes a sus posts',
                  value: user.likesCount,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: 'Comentarios en sus posts',
                  value: user.commentsCount,
                  color: AppColors.info,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  icon: Icons.auto_awesome,
                  label: 'Likes a sus stories',
                  value: user.storyLikesCount,
                  color: AppColors.warning,
                ),
                const Divider(height: 24),
                _buildStatRow(
                  context,
                  icon: Icons.insights,
                  label: 'Score total',
                  value: user.totalScore,
                  color: AppColors.primary,
                  isTotal: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Insight
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _getInsightText(isMutual),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions
          InstagramButton(
            text: 'Abrir en Instagram',
            icon: Icons.open_in_new,
            onPressed: () {
              Navigator.pop(context);
              _openInstagram();
            },
          ),

          const SizedBox(height: 12),

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

  String _getInsightText(bool isMutual) {
    if (user.totalScore > 100) {
      if (isMutual) {
        return 'Interactúas mucho con esta cuenta. ¡Parece que os lleváis bien!';
      } else if (isFollowing == true && isFollower != true) {
        return 'Interactúas mucho pero no te sigue de vuelta. ¿Quizás deberías reconsiderar?';
      }
      return 'Esta es una de las cuentas con las que más interactúas.';
    }
    return 'Basado en tus likes, comentarios y reacciones a stories.';
  }

  Widget _buildRelationshipBadge(BuildContext context, bool isMutual) {
    String text;
    Color color;
    IconData icon;

    if (isMutual) {
      text = 'Se siguen mutuamente';
      color = AppColors.info;
      icon = Icons.people;
    } else if (isFollower == true) {
      text = 'Te sigue';
      color = AppColors.success;
      icon = Icons.person_add;
    } else if (isFollowing == true) {
      text = 'No te sigue de vuelta';
      color = AppColors.warning;
      icon = Icons.person_remove;
    } else {
      text = 'Sin relación de seguimiento';
      color = AppColors.textTertiary;
      icon = Icons.person_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: isTotal ? FontWeight.w600 : null,
                ),
          ),
        ),
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isTotal ? color : AppColors.textPrimary,
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

// Helper function to show interaction sheet
void showInteractionDetailSheet(
  BuildContext context, {
  required UserInteractionScore user,
  bool? isFollower,
  bool? isFollowing,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => InteractionDetailSheet(
      user: user,
      isFollower: isFollower,
      isFollowing: isFollowing,
    ),
  );
}

