import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:works_book_group_web/common/style.dart';
import 'package:works_book_group_web/providers/auth.dart';
import 'package:works_book_group_web/screens/home.dart';
import 'package:works_book_group_web/widgets/custom_big_button.dart';
import 'package:works_book_group_web/widgets/custom_text_box.dart';
import 'package:works_book_group_web/widgets/title_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ScaffoldPage(
      content: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TitleLogo(),
              const SizedBox(height: 40),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      InfoLabel(
                        label: '会社・組織番号',
                        child: CustomTextBox(
                          controller: authProvider.numberController,
                          placeholder: '',
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InfoLabel(
                        label: 'パスワード',
                        child: CustomTextBox(
                          controller: authProvider.passwordController,
                          placeholder: '',
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomBigButton(
                        labelText: 'ログイン',
                        labelColor: kWhiteColor,
                        backgroundColor: kBaseColor,
                        onPressed: () async {
                          String? error = await authProvider.signIn();
                          if (error != null) {
                            return;
                          }
                          authProvider.clearController();
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            FluentPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
