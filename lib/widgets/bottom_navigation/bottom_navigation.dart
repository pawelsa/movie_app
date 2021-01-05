import 'package:flutter/material.dart';
import 'package:movie_app/resources/dimen.dart';
import 'package:movie_app/utils/extensions.dart';
import 'package:movie_app/widgets/bottom_navigation/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigationItemData {
  final IconData icon;
  final String label;

  BottomNavigationItemData(this.icon, [this.label]);
}

class BottomNavigation extends StatefulWidget {
  final List<BottomNavigationItemData> items;
  final double iconSize;
  final Color backgroundColor;
  final int startIndex;

  const BottomNavigation({
    Key key,
    this.items,
    this.backgroundColor,
    this.startIndex,
    double iconSize,
  })  : this.iconSize = iconSize ?? Dimen.iconSize,
        super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  AnimationController _visibilityController;
  Animation<Offset> _visibilityAnimation;

  @override
  void initState() {
    super.initState();

    _visibilityController = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
    );
    _visibilityAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 1))
        .animate(_visibilityController);
  }

  void updateWidget(int newPosition, bool isVisible) {
      if (isVisible) {
        _visibilityController.reverse();
      } else {
        _visibilityController.forward();
      }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minHeight = theme.bottomNavigationBarTheme.selectedIconTheme.size +
        Dimen.bottomNavigationBottomPadding +
        Dimen.bottomNavigationTopPadding;

    return SlideTransition(
      position: _visibilityAnimation,
      child: Container(
        height: minHeight,
        child: Material(
          color: widget.backgroundColor ?? theme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimen.bottomNavigationCornerRadius),
            topRight: Radius.circular(Dimen.bottomNavigationCornerRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: Dimen.bottomNavigationTopPadding,
              bottom: Dimen.bottomNavigationBottomPadding,
            ),
            child: Consumer<BottomNavigationProvider>(
              builder: (_, provider, __) {
                updateWidget(provider.currentlySelected, provider.isVisible);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildItems(provider),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(BottomNavigationProvider provider) {
    return widget.items.mapIndexed<Widget>((index, value) {
      final theme = Theme.of(context).bottomNavigationBarTheme;
      final isSelected = provider.currentlySelected == index;
      final iconThemeData =
          isSelected ? theme.selectedIconTheme : theme.unselectedIconTheme;

      return Expanded(
        child: _BottomNavigationItem(
          isSelected: provider.currentlySelected == index,
          onTap: () => provider.currentlySelected = index,
          icon: value.icon,
          label: value.label,
          iconSize: widget.iconSize,
          iconThemeData: iconThemeData,
        ),
      );
    });
  }
}

class _BottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onTap;
  final bool isSelected;
  final double iconSize;
  final IconThemeData iconThemeData;

  const _BottomNavigationItem(
      {Key key,
      this.icon,
      this.label,
      this.onTap,
      this.isSelected,
      this.iconSize,
      this.iconThemeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkResponse(
        radius: Dimen.bottomNavigationRippleRadius,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconTheme(
              data: iconThemeData,
              child: Icon(icon),
            ),
            if (label != null) Text(label),
          ],
        ),
      ),
    );
  }
}
