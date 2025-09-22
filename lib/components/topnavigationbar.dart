import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;
  final bool showBackButton;

  const TopNavigationBar({
    super.key,
    this.onMenuTap,
    this.onSettingsTap,
    this.onNotificationTap,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          showBackButton ? Icons.arrow_back : Icons.menu,
          color: Colors.black,
          size: 28,
        ),
        onPressed: showBackButton
            ? () => Navigator.pop(context)
            : (onMenuTap ?? () {}),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black, size: 24),
          onPressed:
              onSettingsTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfile()),
                );
              },
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.black,
            size: 26,
          ),
          onPressed: onNotificationTap ?? () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
