import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/services/reviewed_profiles_service.dart';
import '../../domain/entities/entities.dart';
import 'unified_profile_sheet.dart';

class SwipeableProfileTile extends StatefulWidget {
  final InstagramProfile profile;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;
  final VoidCallback? onReviewed;
  final int? likesCount;
  final int? commentsCount;
  final int? storyLikesCount;
  final UserInteractionDetails? interactionDetails;

  const SwipeableProfileTile({
    super.key,
    required this.profile,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
    this.onReviewed,
    this.likesCount,
    this.commentsCount,
    this.storyLikesCount,
    this.interactionDetails,
  });

  @override
  State<SwipeableProfileTile> createState() => _SwipeableProfileTileState();
}

class _SwipeableProfileTileState extends State<SwipeableProfileTile> {
  final _reviewedService = sl<ReviewedProfilesService>();

  bool get _isReviewed => _reviewedService.isReviewed(widget.profile.username);

  void _toggleReviewed() {
    if (_isReviewed) {
      _reviewedService.unmarkAsReviewed(widget.profile.username);
    } else {
      _reviewedService.markAsReviewed(widget.profile.username);
    }
    setState(() {}); // Trigger rebuild
    widget.onReviewed?.call();
  }

  void _showDetail(BuildContext context) {
    showUnifiedProfileSheet(
      context,
      profile: widget.profile,
      isFollower: widget.isFollower,
      isFollowing: widget.isFollowing,
      likesCount: widget.likesCount,
      commentsCount: widget.commentsCount,
      storyLikesCount: widget.storyLikesCount,
      details: widget.interactionDetails,
    );
  }

  Future<void> _openInstagram() async {
    final url = Uri.parse('https://www.instagram.com/${widget.profile.username}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.profile.username),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        _toggleReviewed();
        return false; // Don't actually dismiss, just toggle state
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: _isReviewed ? AppColors.textSecondary : AppColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              _isReviewed ? Icons.remove_done : Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _isReviewed ? 'Desmarcar' : 'Revisado',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _isReviewed 
              ? AppColors.surfaceVariant
              : Colors.transparent,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: _buildAvatar(),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  '@${widget.profile.username}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isReviewed) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
          subtitle: _buildSubtitle(context),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: InkWell(
              onTap: _openInstagram,
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
          onTap: () => _showDetail(context),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    // Simple gray border, or primary border if reviewed
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _isReviewed ? AppColors.primary : AppColors.border,
          width: _isReviewed ? 2 : 1,
        ),
        color: AppColors.surfaceVariant,
      ),
      child: Center(
        child: _isReviewed
            ? Icon(
                Icons.check,
                color: AppColors.primary,
                size: 20,
              )
            : Text(
                widget.profile.username.isNotEmpty
                    ? widget.profile.username[0].toUpperCase()
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
    if (widget.profile.timestamp != null) {
      return Text(
        DateFormatter.formatTimestampRelative(
          widget.profile.timestamp!.millisecondsSinceEpoch ~/ 1000,
        ),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      );
    }
    return null;
  }

}
