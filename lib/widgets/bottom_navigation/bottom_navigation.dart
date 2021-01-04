import 'package:flutter/material.dart';
import 'package:movie_app/resources/dimen.dart';
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
  List<AnimationController> _animationControllers;
  List<Animation> _animations;
  int _currentIndex;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
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
    _animationControllers[_currentIndex].value = 1.0;

    _visibilityController = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
    );
    _visibilityAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 1))
        .animate(_visibilityController);
  }

  void updateWidget(int newPosition, bool isVisible) {
    if (_currentIndex != newPosition) {
      _animationControllers[_currentIndex].reverse();
      _animationControllers[newPosition].forward();
      _currentIndex = newPosition;
    }
    if (_isVisible != isVisible) {
      if (isVisible) {
        _visibilityController.reverse();
      } else {
        _visibilityController.forward();
      }
      _isVisible = isVisible;
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimen.bottomNavigationCornerRadius),
            topRight: Radius.circular(Dimen.bottomNavigationCornerRadius),
          ),
          color: widget.backgroundColor ?? theme.backgroundColor,
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
    final List<Widget> widgets = [];
    final theme = Theme.of(context).bottomNavigationBarTheme;

    final colorTween = ColorTween(
      begin: theme.unselectedItemColor,
      end: theme.selectedItemColor,
    );

    widget.items.asMap().forEach((index, value) {
      final animation = _animations[index];
      final Color iconColor = colorTween.evaluate(animation);
      final IconThemeData defaultIconTheme = IconThemeData(
        color: iconColor,
        size: widget.iconSize,
      );
      final theme = Theme.of(context).bottomNavigationBarTheme;
      final IconThemeData iconThemeData = IconThemeData.lerp(
        defaultIconTheme.merge(theme.unselectedIconTheme),
        defaultIconTheme.merge(theme.selectedIconTheme),
        animation.value,
      );

      widgets.add(
        Expanded(
          child: _BottomNavigationItem(
            index: index,
            colorTween: colorTween,
            onTap: (index) {
              provider.currentlySelected = index;
            },
            icon: value.icon,
            label: value.label,
            iconSize: widget.iconSize,
            animation: animation,
            iconThemeData: iconThemeData,
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
  final double iconSize;
  final IconThemeData iconThemeData;

  const _BottomNavigationItem(
      {Key key,
      this.icon,
      this.label,
      this.colorTween,
      this.onTap,
      this.index,
      this.animation,
      this.iconSize,
      this.iconThemeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkResponse(
        radius: Dimen.bottomNavigationRippleRadius,
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
