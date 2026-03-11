import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FraseDoDiaApp());
}

class FraseDoDiaApp extends StatelessWidget {
  const FraseDoDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frases do dia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
      home: const FrasesDoDiaHome(),
    );
  }
}

class FrasesDoDiaHome extends StatefulWidget {
  const FrasesDoDiaHome({super.key});

  @override
  State<FrasesDoDiaHome> createState() => _FrasesDoDiaHomeState();
}

class _FrasesDoDiaHomeState extends State<FrasesDoDiaHome> with SingleTickerProviderStateMixin{
  final Random _random = Random();
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _images = [
    'assets/images/amigos_no_parque.jpg',
    'assets/images/familia_feliz.jpg',
    'assets/images/mulher_com_cachorro.jpg',
  ];

  final List<Map<String, String>> _quotes = [
    {
      'frase': 'A jornada de mil milhas começa com um único passo.',
      'autor': '— Lao Tsé',
    },
    {
      'frase': 'Seja a mudança que você quer ver no mundo.',
      'autor': '— Mahatma Gandhi',
    },
    {
      'frase': 'A vida é aquilo que acontece enquanto você faz outros planos.',
      'autor': '— John Lennon',
    },
  ];

  final List<Color> _backgroundColors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.orange,
  ];

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  void _sortNewQuote(){
    setState(() {
      int newIndex;
      do {
        newIndex = _random.nextInt(_quotes.length);
      } while (newIndex == _currentIndex && _quotes.length > 1);
      _currentIndex = newIndex;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final quote = _quotes[_currentIndex];
    final backgroundColor = _backgroundColors[_currentIndex % _backgroundColors.length];
    final image = _images[_currentIndex % _images.length];


    return Scaffold(
      body: AnimatedContainer( 
        duration: const Duration(milliseconds: 800), 
        decoration: BoxDecoration(
          gradient:LinearGradient( 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundColor, backgroundColor.withOpacity(0.7)],
          ),
        ),
        child: SafeArea( 
          child: Column( 
            children: [ 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column( 
                  children: [ 
                    Text(
                      'Frase do Dia',
                      style: TextStyle( 
                        fontSize: 26,
                        fontFamily: _currentIndex % 2 == 0 ? 'serif' : 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE8D5FF),
                        letterSpacing: 2,
                        shadows: [ 
                          Shadow( 
                            blurRadius: 4,
                            color: Colors.purple.withOpacity(0.8),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.transparent, Color(0xFFAA80FF), Colors.transparent],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // ── IMAGEM ──────────────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 4,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              image,
                              height: 260,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 260,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade900,
                                        Colors.indigo.shade900,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 64,
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Imagem ${_currentIndex + 1}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── FRASE ───────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '\u201C',
                                style: TextStyle(
                                  fontSize: 64,
                                  height: 0.6,
                                  color: const Color(0xFFAA80FF),
                                  fontFamily: 'serif',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                quote['frase']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFFF0E6FF),
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 1,
                                width: 60,
                                color: const Color(0xFFAA80FF),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                quote['autor']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  color: Color(0xFFAA80FF),
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: Center(
                  child: GestureDetector(
                    onTap: _sortNewQuote,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9B59B6), Color(0xFF6C3483)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9B59B6).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Nova Frase',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),





      ),
      
    );
  }
}
