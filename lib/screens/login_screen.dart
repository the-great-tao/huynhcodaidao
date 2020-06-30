import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          accentColor: Colors.white,
          cursorColor: Colors.white,
          buttonColor: Colors.amber.withAlpha(240),
          textTheme: TextTheme(
            button: TextStyle(
              fontSize: 18,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              fontSize: 18,
            ),
            contentPadding: EdgeInsets.all(20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9999),
              borderSide: BorderSide(
                width: 1,
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9999),
              borderSide: BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login_screen_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(80, 60, 80, 60),
                  child: Image(
                    image: AssetImage('assets/login_screen_logo.png'),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amberAccent,
                        blurRadius: 30,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: Icon(
                        Icons.phone,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 80,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(
                        Icons.vpn_key,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 80,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 40, 40, 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
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
    );
  }
}
