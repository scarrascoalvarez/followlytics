import 'package:flutter/material.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/services/reviewed_profiles_service.dart';
import '../../domain/entities/instagram_profile.dart';
import 'profile_detail_sheet.dart';

class SwipeableProfileTile extends StatefulWidget {
  final InstagramProfile profile;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;
  final VoidCallback? onReviewed;

  const SwipeableProfileTile({
    super.key,
    required this.profile,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
    this.onReviewed,
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
    showProfileDetailSheet(
      context,
      profile: widget.profile,
      isFollower: widget.isFollower,
      isFollowing: widget.isFollowing,
      isMutual: widget.isMutual,
    );
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
        color: _isReviewed ? AppColors.warning : AppColors.success,
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
              ? AppColors.success.withValues(alpha: 0.08)
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
                  color: AppColors.success,
                ),
              ],
            ],
          ),
          subtitle: _buildSubtitle(context),
          onTap: () => _showDetail(context),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _isReviewed
            ? LinearGradient(
                colors: [
                  AppColors.success.withValues(alpha: 0.5),
                  AppColors.success.withValues(alpha: 0.3),
                ],
              )
            : AppColors.instagramGradient,
      ),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isReviewed ? AppColors.surface : AppColors.surface,
          ),
          child: Center(
            child: _isReviewed
                ? Icon(
                    Icons.check,
                    color: AppColors.success,
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

