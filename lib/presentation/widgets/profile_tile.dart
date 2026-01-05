import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/instagram_profile.dart';
import 'profile_detail_sheet.dart';

class ProfileTile extends StatelessWidget {
  final InstagramProfile profile;
  final Widget? trailing;
  final String? subtitle;
  final bool showDate;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;

  const ProfileTile({
    super.key,
    required this.profile,
    this.trailing,
    this.subtitle,
    this.showDate = true,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
  });

  void _showDetail(BuildContext context) {
    showProfileDetailSheet(
      context,
      profile: profile,
      isFollower: isFollower,
      isFollowing: isFollowing,
      isMutual: isMutual,
    );
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
      trailing: trailing ?? _buildDetailButton(),
      onTap: () => _showDetail(context),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.instagramGradient,
      ),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (subtitle != null) {
      return Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    if (showDate && profile.timestamp != null) {
      return Text(
        DateFormatter.formatTimestampRelative(
          profile.timestamp!.millisecondsSinceEpoch ~/ 1000,
        ),
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return null;
  }

  Widget _buildDetailButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Ver',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
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
      trailing: _buildScore(context),
      onTap: onTap,
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.instagramGradient,
      ),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
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
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildScore(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$totalScore',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

