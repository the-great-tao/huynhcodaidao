import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      width: 1080,
      height: 1920,
      allowFontScaling: true,
    );

    return ResponsiveWidgets.builder(
      child: Scaffold(
        body: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.white,
            accentColor: Colors.white,
            cursorColor: Colors.white,
            buttonColor: Colors.amber.withAlpha(240),
            textTheme: TextTheme(
              button: TextStyle(
                fontSize: ScreenUtil().setSp(50),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                fontSize: ScreenUtil().setSp(50),
              ),
              contentPadding: EdgeInsetsResponsive.all(50),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9999),
                borderSide: BorderSide(
                  width: 4.w,
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9999),
                borderSide: BorderSide(
                  width: 8.w,
                  color: Colors.white,
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
                  image: AssetImage('assets/login_screen_background.png'),
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
                      image: AssetImage('assets/login_screen_logo.png'),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
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
                    margin: EdgeInsetsResponsive.fromLTRB(120, 20, 120, 20),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        prefixIcon: Icon(
                          Icons.phone,
                          size: ScreenUtil().setSp(80),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 200.w,
                        ),
                      ),
                    ),
                  ),
                  ContainerResponsive(
                    margin: EdgeInsetsResponsive.fromLTRB(120, 20, 120, 20),
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          size: ScreenUtil().setSp(80),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 200.w,
                        ),
                      ),
                    ),
                  ),
                  ContainerResponsive(
                    padding: EdgeInsetsResponsive.fromLTRB(120, 60, 120, 60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        padding:
                            EdgeInsetsResponsive.fromLTRB(120, 60, 120, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                          side: BorderSide(
                            color: Colors.amber,
                          ),
                        ),
                        onPressed: () {},
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
    );
  }
}
