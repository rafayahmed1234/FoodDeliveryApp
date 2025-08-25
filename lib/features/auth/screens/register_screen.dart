import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth ko import karein
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An unknown error occurred.'), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose(); _emailController.dispose(); _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black),),),
      body: SingleChildScrollView(child: Center(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(key: _formKey, child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Images/cook_logo.png"), SizedBox(height: 20),
            Text("Hello! Create Account", style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Already have an account?", style: TextStyle(color: Color(0xFF6A7B8F), fontSize: 18)),
              TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())), child: Text("Sign in", style: TextStyle(color: Color(0xFFF3A938), fontSize: 18)))]),
            SizedBox(height: 20),
            TextFormField(controller: _nameController, validator: (v) => v!.isEmpty ? 'Please enter your name' : null, decoration: InputDecoration(hintText: "Your Name", hintStyle: TextStyle(color: Color(0xFFBCC7D3), fontSize: 16), filled: true, fillColor: Colors.grey[200], contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none))),
            SizedBox(height: 10),
            TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty || !v.contains('@') ? 'Please enter a valid email' : null, decoration: InputDecoration(hintText: "User Name or Email", hintStyle: TextStyle(color: Color(0xFFBCC7D3), fontSize: 16), filled: true, fillColor: Colors.grey[200], contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none))),
            SizedBox(height: 10),

            // <<< STEP 2: PASSWORD TEXTFIELD KO UPDATE KIYA GAYA HAI >>>
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // State se control hoga
              validator: (v) => v!.length < 6 ? 'Password must be 6+ characters' : null,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Color(0xFFBCC7D3), fontSize: 16),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: 15),
            SizedBox(height: 55, width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFF3A938), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 18)),
                )),
            Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Expanded(child: Divider(thickness: 1, color: Color(0xFFE8ECF4))), Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Text("OR", style: TextStyle(fontSize: 18, color: Color(0xFF6A7B8F)))), Expanded(child: Divider(thickness: 1, color: Color(0xFFE8ECF4)))])),
            SizedBox(height: 15),
            SizedBox(height: 55, width: 350, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[100], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Image.asset("assets/Images/facebook_logo.png"), SizedBox(width: 50), Text("Connect with Facebook", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600))]))),
            SizedBox(height: 10),
            SizedBox(height: 55, width: 350, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Image.asset("assets/Images/google_logo.png"), SizedBox(width: 50), Text("Connect with Google", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600))]))),
            SizedBox(height: 20)
          ],),),
      ),),),);
  }
}