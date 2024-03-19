import 'package:flutter/material.dart';
import 'package:project_manager/services/auth.dart';
import 'package:project_manager/shared/loading.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color.fromARGB(255, 180, 190, 200),
            body: _buildLayout(screenWidth),
          );
  }

  Widget _buildLayout(double screenWidth) {
    return screenWidth > 600
        ? _buildDesktopLayout()
        : _buildMobileLayout(screenWidth);
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
            child: Image.asset(
              'assets/signInImage.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.only(bottom: 200),
            child: _buildForm(),
          ),
        ),
      ],
    );
  }


Widget _buildMobileLayout(double screenWidth) {
  return SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Stack(
      children: [
        Container(
          color: Colors.transparent,
          child: Image.asset(
            'assets/signInImage.jpg',
            fit: BoxFit.fill, // Adjusted fit property
            height: MediaQuery.of(context).size.height, // Ensure full height
            width: MediaQuery.of(context).size.width, // Ensure full width
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: _buildForm(),
            ),
          ),
        ),
      ],
    ),
  );
}





  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100.0),
            Text(
              'Dobrodošli',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(4, 4),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ulogujte se na svoj nalog :',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(4, 4),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'E-Mail',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.email, color: Colors.black),
                filled: true,
                fillColor: Color.fromARGB(170, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white, // Border color when focused
                  ),
                ),
              ),
              validator: (val) => val!.isEmpty ? 'Unesi E-Mail' : null,
              onChanged: (val) {
                setState(() {
                  email = val; // Update email variable here
                });
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Lozinka',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                filled: true,
                fillColor: Color.fromARGB(170, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white, // White border color
                    width: 2.0, // Increased border width
                  ),
                ),
              ),
              style: TextStyle(color: Colors.black),
              validator: (val) =>
                  val!.length < 6 ? 'Unesi lozinku koja ima 6+ karaktera' : null,
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val; // Update password variable here
                });
              },
            ),
            SizedBox(height: 30.0),
            AnimatedSignInButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() => loading = true);
                  dynamic result =
                      await _auth.signInWithEmailPassword(email, password);

                  if (result == null) {
                    setState(() {
                      error = 'Could not sign in with those credentials';
                      loading = false;
                    });
                  }
                }
              },
              loading: loading,
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedSignInButton extends StatefulWidget {
  final Function onPressed;
  final bool loading;

  AnimatedSignInButton({required this.onPressed, required this.loading});

  @override
  _AnimatedSignInButtonState createState() => _AnimatedSignInButtonState();
}

class _AnimatedSignInButtonState extends State<AnimatedSignInButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.loading ? null : widget.onPressed as void Function()?,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10.0,
                      offset: Offset(5, 10),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: widget.loading ? null : widget.onPressed as void Function()?,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: widget.loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Uloguj se',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
