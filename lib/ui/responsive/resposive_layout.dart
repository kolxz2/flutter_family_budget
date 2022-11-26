import 'package:flutter/cupertino.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;
  const ResponsiveLayout(
      {Key? key,
      required this.mobileScaffold,
      required this.tabletScaffold,
      required this.desktopScaffold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // constraint - ограничения
    return LayoutBuilder(builder: (context, constraint) {
      // mobile max width 480px
      if (constraint.maxWidth < 500) {
        return mobileScaffold;
        // tablet max width 1024px
      } else if (constraint.maxWidth < 1050) {
        return tabletScaffold;
      } else {
        return desktopScaffold;
      }
    });
  }
}
