import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../../common/utils/colors.dart';
import '../../../../user/domain/entities/user_entity.dart';
import '../../../../user/provider/get_userdata_provider.dart';

class ContactCard extends ConsumerWidget {
  final UserEntity contactSource;
  final VoidCallback onTap;

  const ContactCard({
    Key? key,
    required this.contactSource,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.02;
    final double leadingRadius = screenWidth * 0.1;
    final double fontSize = screenWidth * 0.04;

    final currentUser = ref.watch(userStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid ?? '';

    if (currentUserId.isEmpty) {
      return ListTile(
        leading: CircleAvatar(child: CircularProgressIndicator()),
        title: const Text('Loading...'),
      );
    }

    // استخدام مزود profilePhotoVisibilityProvider للتحقق من إمكانية عرض الصورة
    final profileVisibilityAsync = ref.watch(
      profilePhotoVisibilityProvider({
        'currentUserId': currentUserId,
        'otherUserId': contactSource.uid,
      }),
    );

    return profileVisibilityAsync.when(
      loading: () => ListTile(
        leading: CircleAvatar(child: CircularProgressIndicator()),
        title: const Text('Loading...'),
      ),
      error: (error, _) => ListTile(
        leading: CircleAvatar(child: Icon(Icons.error)),
        title: Text("Error: $error"),
      ),
      data: (canViewPhoto) {
        return ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding / 2,
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.3),
            radius: leadingRadius,
            backgroundImage: canViewPhoto && contactSource.profile.isNotEmpty
                ? CachedNetworkImageProvider(contactSource.profile)
                : null,
            child: canViewPhoto
                ? null
                : contactSource.profile.isEmpty
                ? Icon(
              Icons.person,
              size: fontSize * 2,
              color: Colors.white,
            )
                : null,
          ),
          title: Text(
            contactSource.name,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            contactSource.uid.isNotEmpty
                ? "Hey there! I'm using WhatsApp"
                : contactSource.statu,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: fontSize * 0.9,
            ),
          ),
          trailing: contactSource.uid.isEmpty
              ? TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: Coloors.greenDark,
              textStyle: TextStyle(fontSize: fontSize),
            ),
            child: const Text('INVITE'),
          )
              : null,
        );
      },
    );
  }
}
