import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'language_selector.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showDrawerIcon;
  final List<Widget>? additionalActions;
  final double height;
  final bool isTransparent;

  const CommonAppBar({
    super.key,
    this.title,
    this.showDrawerIcon = true,
    this.additionalActions,
    this.height = kToolbarHeight,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: isTransparent ? Colors.transparent : null,
      elevation: isTransparent ? 0 : null,
      leading: showDrawerIcon
          ? Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: AppTheme.emerald),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      actions: [
        const LanguageSelector(),
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
