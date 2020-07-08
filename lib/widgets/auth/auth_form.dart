import 'package:flutter/material.dart';

import 'custom_button.dart';

enum AuthMode {
  LogIn,
  SingUp,
}

class AuthForm extends StatefulWidget {
  final Future<void> Function(
          Map<String, String> values, AuthMode currentMode, BuildContext ctx)
      submitFn;

  AuthForm(this.submitFn);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AuthMode currentMode = AuthMode.LogIn;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> values = {
    'email': '',
    'username': '',
    'password': '',
  };
  final Map<String, FocusNode> focusNodes = {
    'email': FocusNode(),
    'username': FocusNode(),
    'password': FocusNode(),
  };
  AnimationController _animationController;
  Animation<double> _fadeAnimation;
  Animation<Offset> _slideAnimation;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  dispose() {
    super.dispose();
    if (_animationController != null) {
      _animationController.dispose();
    }
  }

  void _switchAuthMode() {
    if (currentMode == AuthMode.LogIn) {
      setState(() {
        currentMode = AuthMode.SingUp;
      });
      _animationController.forward();
    } else {
      setState(() {
        currentMode = AuthMode.LogIn;
      });
      _animationController.reverse();
    }
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    var isValidae = _formKey.currentState.validate();
    if (!isValidae) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _formKey.currentState.save();
    await widget.submitFn(values, currentMode, context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15),
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    currentMode == AuthMode.LogIn ? 'LogIn' : 'SignUp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    focusNode: focusNodes['email'],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.alternate_email),
                    ),
                    validator: (val) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)) {
                        return null;
                      }
                      return 'please enter valide email';
                    },
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(
                      currentMode == AuthMode.LogIn
                          ? focusNodes['password']
                          : focusNodes['username'],
                    ),
                    onSaved: (val) {
                      values['email'] = val.trim();
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AnimatedContainer(
                    duration: Duration(
                      milliseconds: 1000,
                    ),
                    curve: Curves.fastOutSlowIn,
                    constraints: BoxConstraints(
                        minHeight: currentMode == AuthMode.SingUp ? 60 : 0,
                        maxHeight: currentMode == AuthMode.SingUp ? 120 : 0),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: currentMode == AuthMode.LogIn
                            ? null
                            : TextFormField(
                                key: ValueKey('userName'),
                                focusNode: focusNodes['username'],
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  icon: Icon(Icons.person_outline),
                                ),
                                validator: (val) {
                                  if (val.isEmpty || val.length < 5) {
                                    return 'username must be at least 5 characters';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context)
                                        .requestFocus(focusNodes['password']),
                                onSaved: (val) {
                                  values['username'] = val.trim();
                                },
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    focusNode: focusNodes['password'],
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock_outline),
                    ),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'password must be at least 7 characters';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      values['password'] = val.trim();
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LayoutBuilder(
                    builder: (ctx, constraints) => isLoading
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: CircularProgressIndicator(),
                          ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.5,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: constraints.maxWidth * 0.3),
                                      child: Text(
                                        currentMode == AuthMode.LogIn
                                            ? 'Haven\'t an account? '
                                            : 'have an account? ',
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width: constraints.maxWidth * 0.2,
                                        padding: const EdgeInsets.only(
                                            left: 2, right: 15),
                                        child: Text(
                                          currentMode == AuthMode.LogIn
                                              ? 'SignUp'
                                              : 'LogIn',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      onTap: _switchAuthMode,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomButton(
                                  text: currentMode == AuthMode.LogIn
                                      ? 'LogIn'
                                      : 'SignUp',
                                  icon: Icons.arrow_forward_ios,
                                  onPress: _submit,
                                ),
                              )
                            ],
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
