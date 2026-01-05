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

class InteractionDetailSheet extends StatefulWidget {
  final UserInteractionScore user;
  final UserInteractionDetails? details;
  final bool? isFollower;
  final bool? isFollowing;

  const InteractionDetailSheet({
    super.key,
    required this.user,
    this.details,
    this.isFollower,
    this.isFollowing,
  });

  @override
  State<InteractionDetailSheet> createState() => _InteractionDetailSheetState();
}

class _InteractionDetailSheetState extends State<InteractionDetailSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openInstagram() async {
    final url = Uri.parse('https://www.instagram.com/${widget.user.username}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openPost(String? postUrl) async {
    if (postUrl == null) return;
    final url = Uri.parse(postUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMutual = widget.isFollower == true && widget.isFollowing == true;
    final hasDetails = widget.details != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
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

                const SizedBox(height: 20),

                // Avatar and username row
                Row(
                  children: [
          Container(
                      width: 56,
                      height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.instagramGradient,
            ),
            child: Center(
              child: Container(
                          width: 52,
                          height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                ),
                child: Center(
                  child: Text(
                              widget.user.username.isNotEmpty
                                  ? widget.user.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                                fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
          Text(
                            '@${widget.user.username}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
                          const SizedBox(height: 4),
          _buildRelationshipBadge(context, isMutual),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _openInstagram,
                      icon: const Icon(Icons.open_in_new),
                      color: AppColors.primary,
                    ),
                  ],
                ),

          const SizedBox(height: 20),

                // Stats row
          Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                      _buildStatBadge(
                  context,
                  icon: Icons.favorite,
                        value: widget.user.likesCount,
                        label: 'Likes',
                  color: AppColors.error,
                ),
                      _buildStatBadge(
                  context,
                        icon: Icons.chat_bubble,
                        value: widget.user.commentsCount,
                        label: 'Comentarios',
                  color: AppColors.info,
                ),
                      _buildStatBadge(
                  context,
                  icon: Icons.auto_awesome,
                        value: widget.user.storyLikesCount,
                        label: 'Stories',
                  color: AppColors.warning,
                ),
                if (widget.user.dmCount > 0)
                      _buildStatBadge(
                  context,
                  icon: Icons.message,
                        value: widget.user.dmCount,
                        label: 'DMs',
                  color: AppColors.success,
                ),
                      _buildStatBadge(
                  context,
                  icon: Icons.insights,
                        value: widget.user.totalScore,
                        label: 'Score',
                  color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          if (hasDetails) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.chat_bubble_outline, size: 20),
                    text: 'Comentarios (${widget.details!.comments.length})',
                  ),
                  Tab(
                    icon: const Icon(Icons.favorite_outline, size: 20),
                    text: 'Likes (${widget.details!.likedPosts.length})',
                  ),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCommentsTab(context),
                  _buildLikesTab(context),
                ],
              ),
            ),
          ] else ...[
            // No details available - show insight
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),
          ],

          // Bottom buttons
          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
            child: InstagramButton(
            text: 'Cerrar',
            isOutlined: true,
            onPressed: () => Navigator.pop(context),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsTab(BuildContext context) {
    final comments = widget.details?.comments ?? [];
    if (comments.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.chat_bubble_outline,
        message: 'No hay comentarios registrados',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.chat_bubble, size: 14, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      DateFormatter.formatDateOnly(comment.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                  ),
                  Text(
                    DateFormatter.formatTimestampRelative(
                      comment.timestamp.millisecondsSinceEpoch ~/ 1000,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                comment.content.isNotEmpty ? comment.content : '(Comentario vacío)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLikesTab(BuildContext context) {
    final likes = widget.details?.likedPosts ?? [];
    if (likes.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.favorite_outline,
        message: 'No hay likes registrados',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: likes.length,
      itemBuilder: (context, index) {
        final like = likes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            tileColor: AppColors.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite, color: AppColors.error, size: 20),
            ),
            title: Text(
              DateFormatter.formatDateOnly(like.timestamp),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            subtitle: Text(
              DateFormatter.formatTimestampRelative(
                like.timestamp.millisecondsSinceEpoch ~/ 1000,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
            trailing: like.postUrl != null
                ? IconButton(
                    icon: const Icon(Icons.open_in_new, size: 18),
                    color: AppColors.primary,
                    onPressed: () => _openPost(like.postUrl),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, {required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(
    BuildContext context, {
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  String _getInsightText(bool isMutual) {
    if (widget.user.totalScore > 100) {
      if (isMutual) {
        return 'Interactúas mucho con esta cuenta. ¡Parece que os lleváis bien!';
      } else if (widget.isFollowing == true && widget.isFollower != true) {
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
      text = 'Mutuos';
      color = AppColors.info;
      icon = Icons.people;
    } else if (widget.isFollower == true) {
      text = 'Te sigue';
      color = AppColors.success;
      icon = Icons.person_add;
    } else if (widget.isFollowing == true) {
      text = 'No te sigue';
      color = AppColors.warning;
      icon = Icons.person_remove;
    } else {
      text = 'Sin relación';
      color = AppColors.textTertiary;
      icon = Icons.person_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
  UserInteractionDetails? details,
  bool? isFollower,
  bool? isFollowing,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => InteractionDetailSheet(
      user: user,
      details: details,
      isFollower: isFollower,
      isFollowing: isFollowing,
    ),
  );
}

