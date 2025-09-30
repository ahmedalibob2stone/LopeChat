import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:lopechat/features/status/presentation/screan/status_screan.dart';
import 'package:lopechat/features/status/presentation/screan/widget/status_ring.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../constant.dart';
import '../../../settings/presentation/provider/privacy/statu/vm/status_privascy_viewmodel.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../user/presentation/provider/user_provider.dart';
import '../provider/viewmodel/get_status_viewmodel_provider.dart';

      class StatusListScreen extends ConsumerStatefulWidget {
  const StatusListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusListScreen> createState() => _StatusListScreenState();
}

class _StatusListScreenState extends ConsumerState<StatusListScreen> {
  @override
  Widget build(BuildContext context) {
    // متابعة حالات المستخدمين مباشرة
      final statusState = ref.watch(getStatusesViewModelProvider);
    final privacyState = ref.watch(statusPrivacyProvider);
    final currentUserId = ref.watch(currentUserStreamProvider).asData?.value?.uid ?? '';

    if (statusState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (statusState.error != null) {
      return Center(child: Text('Error: ${statusState.error}'));
    }

    // فلترة الحالات حسب الخصوصية
    final filteredStatuses = statusState.statuses.where((status) {
      return status.whoCanSee.contains(currentUserId); // شرط الخصوصية
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth * 0.05;
    final double subtitleFontSize = screenWidth * 0.04;

    // تقسيم الحالات بين حالاتي وحالات الآخرين
    final myStatus = filteredStatuses.where((s) => s.uid == currentUserId).toList();
    final friendsStatuses = filteredStatuses.where((s) => s.uid != currentUserId).toList();

    return ListView(
      children: [
        _buildMyStatusTile(myStatus.isNotEmpty ? myStatus.first : null, titleFontSize, subtitleFontSize),
        const Divider(thickness: 1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Recent Updates",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        ...friendsStatuses.map((statusData) {
          // هنا نستخدم FutureBuilder لكل حالة للتحقق من visibility مباشرة
          return FutureBuilder<bool>(
            future: ref.read(profilePhotoVisibilityProvider({
              'currentUserId': currentUserId,
              'otherUserId': statusData.uid,
            }).future),
            builder: (context, snapshot) {
              final canViewPhoto = snapshot.data ?? false;
              return _buildFriendTile(
                statusData,
                canViewPhoto: canViewPhoto,
                titleFontSize: titleFontSize,
                subtitleFontSize: subtitleFontSize,
                context: context,
              );
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMyStatusTile(statusData, double titleFontSize, double subtitleFontSize) {
    final hasStatus = statusData != null && statusData.photoUrls.isNotEmpty;
    final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
   final currentUserUId=currentUser!.uid;
    return ListTile(
      leading: hasStatus
          ? ClipOval(
        child: CachedNetworkImage(
          imageUrl: statusData.photoUrls.last,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      )
          : const CircleAvatar(
        radius: 30,
        child: Icon(Icons.person, size: 30),
      ),
      title: Text(
        "My Status",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        hasStatus ? "View your status" : "Tap to add status update",
        style: TextStyle(fontSize: subtitleFontSize),
      ),
      onTap: () {
        if (hasStatus) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StatusScreen(
                statusData: statusData,
                isMyStatus: statusData.uid == currentUserUId,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFriendTile(
      statusData, {
        required bool canViewPhoto,
        required double titleFontSize,
        required double subtitleFontSize,
        required BuildContext context,
      }) {
    if (!canViewPhoto) return const SizedBox.shrink(); // لن يظهر إذا الخصوصية تمنع

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              PageConst.StatusScrean,
              arguments: {
                'username': statusData.username,
                'profilePic': statusData.profilePic,
                'phoneNumber': statusData.phoneNumber,
                'PhotoUrl': statusData.photoUrls,
                'massage': statusData.messages,
                'uid': statusData.uid,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: StatusRing(
                imageUrl: statusData.photoUrls.isNotEmpty ? statusData.photoUrls.last : statusData.profilePic,
                totalStories: statusData.photoUrls.length,
                seenStories: statusData.seenCount ?? 0,
              ),
              title: Text(
                statusData.username,
                style: TextStyle(fontSize: titleFontSize),
              ),
              subtitle: Text(
                _formatTime(statusData.createdAt),
                style: TextStyle(fontSize: subtitleFontSize),
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return "اليوم، ${DateFormat.jm().format(time)}";
    }
    return DateFormat('dd/MM/yyyy, jm').format(time);
  }
}
