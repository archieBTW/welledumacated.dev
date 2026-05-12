import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'well edumacated',
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isMobile = screenWidth < 800;
                    return Container(
                      constraints: const BoxConstraints(maxWidth: 900),
                      margin: EdgeInsets.symmetric(
                        vertical: isMobile ? 10 : 40,
                        horizontal: isMobile ? 5 : 20,
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
                          _buildHeader(constraints.maxWidth),
                          const SizedBox(height: 20),

                          // Responsive Column Layout
                          if (isMobile)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfilePic(isMobile),
                                const SizedBox(height: 20),
                                _buildAboutSection(),
                                const SizedBox(height: 20),
                                const MusicPlayerWidget(),
                                const SizedBox(height: 20),
                                _buildContactSection(),
                                const SizedBox(height: 20),
                                _buildInterestsSection(),
                                const SizedBox(height: 20),
                                _buildMoodSection(),
                              ],
                            )
                          else
                            Column(
                              children: [
                                // Top Row: Profile Pic and About Section
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: _buildProfilePic(isMobile),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      flex: 2,
                                      child: _buildAboutSection(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Second Row: Contact/Interests/Mood and Music Player
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          _buildContactSection(),
                                          const SizedBox(height: 20),
                                          _buildInterestsSection(),
                                          const SizedBox(height: 20),
                                          _buildMoodSection(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    const Expanded(
                                      flex: 2,
                                      child: MusicPlayerWidget(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          _buildAppsSection(isMobile),
                        ],
                      ),
                    );
                  },
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

  Widget _buildHeader(double width) {
    double fontSize = width < 600 ? 40 : 64;
    return Column(
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '// well edumacated',
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                fontSize: fontSize,
                color: const Color(0xFFBF00FF),
                letterSpacing: width < 600 ? 4 : 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePic(bool isMobile) {
    return Center(
      child: Image.asset(
        'assets/icons/132012541.png',
        width: isMobile ? 200 : 300,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoxTitle('Contacting well edumacated'),
        _buildBox(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLink('Browse All Apps', 'https://github.com/archieBTW'),
              SizedBox(height: 10),
              _buildLink('Send Message', 'mailto:billy@billyrigdon.dev'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoxTitle('Interests'),
        _buildBox(
          const Text(
            'General: Open Source, Linux, Flutter, Theology, Cars, Music. \n\nMusic: archBTW., MF DOOM',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return _buildBoxTitle('Mood: Manic');
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('About well edumacated'),
        const Text(
          '\n\nI\'m archBTW and this is my pretend company where I make cool stuff with Flutter.\n\nI\'m also pretending it\'s my record label so here\'s my music too.\n\n//:);',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildAppsSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Apps'),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 3 : 6,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
          children: [
            _buildFriend('fyr', Icons.computer, 'https://fyr.software'),
            _buildFriend('archBTW.', Icons.music_note, 'https://archBTW.sh'),
            _buildFriend('bybl', Icons.book, 'https://bybl.dev'),
            _buildFriend('libretrac', Icons.favorite, 'https://libretrac.site'),
            _buildFriend(
              'olive branch',
              Icons.newspaper,
              'https://theolivebranch.press',
            ),
            _buildFriend(
              'beats by arch',
              Icons.headphones,
              'https://beatsby.archbtw.sh',
            ),
            _buildFriend('github', Icons.code, 'https://github.com/archieBTW'),
            _buildFriend(
              'violet apparition',
              Icons.album,
              'https://violetapparition.com',
            ),
            _buildFriend(
              'tiktok',
              Icons.video_library,
              'https://tiktok.com/@fyr.archbtw',
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

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentTrackIndex = 0;

  final List<Map<String, String>> _tracks = [
    {'name': 'almost intelligent', 'path': 'music/ai.wav'},
    {'name': 'crosstops', 'path': 'music/crosstops.wav'},
    {'name': 'c u next tuesday', 'path': 'music/cunt.wav'},
    {'name': 'drinking outta cups', 'path': 'music/cups.wav'},
    {'name': 'elixer', 'path': 'music/elixir.wav'},
    {'name': 'florence', 'path': 'music/florence.wav'},
    {
      'name': 'it seemed like a good idea at the time',
      'path': 'music/it_seemed_like_a_good_idea_at_the_time.wav',
    },
    {'name': 'you call this mercy?', 'path': 'music/mercy.wav'},
    {'name': 'midnight oil', 'path': 'music/midnight_oil.wav'},
    {
      'name': 'i may not be a smart man, but i know what love is',
      'path': 'music/smart_man.wav',
    },
    {
      'name': 'lets take it apart and put it back together',
      'path': 'music/take_it_apart.wav',
    },
    {'name': 'and that\'s how it happened', 'path': 'music/thats_how.wav'},
    {'name': 'third time\'s a charm', 'path': 'music/third_time.wav'},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.playing || state == PlayerState.paused) {
            _isBuffering = false;
          }
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => _position = newPosition);
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextTrack();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() => _isBuffering = true);
      final path = _tracks[_currentTrackIndex]['path']!;
      try {
        await _audioPlayer.setSource(AssetSource(path));
        await _audioPlayer.resume();
      } catch (e) {
        debugPrint("Audio Error: $e");
        if (mounted) setState(() => _isBuffering = false);
      }
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
      _isBuffering = false;
    });
  }

  Future<void> _nextTrack() async {
    await _audioPlayer.stop();
    final nextIndex = (_currentTrackIndex + 1) % _tracks.length;
    final path = _tracks[nextIndex]['path']!;

    setState(() {
      _currentTrackIndex = nextIndex;
      _isBuffering = true;
    });

    try {
      await _audioPlayer.setSource(AssetSource(path));
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Audio Error: $e");
      if (mounted) setState(() => _isBuffering = false);
    }
  }

  Future<void> _prevTrack() async {
    await _audioPlayer.stop();
    final prevIndex =
        (_currentTrackIndex - 1 + _tracks.length) % _tracks.length;
    final path = _tracks[prevIndex]['path']!;

    setState(() {
      _currentTrackIndex = prevIndex;
      _isBuffering = true;
    });

    try {
      await _audioPlayer.setSource(AssetSource(path));
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Audio Error: $e");
      if (mounted) setState(() => _isBuffering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Bar
        Container(
          width: double.infinity,
          color: const Color(0xFFBF00FF),
          padding: const EdgeInsets.all(5),
          child: const Text(
            'Music Player',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        // Main Player Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFBF00FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Now Playing
              Text(
                'NOW PLAYING: ${_tracks[_currentTrackIndex]['name']!}',
                style: const TextStyle(
                  color: Color(0xFFBF00FF),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Progress Bar
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 4,
                  ),
                  trackHeight: 1,
                  activeTrackColor: const Color(0xFFBF00FF),
                  inactiveTrackColor: const Color(0xFFBF00FF).withOpacity(0.2),
                  thumbColor: const Color(0xFFBF00FF),
                ),
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds > 0
                      ? _duration.inSeconds.toDouble()
                      : 100.0,
                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSimpleBtn('PREV', _prevTrack),
                  const Text(' | ', style: TextStyle(color: Color(0xFFBF00FF))),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildSimpleBtn(
                        _isBuffering
                            ? 'LOADING...'
                            : (_isPlaying ? 'PAUSE' : 'PLAY'),
                        _playPause,
                      ),
                    ],
                  ),
                  const Text(' | ', style: TextStyle(color: Color(0xFFBF00FF))),
                  _buildSimpleBtn('STOP', _stop),
                  const Text(' | ', style: TextStyle(color: Color(0xFFBF00FF))),
                  _buildSimpleBtn('NEXT', _nextTrack),
                ],
              ),
              const SizedBox(height: 15),
              // Playlist
              const Text(
                'PLAYLIST:',
                style: TextStyle(
                  color: Color(0xFFBF00FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Color(0xFFBF00FF)),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (context, index) {
                    final isCurrent = index == _currentTrackIndex;
                    return InkWell(
                      onTap: () async {
                        await _audioPlayer.stop();
                        final path = _tracks[index]['path']!;

                        setState(() {
                          _currentTrackIndex = index;
                          _isBuffering = true;
                        });

                        try {
                          await _audioPlayer.setSource(AssetSource(path));
                          await _audioPlayer.resume();
                        } catch (e) {
                          debugPrint("Audio Error: $e");
                          if (mounted) setState(() => _isBuffering = false);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Text(
                          '${index + 1}. ${_tracks[index]['name']!}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isCurrent
                                ? const Color(0xFFBF00FF)
                                : Colors.white70,
                            decoration: isCurrent
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBF00FF),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
