import 'package:fluent_ui/fluent_ui.dart';

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
