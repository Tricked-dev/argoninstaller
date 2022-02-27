// TMOD Installer (c) by Tricked-dev <tricked@tricked.pro>
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginStatefulWidget extends StatefulWidget {
  const LoginStatefulWidget({Key? key}) : super(key: key);

  @override
  State<LoginStatefulWidget> createState() => _LoginStatefulWidgetState();
}

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //Source https://www.tutorialkart.com/flutter/flutter-login-screen/
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SocialLoginButton(
        buttonType: SocialLoginButtonType.microsoft,
        onPressed: () {},
      ),
    );
    // return Padding(
    //     padding: const EdgeInsets.all(10),
    //     child: ListView(
    //       children: <Widget>[
    //         Container(
    //             alignment: Alignment.center,
    //             padding: const EdgeInsets.all(10),
    //             child: const Text(
    //               'TMod Installer',
    //               style: TextStyle(
    //                   color: Color(0xff60cfbc),
    //                   fontWeight: FontWeight.w500,
    //                   fontSize: 30),
    //             )),
    //         Container(
    //             alignment: Alignment.center,
    //             padding: const EdgeInsets.all(10),
    //             child: const Text(
    //               'Log into Microsoft Account',
    //               style: TextStyle(fontSize: 20),
    //             )),
    //         Container(
    //           padding: const EdgeInsets.all(10),
    //           child: TextBox(
    //             controller: nameController,
    //             placeholder: "Username",
    //             // decoration: const InputDecoration(
    //             //   border: OutlineInputBorder(),
    //             //   labelText: 'User Name',
    //             // ),
    //           ),
    //         ),
    //         Container(
    //           padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    //           child: TextBox(
    //             obscureText: true,
    //             controller: passwordController,
    //             placeholder: "Password",
    //             // decoration: const InputDecoration(
    //             //   border: OutlineInputBorder(),
    //             //   labelText: 'Password',
    //             // ),
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () async {
    //             await launch("https://www.minecraft.net/en-us/password/forgot");
    //             //forgot password screen
    //           },
    //           child: const Text(
    //             'Forgot Password',
    //           ),
    //         ),
    //         Container(
    //             // height: 50,
    //             padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //             child: OutlinedButton(
    //               child: const Text('Microsoft Login'),
    //               onPressed: () {
    //                 print(nameController.text);
    //                 print(passwordController.text);
    //               },
    //             )),
    //       ],
    //     ));
  }
}
