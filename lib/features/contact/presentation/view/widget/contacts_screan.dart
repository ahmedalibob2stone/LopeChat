import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../common/utils/colors.dart';
import '../../../../user/domain/entities/user_entity.dart';


class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contactSource,
    required this.onTap,
  }) : super(key: key);

  final UserEntity contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // حجم متناسب مع الشاشة
    final double horizontalPadding = screenWidth * 0.02; // 3% padding
    final double leadingRadius = screenWidth * 0.1; // 8% radius
    final double fontSize = screenWidth * 0.04; // 4.5% font size

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: horizontalPadding / 2,
      ),
      leading: CircleAvatar(
        radius: leadingRadius,
        backgroundColor: Colors.grey[300],
        backgroundImage: contactSource.profile.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profile)
            : null,
        child: contactSource.profile.isEmpty
            ? Icon(
          Icons.person,
          color: Colors.white,
          size: fontSize * 2,
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
            ? contactSource.statu.isNotEmpty
            ? contactSource.statu
            : "Hey there! I'm using Lopechat"
            : "Not on Lopechat",
        style: TextStyle(
          fontSize: fontSize * 0.9,
          color: Colors.grey[700],
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: contactSource.uid.isEmpty
          ? TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Coloors.greenDark,
          textStyle: TextStyle(fontSize: fontSize * 0.9),
        ),
        child: const Text('INVITE'),
      )
          : null,
      onTap: onTap,
    );
  }
}
