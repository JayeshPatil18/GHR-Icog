import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:review_app/constants/color.dart';
import 'package:review_app/constants/elevation.dart';
import 'package:review_app/constants/values.dart';
import 'package:review_app/features/reviews/presentation/widgets/snackbar.dart';
import 'package:email_otp/email_otp.dart';
import 'package:review_app/main.dart';
import '../../../../constants/boarder.dart';
import '../../../../constants/cursor.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../../reviews/domain/entities/verify_arguments.dart';
import '../../../reviews/presentation/widgets/shadow.dart';
import '../../data/repositories/users_repo.dart';

class SignUpPage extends StatefulWidget {
  static EmailOTP emailAuth = EmailOTP();

  const SignUpPage({super.key});
  static String verify = "";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool isLoading = false;

  final FocusNode _focusEmailNode = FocusNode();
  bool _hasEmailFocus = false;

  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateInput(String? input, int index) {

    List<String> patternsList = [];
    if (input != null) {
      input = input.trim();

      List<String> separatedStrings = MyApp.emailPattern.split('@');
      patternsList = separatedStrings.where((str) => str.isNotEmpty).toList();
    }

    switch (index) {
      case 0:
        // Write logic to check email from this college.
        if (input == null || input.isEmpty) {
          return 'Enter college email';
        } else if(patternsList != null && patternsList.isNotEmpty){
          bool isAnyPatternMatch = false;
          for (String element in patternsList) {
            if (input.contains('@${element}')) {
              isAnyPatternMatch = true;
              break;
            }
          }

          if(!isAnyPatternMatch){
            return 'Enter college email of ${AppValues.collegeNameCode}, Pune';
          }
        } else if(!(input.contains(AppValues.defaultEmailFormat))){
          return 'Enter college email of ${AppValues.collegeNameCode}, Pune';
        }
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusEmailNode.addListener(() {
      setState(() {
        _hasEmailFocus = _focusEmailNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin:
              const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
          child: Container(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor10,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppBoarderRadius.buttonRadius)),
                  elevation: AppElevations.buttonElev,
                ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  if(!isLoading){
                    setIsLoading(true);

                    bool isValid = _formKey.currentState!.validate();
                    if (isValid) {
                      bool isOtpSent = await sendOtp(emailController.text.trim());
                      if (isOtpSent) {
                        FocusScope.of(context).unfocus();
                        mySnackBarShow(context, 'OTP has been sent.');

                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.of(context).pushNamed('verifyphone',
                              arguments:
                              VerifyArguments(emailController.text.trim()));
                        });
                      } else {
                        mySnackBarShow(context, 'Oops, OTP send failed.');
                      }
                    }

                    setIsLoading(false);
                  }
                },
                child: isLoading == false ? Text('Continue', style: AuthFonts.authButtonText()) : SizedBox(
              width: 30,
              height: 30,
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth:
                      AppValues.progresBarWidth,
                      color:
                      AppColors.primaryColor30)))),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.mainGradient),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 140, bottom: 10),
                child: Text('Enter College Email',
                    style: MainFonts.pageTitleText(
                        fontSize: 24, weight: FontWeight.w500)),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: ((value) {
                              return _validateInput(value, 0);
                            }),
                            style: MainFonts.textFieldText(),
                            focusNode: _focusEmailNode,
                            cursorHeight: TextCursorHeight.cursorHeight,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  top: 16, bottom: 16, left: 20, right: 20),
                              fillColor: AppColors.transparentComponentColor,
                              filled: true,
                              hintText: 'Enter email',
                              hintStyle: MainFonts.hintFieldText(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBoarderRadius.buttonRadius),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBoarderRadius.buttonRadius),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 4, right: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.security,
                                    color: AppColors.safeColor, size: 12),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                      'Your email address will not be stored. It is only use to make sure you are student of ${AppValues.collegeName}.',
                                      style:
                                          AuthFonts.authMsgText(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  )),
            ],
          ),
        ));
  }

  Future<bool> sendOtp(String email) async {
    SignUpPage.emailAuth.setConfig(
        appEmail: "jp7470484@gmail.com",
        appName: "GHR Incog",
        userEmail: email,
        otpLength: 6,
        otpType: OTPType.digitsOnly);

    if (await SignUpPage.emailAuth.sendOTP() == true) {
      return true;
    } else {
      return false;
    }
  }

  setIsLoading(bool isLoadingVal) {
    setState(() {
      isLoading = isLoadingVal;
    });
  }
}
