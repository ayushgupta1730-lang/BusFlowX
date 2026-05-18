import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lvhrwwtsqjmhaldssdvs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx2aHJ3d3RzcWptaGFsZHNzZHZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzMzMwODIsImV4cCI6MjA4OTkwOTA4Mn0.sRRhI4icsnLe9nFc-le3tSj7YZDMGhwx_9WaneNMmfU',
  );

  runApp(BusFlowXApp());
}

class BusFlowXApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BusFlowX',
      home: AuthGate(),
    );
  }
}

/// 🔥 AUTO LOGIN CHECK
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {

        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController idController = TextEditingController();
  String selectedDomain = "@geu.ac.in";

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color.lerp(
                    Color(0xFF1A2980), // blue
                    Color(0xFF26D0CE), // sky blue
                    _controller.value,
                  )!,
                  Color.lerp(
                    Color(0xFFB21F1F), // red
                    Color(0xFFFFD54F), // yellow
                    _controller.value,
                  )!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            child: Stack(
              children: [

                /// 🔥 FLOATING LIGHT BLOBS (SUBTLE MOTION)
                Positioned(
                  top: 60,
                  left: -30,
                  child: _bubble(Colors.yellow.withOpacity(0.25), 140),
                ),
                Positioned(
                  bottom: 80,
                  right: -20,
                  child: _bubble(Colors.blue.withOpacity(0.25), 160),
                ),
                Positioned(
                  top: 250,
                  right: 40,
                  child: _bubble(Colors.red.withOpacity(0.2), 90),
                ),

                /// MAIN CONTENT
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        /// 🔥 TITLE
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "BusFlow",
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: "X",
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Making Campus Mobility Seamless",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            letterSpacing: 1.2,
                          ),
                        ),

                        SizedBox(height: 50),

                        /// 🔥 GLASS INPUT
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white24),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [

                              Expanded(
                                child: TextField(
                                  controller: idController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter College ID",
                                    hintStyle:
                                    TextStyle(color: Colors.white60),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDomain,
                                  dropdownColor: Color(0xFF1A1A2E),
                                  style: TextStyle(color: Colors.white),
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white70),
                                  items: ["@geu.ac.in", "@gehu.ac.in"]
                                      .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() => selectedDomain = val!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        /// 🔥 BUTTON (ENERGETIC BUT CLEAN)
                        GestureDetector(
                          onTap: () async {
                            String id = idController.text.trim();

                            if (id.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Enter valid ID")),
                              );
                              return;
                            }

                            String email = id + selectedDomain;

                            try {
                              await Supabase.instance.client.auth
                                  .signInWithOtp(
                                email: email,
                                emailRedirectTo: null,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpScreen(email: email),
                                ),
                              );

                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error sending OTP")),
                              );
                            }
                          },
                          child: Container(
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFD54F),
                                  Color(0xFFFF8F00),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.5),
                                  blurRadius: 25,
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Start Your Journey 🚀",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Earn points • Unlock ranks • Ride smarter 🎮",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bubble(Color color, double size) {
    return AnimatedContainer(
      duration: Duration(seconds: 3),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String email;

  OtpScreen({required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int seconds = 300;

  List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (seconds > 0) {
        setState(() => seconds--);
        return true;
      }
      return false;
    });
  }

  String formatTime() {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  /// ✅ SAFE VERIFY FUNCTION
  bool isVerifying = false;

  Future<void> verifyOtp() async {
    String otp = controllers.map((c) => c.text).join();

    if (otp.length == 6 && !isVerifying) {
      isVerifying = true;

      try {
        await Supabase.instance.client.auth.verifyOTP(
          email: widget.email,
          token: otp,
          type: OtpType.email,
        );

        // ✅ NAVIGATE TO DASHBOARD
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
              (route) => false,
        );

      } catch (e) {
        print("VERIFY ERROR: $e");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP")),
        );

        isVerifying = false; // allow retry if failed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF2C5364),
              Color(0xFF1C92D2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),

                SizedBox(height: 20),

                Text(
                  "Enter OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Sent to ${widget.email}",
                  style: TextStyle(color: Colors.white70),
                ),

                SizedBox(height: 40),

                /// 🔥 OTP BOXES (UNCHANGED)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),

                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            if (index < 5) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            } else {
                              FocusScope.of(context).unfocus();
                              await verifyOtp();
                            }
                          } else {
                            if (index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index - 1]);
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: 20),

                Text(
                  "Expires in ${formatTime()}",
                  style: TextStyle(color: Colors.white70),
                ),

                SizedBox(height: 10),

                /// ✅ FIXED RESEND (WITH ERROR HANDLING)
                GestureDetector(
                  onTap: seconds == 0
                      ? () async {
                    try {
                      await Supabase.instance.client.auth.signInWithOtp(
                        email: widget.email,
                      );

                      // ONLY if success
                      setState(() => seconds = 300);
                      startTimer();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("OTP sent successfully")),
                      );

                    } catch (e) {
                      print("RESEND ERROR: $e");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error sending OTP")),
                      );
                    }
                  }
                      : null,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      color:
                      seconds == 0 ? Colors.yellow : Colors.white38,
                    ),
                  ),
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: verifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text("Verify OTP"),
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

/// 🔥 DASHBOARD SCREEN
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔥 HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "BusFlowX",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                        );
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                /// 👋 USER GREETING
                Text(
                  "Welcome 👋",
                  style: TextStyle(color: Colors.white70),
                ),

                Text(
                  "${user?.email}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 25),

                /// 🎮 RANK CARD
                Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFD54F),
                        Color(0xFFFF8F00),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Rank",
                        style: TextStyle(color: Colors.black87),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "Fresh Rider 🚶",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 12),

                      /// 🔥 XP BAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.3, // later dynamic
                          minHeight: 8,
                          backgroundColor: Colors.black12,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "30 / 100 XP",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                /// 🚌 BUS SECTION
                Text(
                  "Available Buses",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 15),

                Expanded(
                  child: ListView(
                    children: [

                      _busCard("GEU Route A", Colors.yellow),
                      _busCard("GEHU Route B", Colors.redAccent),
                      _busCard("City Express", Colors.blueAccent),
                      _busCard("Campus Shuttle", Colors.white70),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _busCard(String title, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.25),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ],
      ),

      child: Row(
        children: [

          /// 🚌 ICON
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_bus, color: color),
          ),

          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Arriving in 5 min",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),

          Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}