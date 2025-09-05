import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_mate/screens/components/colors.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:travel_mate/screens/components/sidemenu.dart';
import 'package:travel_mate/services/router_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  AnimationController? _waveController;
  AnimationController? _textAnimationController;
  AnimationController? _chartAnimationController;

  bool _showHeroText = true;
  double _heroTextOpacity = 1.0;
  double _heroTextHeight = 1.0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    const double threshold = 50.0; // Scroll threshold to hide/show text
    final double offset = _scrollController.offset;

    setState(() {
      if (offset > threshold && _showHeroText) {
        _showHeroText = false;
        _textAnimationController?.reverse();
        _heroTextOpacity = 0.0;
        _heroTextHeight = 0.0;
      } else if (offset <= threshold && !_showHeroText) {
        _showHeroText = true;
        _textAnimationController?.forward();
        _heroTextOpacity = 1.0;
        _heroTextHeight = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _waveController?.dispose();
    _textAnimationController?.dispose();
    _chartAnimationController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper method to ensure drawer is closed before navigation
  void _navigateAndCloseDrawer(String routeName) {
    // Close drawer if it's open
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop(); // Close the drawer
    }

    // Add a small delay to ensure drawer is fully closed
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.goNamed(routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideMenu(),
      body: Stack(
        children: [
          // Background with gradient blobs and blur
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Gradient Blobs
                Positioned(
                  top: -100,
                  left: -80,
                  child: _buildBlob(const [
                    Color(0xFFd4145a),
                    Color(0xFFfbb03b),
                  ], 300),
                ),

                // Blur Layer
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
                  child: Container(color: black.withOpacity(0.25)),
                ),

                // Wave Transition behind app bar
                if (_waveController != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _waveController!,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: WavePainter(
                            animationValue: _waveController!.value,
                            gradientColors: [
                              const Color(0xFFd4145a).withOpacity(0.3),
                              const Color(0xFF662d8c).withOpacity(0.4),
                              const Color(0xFFfbb03b).withOpacity(0.2),
                            ],
                          ),
                          size: Size(MediaQuery.of(context).size.width, 200),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: Column(
              children: [
                // Sticky Header (Menu Bar + Hero Text + Search Bar)
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar (Menu Button + TravelMate)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Use the scaffold key to open drawer
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFd4145a),
                                    Color(0xFF662d8c),
                                    Color(0xFFfbb03b),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).goNamed(RouteConstants.notifications);
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFd4145a),
                                    Color(0xFF662d8c),
                                    Color(0xFFfbb03b),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              "TravelMate",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Animated Hero Text
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _showHeroText ? 120 : 0,
                        curve: Curves.easeInOut,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _heroTextOpacity,
                          child: Container(
                            padding: const EdgeInsets.only(top: 40),
                            child: const Text(
                              'Wanna travel?\nWe got you!',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: white,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Spacing that adjusts based on hero text visibility
                      SizedBox(height: _showHeroText ? 24 : 20),

                      // Search Bar
                      GestureDetector(
                        onTap: () {
                          // Always close the drawer before navigating
                          if (_scaffoldKey.currentState?.isDrawerOpen == true) {
                            Navigator.of(context).pop();
                            Future.delayed(
                              const Duration(milliseconds: 150),
                              () {
                                if (mounted) {
                                  context.goNamed(RouteConstants.chatHome);
                                }
                              },
                            );
                          } else {
                            context.goNamed(RouteConstants.chatHome);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Search...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _navigateAndCloseDrawer(
                                    RouteConstants.voiceAssistant,
                                  );
                                },
                                child: const Icon(
                                  Icons.mic,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // AI Tools Grid
                        SizedBox(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildAIToolCard(
                                'Travel\nSafety',
                                Icons.edit_outlined,
                                onTap: () {
                                  context.goNamed(
                                    RouteConstants.voiceAssistant,
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAIToolCard(
                                'Smart\nDestination',
                                Icons.image_outlined,
                                onTap: () {
                                  // context.goNamed(RouteConstants.videoAssistant);
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAIToolCard(
                                'Smart\nNavigation',
                                Icons.auto_awesome_outlined,
                                onTap: () {
                                  // context.goNamed(RouteConstants.screenAssistant);
                                },
                              ),
                              const SizedBox(width: 12),
                              _buildAIToolCard(
                                'Travel\nCommunity',
                                Icons.code_outlined,
                                onTap: () {
                                  // context.goNamed(RouteConstants.screenAssistant);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Travel Statistics Graph Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Travel Statistics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFd4145a,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFd4145a,
                                        ).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Text(
                                      'Last 6 months',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Chart Legend
                              Row(
                                children: [
                                  _buildLegendItem(
                                    'Flights',
                                    const Color.fromARGB(255, 72, 236, 200),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildLegendItem(
                                    'Hotels',
                                    const Color.fromARGB(255, 41, 73, 199),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildLegendItem(
                                    'Activities',
                                    const Color(0xFF8B5CF6),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Animated Chart
                              SizedBox(
                                height: 150,
                                child: AnimatedBuilder(
                                  animation: _chartAnimationController!,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      painter: TravelBarChartPainter(
                                        animationValue:
                                            _chartAnimationController!.value,
                                      ),
                                      size: const Size(double.infinity, 150),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Month labels
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug']
                                        .map(
                                          (month) => Text(
                                            month,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white.withOpacity(
                                                0.6,
                                              ),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // History Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _navigateAndCloseDrawer(RouteConstants.history);
                              },
                              child: Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // History Items
                        _buildHistoryItem(
                          'Flight to Paris',
                          '2 minutes ago',
                          Icons.flight_takeoff,
                          const Color(0xFFEC4899),
                        ),
                        _buildHistoryItem(
                          'Hotel booking updated',
                          '15 minutes ago',
                          Icons.hotel,
                          const Color(0xFF8B5CF6),
                        ),
                        _buildHistoryItem(
                          'Emergency contact added',
                          '1 day out',
                          Icons.contact_emergency,
                          const Color(0xFFF59E0B),
                        ),

                        // Add more history items to demonstrate scrolling
                        _buildHistoryItem(
                          'Travel insurance purchased',
                          '2 days ago',
                          Icons.shield,
                          const Color(0xFF10B981),
                        ),
                        _buildHistoryItem(
                          'Passport updated',
                          '1 week ago',
                          Icons.card_travel,
                          const Color(0xFF3B82F6),
                        ),
                        _buildHistoryItem(
                          'Visa application submitted',
                          '2 weeks ago',
                          Icons.assignment,
                          const Color(0xFF6366F1),
                        ),

                        // Add bottom padding for better scrolling experience
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBlob(List<Color> colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
          center: Alignment.center,
          radius: 0.7,
        ),
      ),
    );
  }

  Widget _buildAIToolCard(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.arrow_outward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    return GestureDetector(
      onTap: () {
        // Handle history item tap - you can add specific routes here
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// Travel Bar Chart Painter matching the design in your image
class TravelBarChartPainter extends CustomPainter {
  final double animationValue;

  TravelBarChartPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Bar data (heights as percentages from 0.0 to 1.0)
    final List<double> barHeights = [0.6, 0.4, 0.8, 0.7, 0.5, 0.9, 0.6];

    // Alternating colors: dark blue and cyan
    final List<Color> barColors = [
      const Color(0xFF1E3A8A), // Dark blue
      const Color(0xFF1E3A8A), // Dark blue
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF1E3A8A), // Dark blue
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF1E3A8A), // Dark blue
    ];

    final double barWidth = size.width / (barHeights.length * 1.8);
    final double spacing = barWidth * 0.8;
    final double maxBarHeight = size.height * 0.8;

    for (int i = 0; i < barHeights.length; i++) {
      final double barHeight = maxBarHeight * barHeights[i] * animationValue;
      final double x = (i * (barWidth + spacing)) + spacing * 0.5;
      final double y = size.height - barHeight;

      // Create rounded rectangle for each bar
      final RRect barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(6),
      );

      paint.color = barColors[i];
      canvas.drawRRect(barRect, paint);

      // Add subtle highlight on top of each bar
      if (animationValue > 0.8) {
        paint.color = Colors.white.withOpacity(0.2);
        final RRect highlightRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight * 0.3),
          const Radius.circular(6),
        );
        canvas.drawRRect(highlightRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is TravelBarChartPainter &&
        oldDelegate.animationValue != animationValue;
  }
}

// Keep your existing WavePainter class unchanged
class WavePainter extends CustomPainter {
  final double animationValue;
  final List<Color> gradientColors;

  WavePainter({required this.animationValue, required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.6);

    for (int i = 0; i < 1; i++) {
      final waveHeight = 20 + (i * 20);
      final frequency = 0.02 + (i * 0.01);
      final phaseShift = animationValue * 2 * math.pi + (i * math.pi / 3);

      for (double x = 0; x <= size.width; x += 1) {
        final y =
            size.height * 0.6 +
            waveHeight * math.sin((x * frequency) + phaseShift) +
            (waveHeight / 2) * math.cos((x * frequency * 2) + phaseShift);

        if (x == 0) {
          path.lineTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
