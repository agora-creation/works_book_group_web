import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/widgets/title_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TitleLogo(),
              SizedBox(height: 24),
              SpinKitFadingCircle(color: kBaseColor),
            ],
          ),
        ),
      ),
    );
  }
}
