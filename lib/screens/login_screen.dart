import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:huynhcodaidao/blocs/login_screen_event.dart';
import 'package:huynhcodaidao/blocs/login_screen_state.dart';
import 'package:huynhcodaidao/blocs/login_screen_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Color _textFormFieldColor = Colors.white;
  bool _obscureOption = true;
  String _obscureOptionText = 'Hiện';

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenBloc, LoginScreenState>(
      listener: (BuildContext context, LoginScreenState state) {
        ResponsiveWidgets.init(
          context,
          width: 1080,
          height: 1920,
          allowFontScaling: true,
        );

        if (state is LoginScreenInProgress) {
          _textFormFieldColor = Colors.white70;
        }

        if (state is LoginScreenFailure && state.error is DioError) {
          DioError error = state.error as DioError;
          DioErrorType errorType = error.type;
          String content;

          if (errorType == DioErrorType.RESPONSE) {
            content = 'Vui lòng kiểm tra số điện thoại hoặc mật khẩu.';
          } else {
            content = 'Vui lòng kiểm tra kết nối Internet.';
          }

          AlertDialog alertDialog = AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.w),
            ),
            titlePadding: EdgeInsetsResponsive.fromLTRB(100, 100, 100, 50),
            contentPadding: EdgeInsetsResponsive.fromLTRB(100, 50, 100, 50),
            buttonPadding: EdgeInsetsResponsive.fromLTRB(50, 50, 50, 50),
            insetPadding: EdgeInsetsResponsive.all(100),
            title: Text('Lỗi đăng nhập'),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
            ),
            content: Text(content),
            contentTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 50.sp,
            ),
            actions: [
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 50.sp,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertDialog;
            },
          );
        }

        if (state is LoginScreenObscureOptionChanged) {
          _obscureOption = state.obscureOption;
          if (_obscureOption) {
            _obscureOptionText = 'Hiện';
          } else {
            _obscureOptionText = 'Ẩn';
          }
        }
      },
      child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
        builder: (BuildContext context, LoginScreenState state) {
          // ignore: close_sinks
          final LoginScreenBloc loginScreenBloc =
              BlocProvider.of<LoginScreenBloc>(context);

          ResponsiveWidgets.init(
            context,
            width: 1080,
            height: 1920,
            allowFontScaling: true,
          );

          return ResponsiveWidgets.builder(
            child: Stack(
              children: <Widget>[
                Scaffold(
                  body: Theme(
                    data: ThemeData(
                      brightness: Brightness.dark,
                      primaryColor: _textFormFieldColor,
                      accentColor: _textFormFieldColor,
                      cursorColor: _textFormFieldColor,
                      buttonColor: Colors.amber.withAlpha(240),
                      textTheme: TextTheme(
                        button: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                          fontSize: 50.sp,
                        ),
                        contentPadding: EdgeInsetsResponsive.all(50),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            width: 4.w,
                            color: _textFormFieldColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            width: 8.w,
                            color: _textFormFieldColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9999),
                          borderSide: BorderSide(
                            width: 4.w,
                            color: _textFormFieldColor,
                          ),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: ContainerResponsive(
                        width: 1080,
                        height: 1920,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/login_screen_background.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            ContainerResponsive(
                              width: 540,
                              heightResponsive: false,
                              margin: EdgeInsetsResponsive.all(200),
                              child: Image(
                                image:
                                    AssetImage('assets/logo.png'),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amberAccent,
                                    blurRadius: 80.w,
                                    spreadRadius: 80.w,
                                  ),
                                ],
                              ),
                            ),
                            ContainerResponsive(
                              margin: EdgeInsetsResponsive.fromLTRB(
                                  120, 20, 120, 20),
                              child: TextFormField(
                                enabled: state is! LoginScreenInProgress,
                                controller: _usernameController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 50.sp,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Số điện thoại',
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    size: 80.sp,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 200.w,
                                  ),
                                ),
                              ),
                            ),
                            ContainerResponsive(
                              margin: EdgeInsetsResponsive.fromLTRB(
                                  120, 20, 120, 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    enabled: state is! LoginScreenInProgress,
                                    controller: _passwordController,
                                    obscureText: _obscureOption,
                                    style: TextStyle(
                                      fontSize: 50.sp,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Mật khẩu',
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        size: 80.sp,
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 200.w,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 50.w,
                                    child: GestureDetector(
                                      child: Text(
                                        _obscureOptionText,
                                        style: TextStyle(
                                          color: _textFormFieldColor,
                                          fontSize: 50.sp,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: state is LoginScreenInProgress
                                          ? null
                                          : () {
                                              loginScreenBloc.add(
                                                LoginScreenObscureOptionTapped(
                                                  obscureOption: _obscureOption,
                                                ),
                                              );
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ContainerResponsive(
                              padding: EdgeInsetsResponsive.fromLTRB(
                                  120, 60, 120, 60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  disabledColor: Colors.amberAccent,
                                  padding: EdgeInsetsResponsive.fromLTRB(
                                      120, 60, 120, 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9999),
                                    side: BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onPressed: state is LoginScreenInProgress
                                      ? null
                                      : () {
                                          loginScreenBloc.add(
                                            LoginScreenLoginButtonPressed(
                                              username:
                                                  _usernameController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                        },
                                  child: Text(
                                    'ĐĂNG NHẬP',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                state is LoginScreenInProgress
                    ? ContainerResponsive(
                        color: Colors.black54,
                        child: Center(
                          child: SpinKitFadingCircle(
                            size: 120.w,
                            color: Colors.amber,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
