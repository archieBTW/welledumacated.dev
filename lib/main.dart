import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wELl eDuMaCaTeD // mYsPaCe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFBF00FF),
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.courierPrimeTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const MySpacePage(),
    );
  }
}

class MySpacePage extends StatefulWidget {
  const MySpacePage({super.key});

  @override
  State<MySpacePage> createState() => _MySpacePageState();
}

class _MySpacePageState extends State<MySpacePage> {
  Offset mousePos = Offset.zero;
  final List<Particle> particles = [];

  void _updateMouse(PointerEvent details) {
    setState(() {
      mousePos = details.localPosition;
    });
    _spawnParticles();
  }

  void _spawnParticles() {
    for (int i = 0; i < 3; i++) {
      particles.add(
        Particle(
          pos: mousePos,
          vel: Offset(
            math.Random().nextDouble() * 4 - 2,
            -(math.Random().nextDouble() * 4 + 2),
          ),
          life: 1.0,
        ),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    // Animation loop for particles
    _startAnimation();
  }

  void _startAnimation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return false;
      setState(() {
        for (var i = particles.length - 1; i >= 0; i--) {
          particles[i].update();
          if (particles[i].life <= 0) {
            particles.removeAt(i);
          }
        }
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: _updateMouse,
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  margin: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111), // Dark grey container
                    border: Border.all(
                      color: const Color(0xFFBF00FF),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFBF00FF).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // Two Column Layout
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column
                          Expanded(flex: 1, child: _buildLeftColumn()),
                          const SizedBox(width: 20),
                          // Right Column
                          Expanded(flex: 2, child: _buildRightColumn()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Flame Particles Overlay
            IgnorePointer(
              child: CustomPaint(
                painter: ParticlePainter(particles),
                size: Size.infinite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'wELl eDuMaCaTeD',
          style: GoogleFonts.vt323(
            fontSize: 64,
            color: const Color(0xFFBF00FF),
            letterSpacing: 8,
          ),
        ),
        // Container(
        //   width: double.infinity,
        //   color: const Color(0xFFBF00FF),
        //   padding: const EdgeInsets.symmetric(vertical: 5),
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //         Text(
        //           ' ' *
        //               3,
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/icons/132012541.png',
          width: 300,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        _buildBoxTitle('Contacting well edumacated'),
        _buildBox(
          Column(
            children: [
              _buildLink('View About Page', 'https://github.com/archieBTW'),
              _buildLink('Browse Our Apps', 'https://github.com/archieBTW'),
              _buildLink('Send Message', 'mailto:billy@billyrigdon.dev'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildBoxTitle('Interests'),
        _buildBox(
          Text(
            'General: Open Source, Linux, Theology, Health, Car, Music, Flutter.\nMusic: archBTW., MF DOOM',
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        _buildBoxTitle('Mood: Grateful'),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('well edumacated\'s Blurbs'),
        const Text(
          'About me: I\'m archie and this is my pretend company where I make cool stuff.',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('Top Friends (Our Apps)'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildFriend(
              'fyr',
              Icons.computer,
              'https://github.com/archieBTW/fyrDE',
            ),
            _buildFriend('archBTW.', Icons.music_note, 'https://archBTW.sh'),
            _buildFriend('bybl', Icons.book, 'https://bybl.dev'),
            _buildFriend(
              'libretrac',
              Icons.favorite,
              'https://github.com/archieBTW/libretrac',
            ),
            _buildFriend(
              'trustfall',
              Icons.videogame_asset,
              'https://github.com/archieBTW/trustfall',
            ),
            _buildFriend(
              'olive branch',
              Icons.newspaper,
              'https://github.com/archieBTW/theolivebranch',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBoxTitle(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFBF00FF),
      padding: const EdgeInsets.all(5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBox(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBF00FF)),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFBF00FF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(color: Color(0xFFBF00FF)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLink(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFBF00FF),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildFriend(String name, IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBF00FF)),
            ),
            child: Icon(icon, color: const Color(0xFFBF00FF)),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 10, color: Color(0xFFBF00FF)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Particle {
  Offset pos;
  Offset vel;
  double life;
  double decay = 0.03 + math.Random().nextDouble() * 0.02;

  Particle({required this.pos, required this.vel, required this.life});

  void update() {
    pos += vel;
    life -= decay;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.screen;
    for (var p in particles) {
      if (p.life <= 0) continue;
      // Purple hue
      paint.color = HSLColor.fromAHSL(p.life, 280, 1.0, 0.5).toColor();
      canvas.drawCircle(p.pos, (1.0 - (1.0 - p.life)) * 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
