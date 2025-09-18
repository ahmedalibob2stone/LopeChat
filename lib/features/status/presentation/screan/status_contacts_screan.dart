import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../constant.dart';
import '../../../settings/presentation/provider/privacy/statu/vm/filter_statu_viewmodel.dart';
import '../../../settings/presentation/provider/privacy/statu/vm/status_privascy_viewmodel.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';

class StatusListScreen extends ConsumerWidget {
  const StatusListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyState = ref.watch(statusPrivacyProvider);
    final statusState = ref.watch(filterStatusViewModelProvider);
    final filterVm = ref.read(filterStatusViewModelProvider.notifier);

    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid ?? '';

    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth * 0.05;
    final double subtitleFontSize = screenWidth * 0.04;

    if (statusState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (statusState.error != null) {
      return Center(child: Text('Error: ${statusState.error}'));
    }

    if (statusState.statuses.isEmpty) {
      return const Center(child: Text('No statuses found.'));
    }

    final filteredStatuses = filterVm.filterStatusesWithPrivacy(
      currentUserId: currentUserId,
      privacyState: privacyState,
    );

    if (filteredStatuses.isEmpty) {
      return const Center(child: Text('No statuses available to view.'));
    }

    return ListView.builder(
      itemCount: filteredStatuses.length,
      itemBuilder: (context, index) {
        final statusData = filteredStatuses[index];

        return Consumer(
          builder: (context, ref, _) {
            final canViewPhotoAsync = ref.watch(profilePhotoVisibilityProvider({
              'currentUserId': currentUserId,
              'otherUserId': statusData.uid,
            }));

            return canViewPhotoAsync.when(
              data: (canViewPhoto) {
                return _buildListTile(
                  statusData,
                  canViewPhoto: canViewPhoto,
                  titleFontSize: titleFontSize,
                  subtitleFontSize: subtitleFontSize,
                  context: context,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) =>
              const Center(child: Text('Error checking profile photo')),
            );
          },
        );
      },
    );
  }

  Widget _buildListTile(
      statusData, {
        required bool canViewPhoto,
        required double titleFontSize,
        required double subtitleFontSize,
        required BuildContext context,
      }) {
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
              title: Text(
                statusData.username,
                style: TextStyle(fontSize: titleFontSize),
              ),
              subtitle: Text(
                statusData.phoneNumber,
                style: TextStyle(fontSize: subtitleFontSize),
              ),
              leading: CircleAvatar(
                backgroundImage:
                canViewPhoto ? NetworkImage(statusData.profilePic) : null,
                child: canViewPhoto ? null : const Icon(Icons.person),
                radius: 30,
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
