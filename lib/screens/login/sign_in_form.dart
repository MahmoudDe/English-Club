import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            'Sign-in',
            style:
            TextStyle(color: Theme.of(context).primaryColor, fontSize: 60),
          ),
          Image.asset(
            'assets/images/Reading glasses-rafiki.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 30),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter user name',
                      labelStyle: TextStyle(color: Colors.deepPurple),
                      hintText: 'user name',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      // Add padding
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                        BorderSide(color: Colors.green.shade700, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the user name';
                      }
                      return null;
                    },
                  ),
                ),
              // Add padding
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            child: TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Enter the password',
                labelStyle: TextStyle(color: Colors.deepPurple),
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // Add padding
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                  BorderSide(color: Colors.green.shade700, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter the password';
                }
                return null;
              },
            ),
          ),
              ],
            ),
          ),
          SizedBox(height: 20), // Add padding
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.orange,
                    // background color
                    foregroundColor: Colors.white,
                    // text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(30), // rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 110, vertical: 10), // padding
                  ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                  child: Text(
                    'Sign-in',
                    style: TextStyle(fontSize: 18, fontFamily: 'Avenir'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
