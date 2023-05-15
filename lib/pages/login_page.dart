import 'package:flutter/material.dart';
import 'package:sharedpreferences/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences prefs; //menginstansiasi sharedpref di lain tempat
  //jadi shared pref harus deklar di functuon yg asin

  @override
  void initState() {
    //gunanya utk menjalankan smwa fungsi saat pertama kali app dirun
    super.initState();
    checkIsLogin();
  }

  //panggil checkislogin didlm initstate
  void checkIsLogin() async {
    //ngecek pernah login ap blom
    prefs = await SharedPreferences.getInstance();
    bool? isLogin = (prefs.getString('datauser') != null) ? true : false;
    //jadi kalo username != null true bisa langsung masuk ke homepage
    //alias kalo dah ada data username maka langsung ke homepage

    //jadi sharedpref masuk sini krn buat ngecek, misal gada data username ya harus login sek
    //kalo ada data sharedpref biar bisa langsung masuk
    if (isLogin && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Login Page',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    //harus async karena pake sharedprefs
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    if (username == 'maizan' && password == '1234') {
                      await prefs.setString('datauser', username);
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      }
                    }
                  },
                  child: const Text('L O G I N'),
                ))
          ],
        ),
      ),
    );
  }
}
