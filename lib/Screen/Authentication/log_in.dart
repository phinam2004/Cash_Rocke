import 'package:cash_rocket/Repositories/authentication_repo.dart';
import 'package:cash_rocket/Screen/Authentication/New%20Authentication/phone_verification.dart';
import 'package:cash_rocket/Screen/Constant%20Data/button_global.dart';
import 'package:cash_rocket/Screen/Constant%20Data/global_contanier.dart';
import 'package:cash_rocket/Theme/theme.dart';
import 'package:cash_rocket/constant%20app%20information/const_information.dart';
import 'package:cash_rocket/generated/l10n.dart' as lang;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Constant Data/constant.dart';
import '../Home Screen/no_internet_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isChecked = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> checkInternet() async {
    bool result = await InternetConnection().hasInternetAccess;
    if (!result && mounted) {
      NoInternetScreen(screenName: widget).launch(context);
    }
  }

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GlobalContainer(
              column: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(logo),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    appsName,
                    style: kTextStyle.copyWith(
                        color: kWhite, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40.0),
                  AppTextField(
                    textStyle: kTextStyle.copyWith(color: kWhite),
                    showCursor: true,
                    textFieldType: TextFieldType.EMAIL,
                    controller: emailController,
                    decoration: kInputDecoration.copyWith(
                      hintText: "Email",
                      hintStyle: kTextStyle.copyWith(color: lightGreyTextColor),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.email, color: kWhite),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    textStyle: kTextStyle.copyWith(color: kWhite),
                    showCursor: true,
                    textFieldType: TextFieldType.PASSWORD,
                    controller: passwordController,
                    decoration: kInputDecoration.copyWith(
                      hintText: "Mật khẩu",
                      hintStyle: kTextStyle.copyWith(color: lightGreyTextColor),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.lock, color: kWhite),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ButtonGlobal(
                    buttontext: 'Đăng nhập',
                    buttonDecoration: kButtonDecoration,
                    onPressed: () async {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        EasyLoading.showInfo('Vui lòng nhập email và mật khẩu');
                        return;
                      }
                      try {
                        EasyLoading.show(status: 'Đang đăng nhập...');
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        // Đăng nhập thành công, chuyển vào trang chủ
                        Navigator.pushReplacementNamed(
                            context, '/'); // hoặc const Home().launch(context);
                        EasyLoading.dismiss();
                      } on FirebaseAuthException catch (e) {
                        EasyLoading.showError(
                            e.message ?? 'Đăng nhập thất bại');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
