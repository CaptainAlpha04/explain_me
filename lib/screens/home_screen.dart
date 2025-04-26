import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/theme_provider.dart';
import '../models/theme_model.dart';
import '../widgets/hand_drawn_button.dart';
import '../widgets/character_display.dart';
import '../widgets/floating_example.dart';
import '../widgets/top_generation_item.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showThemeSelector = false;
  bool _showCharacterSelector = false;

  // Example prompts for suggestions
  final List<String> _examplePrompts = [
    "explain neural networks",
    "explain gravity",
    "explain photosynthesis",
    "explain quantum computing",
    "explain black holes",
    "explain climate change",
    "explain blockchain",
    "explain relativity",
    "explain DNA",
    "explain internet of things",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            query: query,
            theme: themeProvider.selectedTheme,
            character: themeProvider.selectedCharacter,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // SVG Cat Logo above the title (smaller without border)
              // SizedBox(
              //   height: 120,
              //   width: 120,
              //   child: SvgPicture.asset(
              //     'assets/images/pencil_cat.svg',
              //     height: 120,
              //     width: 120,
              //     // Fallback to a custom drawn character if the asset isn't available
              //     placeholderBuilder: (context) => CustomPaint(
              //       size: const Size(120, 120),
              //       painter: CatPainter(),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 20),

              // App Title with hand-drawn style
              Text(
                'Explain Me',
                style: GoogleFonts.gloriaHallelujah(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Concepts explained through stories',
                style: GoogleFonts.gloriaHallelujah(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 30),

              // Search input with hand-drawn style (directly under the title)
              Container(
                width: 600,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.gloriaHallelujah(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'What would you like me to explain?',
                    hintStyle:
                        GoogleFonts.gloriaHallelujah(color: Colors.grey[400]),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.grey[700]),
                      onPressed: () => _handleSearch(_searchController.text),
                    ),
                  ),
                  onSubmitted: _handleSearch,
                ),
              ),

              const SizedBox(height: 25),

              // Example suggestions (static, under search bar)
              Container(
                width: 600,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: _examplePrompts
                      .map((prompt) => FloatingExample(
                            text: prompt,
                            onTap: () => _handleSearch(prompt),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 40),

              // Theme and Character Selection Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HandDrawnButton(
                    text: 'Change Art Style',
                    onPressed: () {
                      setState(() {
                        _showThemeSelector = !_showThemeSelector;
                        _showCharacterSelector = false;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  HandDrawnButton(
                    text: 'Change Character',
                    onPressed: () {
                      setState(() {
                        _showCharacterSelector = !_showCharacterSelector;
                        _showThemeSelector = false;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Theme Selector
              if (_showThemeSelector)
                Container(
                  width: 600,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[400]!, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Art Style:',
                        style: GoogleFonts.gloriaHallelujah(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: artThemes
                            .map((theme) => InkWell(
                                  onTap: () {
                                    themeProvider.setTheme(theme);
                                    setState(() {
                                      _showThemeSelector = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          themeProvider.selectedTheme == theme
                                              ? Colors.blue.shade100
                                              : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            themeProvider.selectedTheme == theme
                                                ? Colors.blue
                                                : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      theme.name,
                                      style: GoogleFonts.gloriaHallelujah(
                                        fontSize: 16,
                                        color:
                                            themeProvider.selectedTheme == theme
                                                ? Colors.blue.shade800
                                                : Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

              // Character Selector
              if (_showCharacterSelector)
                Container(
                  width: 600,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[400]!, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Character:',
                        style: GoogleFonts.gloriaHallelujah(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: characters
                            .map((character) => InkWell(
                                  onTap: () {
                                    themeProvider.setCharacter(character);
                                    setState(() {
                                      _showCharacterSelector = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: themeProvider.selectedCharacter ==
                                              character
                                          ? Colors.green.shade100
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            themeProvider.selectedCharacter ==
                                                    character
                                                ? Colors.green
                                                : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      character.name,
                                      style: GoogleFonts.gloriaHallelujah(
                                        fontSize: 16,
                                        color:
                                            themeProvider.selectedCharacter ==
                                                    character
                                                ? Colors.green.shade800
                                                : Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              // Top Generations Section
              Container(
                width: size.width > 800 ? 800 : size.width * 0.9,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Generations',
                      style: GoogleFonts.gloriaHallelujah(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: 6, // Show 6 placeholder items
                      itemBuilder: (context, index) {
                        return const TopGenerationItem();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
