import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/services/reviewed_profiles_service.dart';
import '../../domain/entities/entities.dart';
import 'unified_profile_sheet.dart';

/// A collapsible section that displays reviewed/archived profiles
/// Similar to Instagram's archived posts behavior
class ReviewedSection extends StatefulWidget {
  final List<InstagramProfile> reviewedProfiles;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;
  final VoidCallback? onProfileUnreviewed;
  final Map<String, UserInteractionDetails>? userDetails;
  final Map<String, UserInteractionScore>? userScores;

  const ReviewedSection({
    super.key,
    required this.reviewedProfiles,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
    this.onProfileUnreviewed,
    this.userDetails,
    this.userScores,
  });

  @override
  State<ReviewedSection> createState() => _ReviewedSectionState();
}

class _ReviewedSectionState extends State<ReviewedSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reviewedProfiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Collapsible header
        InkWell(
          onTap: _toggleExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(
                bottom: BorderSide(
                  color: _isExpanded ? AppColors.border : Colors.transparent,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revisados',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '${widget.reviewedProfiles.length} ${widget.reviewedProfiles.length == 1 ? 'perfil' : 'perfiles'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable list
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            color: AppColors.surfaceVariant.withValues(alpha: 0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hint to unarchive
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swipe_left,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Desliza a la izquierda para quitar de revisados',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
                // List of reviewed profiles
                ...widget.reviewedProfiles.map((profile) {
                  final usernameLower = profile.username.toLowerCase();
                  final userScore = widget.userScores?[usernameLower];
                  final userDetails = widget.userDetails?[usernameLower];
                  return _ReviewedProfileTile(
                    profile: profile,
                    isFollower: widget.isFollower,
                    isFollowing: widget.isFollowing,
                    isMutual: widget.isMutual,
                    likesCount: userScore?.likesCount,
                    commentsCount: userScore?.commentsCount,
                    storyLikesCount: userScore?.storyLikesCount,
                    interactionDetails: userDetails,
                    onUnreviewed: () {
                      widget.onProfileUnreviewed?.call();
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // Separator after section
        if (widget.reviewedProfiles.isNotEmpty)
          Container(
            height: 8,
            color: AppColors.background,
          ),
      ],
    );
  }
}

/// A profile tile specifically for the reviewed section
/// Swipe action is reversed: swipe to UNreview/unarchive
class _ReviewedProfileTile extends StatefulWidget {
  final InstagramProfile profile;
  final bool? isFollower;
  final bool? isFollowing;
  final bool? isMutual;
  final VoidCallback? onUnreviewed;
  final int? likesCount;
  final int? commentsCount;
  final int? storyLikesCount;
  final UserInteractionDetails? interactionDetails;

  const _ReviewedProfileTile({
    required this.profile,
    this.isFollower,
    this.isFollowing,
    this.isMutual,
    this.onUnreviewed,
    this.likesCount,
    this.commentsCount,
    this.storyLikesCount,
    this.interactionDetails,
  });

  @override
  State<_ReviewedProfileTile> createState() => _ReviewedProfileTileState();
}

class _ReviewedProfileTileState extends State<_ReviewedProfileTile> {
  final _reviewedService = sl<ReviewedProfilesService>();

  void _unmarkReviewed() {
    _reviewedService.unmarkAsReviewed(widget.profile.username);
    widget.onUnreviewed?.call();
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
      key: Key('reviewed_${widget.profile.username}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        _unmarkReviewed();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.warning,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.unarchive_outlined,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Restaurar',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        leading: _buildAvatar(),
        title: Text(
          '@${widget.profile.username}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _buildSubtitle(context),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: InkWell(
            onTap: _openInstagram,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.open_in_new, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Ver',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () => _showDetail(context),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        color: AppColors.surface,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: AppColors.primary.withValues(alpha: 0.7),
          size: 18,
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
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
      );
    }
    return null;
  }
}

