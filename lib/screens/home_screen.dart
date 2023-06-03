import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with PageMixin {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const PageHeader(title: Text('Willkommen')),
      content: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FractionallySizedBox(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: SvgPicture.asset(
            'assets/images/undraw_set_preferences_kwia.svg',
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}