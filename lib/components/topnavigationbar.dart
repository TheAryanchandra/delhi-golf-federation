import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;
  final bool? showBackButton; // optional, null = auto-detect

  const TopNavigationBar({
    super.key,
    this.onMenuTap,
    this.onSettingsTap,
    this.onNotificationTap,
    this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    // Determine whether to show back button
    final bool displayBackButton = showBackButton ?? Navigator.canPop(context);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: displayBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onPressed: onMenuTap ?? () {},
            ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black, size: 24),
          onPressed: onSettingsTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfile()),
                );
              },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black, size: 26),
          onPressed: onNotificationTap ?? () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
