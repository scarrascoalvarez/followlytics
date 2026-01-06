import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/instagram_profile.dart';
import 'unified_profile_sheet.dart';

class ProfileTile extends StatelessWidget {
  final InstagramProfile profile;
  final Widget? trailing;
  final String? subtitle;
  final bool showDate;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;
  final int? likesCount;
  final int? commentsCount;
  final int? storyLikesCount;

  const ProfileTile({
    super.key,
    required this.profile,
    this.trailing,
    this.subtitle,
    this.showDate = true,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
    this.likesCount,
    this.commentsCount,
    this.storyLikesCount,
  });

  void _showDetail(BuildContext context) {
    showUnifiedProfileSheet(
      context,
      profile: profile,
      isFollower: isFollower,
      isFollowing: isFollowing,
      likesCount: likesCount,
      commentsCount: commentsCount,
      storyLikesCount: storyLikesCount,
    );
  }

  Future<void> _openInstagram() async {
    final url = Uri.parse('https://www.instagram.com/${profile.username}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: _buildAvatar(),
      title: Text(
        '@${profile.username}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: _buildSubtitle(context),
      trailing: trailing ?? _buildInstagramButton(),
      onTap: () => _showDetail(context),
    );
  }

  Widget _buildAvatar() {
    // Simple gray border instead of colorful gradient
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
        color: AppColors.surfaceVariant,
      ),
      child: Center(
        child: Text(
          profile.username.isNotEmpty 
              ? profile.username[0].toUpperCase() 
              : '?',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (subtitle != null) {
      return Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }
    if (showDate && profile.timestamp != null) {
      return Text(
        DateFormatter.formatTimestampRelative(
          profile.timestamp!.millisecondsSinceEpoch ~/ 1000,
        ),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }
    return null;
  }

  Widget _buildInstagramButton() {
    return GestureDetector(
      onTap: _openInstagram,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              'Ver',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InteractionProfileTile extends StatelessWidget {
  final String username;
  final int likesCount;
  final int commentsCount;
  final int storyLikesCount;
  final int totalScore;
  final bool? isFollower;
  final bool? isFollowing;
  final VoidCallback? onTap;

  const InteractionProfileTile({
    super.key,
    required this.username,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.storyLikesCount = 0,
    required this.totalScore,
    this.isFollower,
    this.isFollowing,
    this.onTap,
  });

  Future<void> _openInstagram() async {
    final url = Uri.parse('https://www.instagram.com/$username');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: _buildAvatar(),
      title: Text(
        '@$username',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: _buildStats(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScore(context),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _openInstagram,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Ver',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildAvatar() {
    // Simple gray border instead of colorful gradient
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
        color: AppColors.surfaceVariant,
      ),
      child: Center(
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final stats = <String>[];
    if (likesCount > 0) stats.add('$likesCount likes');
    if (commentsCount > 0) stats.add('$commentsCount comments');
    if (storyLikesCount > 0) stats.add('$storyLikesCount stories');
    
    return Text(
      stats.join(' · '),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildScore(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$totalScore',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
