import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:simple_budget/_index.g.dart';

class LoginFormPage extends StatefulWidget {
  const LoginFormPage({super.key});

  @override
  State<LoginFormPage> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "username",
          style: TextStyle(
            color: MyColor.backgroundColor,
            fontSize: 12,
          ),
        ),
        CupertinoTextField(
          controller: _identifierController,
          decoration: BoxDecoration(
            color: MyColor.backgroundColor,
            borderRadius: BorderRadius.circular(25)
          ),
          cursorColor: MyColor.primaryColorDark,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColor.primaryColorDark,
          ),
        ),
        const SizedBox(height: 5,),
        const Text(
          "password",
          style: TextStyle(
            color: MyColor.backgroundColor,
            fontSize: 12,
          ),
        ),
        CupertinoTextField(
          controller: _passwordController,
          decoration: BoxDecoration(
            color: MyColor.backgroundColor,
            borderRadius: BorderRadius.circular(25)
          ),
          cursorColor: MyColor.primaryColorDark,
          obscureText: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColor.primaryColorDark,
          ),
        ),
        const Expanded(child: SizedBox(),),
        MyButton(
          color: MyColor.primaryColorDark,
          child: const Center(
            child: Text(
              "LOGIN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () async {
            await _validateFormAndLogin();
          },
        ),
      ],
    );
  }

  Future<void> _validateFormAndLogin() async {
    // get identifier and password from controller
    String identifier = _identifierController.text.trim();
    String password = _passwordController.text.trim();

    // ensure both is not empty
    if (identifier.isEmpty) {
      _showSnackBar(
        errorMessage: "Username is empty",
      );
      return;
    }

    if (password.isEmpty) {
      _showSnackBar(
        errorMessage: "Password is empty",
      );
      return;
    }

    // both filled, it means that we can call Login API
    try {
      await UserAPI.login(identifier: identifier, password: password).then((login) async {
        // user login already, stored the JWT on the secure storage
        await SecureBox.put(key: 'jwt', value: login.jwt);

        // set the NetUtils JWT also
        NetUtils.setJWT(bearerToken: login.jwt);

        // once JWT is put on the secure box and netutils, now put the user
        // information on the storage.
        await UserStorage.setUserInfo(login.user);

        // then we can navigate to dashboard instead
        if (mounted) {
          context.go('/dashboard');
        }
      });
    }
    on NetException catch (netError, stackTrace) {
      Log.error(
        message: "❌ Got error on the backend",
        error: netError,
        stackTrace: stackTrace,
      );
      // now showed the net error message
      _showSnackBar(errorMessage: netError.error()!.error.message);
    }
    on ClientException catch (clientError, stackTrace) {
      Log.error(
        message: "❌ Client error on the application",
        error: clientError,
        stackTrace: stackTrace,
      );
      // now showed the net error message
      _showSnackBar(errorMessage: "Unable to connect to backend API");
    }
    catch (error, stackTrace) {
      // unknown error
      Log.error(
        message: "❌ Error ${error.toString()}",
        error: error,
        stackTrace: stackTrace,
      );
      // now showed the net error message
      _showSnackBar(errorMessage: "Error occured on the application");
    }
  }

  void _showSnackBar({required String errorMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      createSnackBar(
        message: errorMessage,
        color: MyColor.primaryColor,
      ),
    );
  }
}