import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as ms_icons;

class ListCard extends StatefulWidget {
  const ListCard({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard>
    with AutomaticKeepAliveClientMixin<ListCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final theme = FluentTheme.of(context);

    return Card(
      backgroundColor: widget.backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onPressed,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var leading = this.leading ?? Container();
    var title = DefaultTextStyle(
      style: FluentTheme.of(context).typography.body!.copyWith(
            fontSize: 15,
          ),
      child: this.title ?? Container(),
    );
    var subtitle = DefaultTextStyle(
      style: FluentTheme.of(context).typography.body!.copyWith(
            color:
                FluentTheme.of(context).typography.body!.color?.withAlpha(150),
          ),
      child: this.subtitle ?? Container(),
    );
    var trailing = this.trailing ?? Container();

    return Card(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: IconButton(
            icon: SizedBox(
              height: 60,
              child: Row(
                children: [
                  const SizedBox(width: 10.0),
                  leading,
                  const SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      title,
                      subtitle,
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  trailing,
                  const Icon(ms_icons.FluentIcons.chevron_right_24_regular),
                  const SizedBox(width: 10.0),
                ],
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
