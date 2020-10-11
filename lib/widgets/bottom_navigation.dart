import 'package:flutter/material.dart';
import 'package:movie_app/resources/dimen.dart';

class BottomNavigationItemData {
  final IconData icon;
  final String label;

  BottomNavigationItemData(this.icon, [this.label]);
}

class BottomNavigation extends StatefulWidget {
  final List<BottomNavigationItemData> items;
  final Function(int) onPressed;
  final int currentIndex;
  final double iconSize;
  final Color backgroundColor;

  const BottomNavigation({
    Key key,
    this.items,
    this.onPressed,
    this.currentIndex,
    this.backgroundColor,
    double iconSize,
  })  : this.iconSize = iconSize ?? Dimen.iconSize,
        super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  List<AnimationController> _animationControllers;
  List<Animation> _animations;

  @override
  void initState() {
    super.initState();
    _animationControllers =
        List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations =
        List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _animationControllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });
    _animationControllers[widget.currentIndex].value = 1.0;
  }

  @override
  void didUpdateWidget(covariant BottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex) {
      _animationControllers[oldWidget.currentIndex].reverse();
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minHeight =
        theme.bottomNavigationBarTheme.selectedIconTheme.size +
            Dimen.bottomNavigationBottomPadding +
            Dimen.bottomNavigationTopPadding;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimen.bottomNavigationCornerRadius),
            topRight: Radius.circular(Dimen.bottomNavigationCornerRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: Dimen.bottomNavigationTopPadding,
            bottom: Dimen.bottomNavigationBottomPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    final List<Widget> widgets = [];
    final theme = Theme.of(context).bottomNavigationBarTheme;
    widget.items.asMap().forEach((index, value) {
      widgets.add(
        Expanded(
          child: _BottomNavigationItem(
            index: index,
            colorTween: ColorTween(
              begin: theme.unselectedItemColor,
              end: theme.selectedItemColor,
            ),
            onTap: widget.onPressed,
            icon: value.icon,
            label: value.label,
            iconSize: widget.iconSize,
            animation: _animations[index],
            selectedIconTheme: theme.selectedIconTheme,
            unselectedIconTheme: theme.unselectedIconTheme,
          ),
        ),
      );
    });
    return widgets;
  }

  void _rebuild() => setState(() {});
}

class _BottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorTween colorTween;
  final Function(int) onTap;
  final int index;
  final Animation<double> animation;
  final IconThemeData unselectedIconTheme;
  final IconThemeData selectedIconTheme;
  final double iconSize;

  const _BottomNavigationItem({
    Key key,
    this.icon,
    this.label,
    this.colorTween,
    this.onTap,
    this.index,
    this.animation,
    this.iconSize,
    this.unselectedIconTheme,
    this.selectedIconTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color iconColor = colorTween.evaluate(animation);
    final IconThemeData defaultIconTheme = IconThemeData(
      color: iconColor,
      size: iconSize,
    );
    final IconThemeData iconThemeData = IconThemeData.lerp(
      defaultIconTheme.merge(unselectedIconTheme),
      defaultIconTheme.merge(selectedIconTheme),
      animation.value,
    );

    return Container(
      child: InkResponse(
        onTap: () => onTap(index),
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
