import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/theme_model.dart';
import '../services/gemini_service.dart';
import '../widgets/hand_drawn_button.dart';

class ResultScreen extends StatefulWidget {
  final String query;
  final ArtTheme theme;
  final Character character;

  const ResultScreen({
    super.key,
    required this.query,
    required this.theme,
    required this.character,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GeminiService _geminiService = GeminiService();
  final PageController _pageController = PageController();
  bool _isLoading = true;
  List<SlideContent> _slides = [];
  String _error = '';
  int _currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _generateContent();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _generateContent() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _slides = [];
    });

    try {
      // Generate slides with text embedded in images
      final slides = await _geminiService.generateExplanation(
        widget.query,
        widget.theme,
        widget.character,
      );

      setState(() {
        _slides = slides;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Explain Me: ${widget.query}',
          style: GoogleFonts.gloriaHallelujah(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? _buildErrorWidget()
              : _buildSlideshowContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.gloriaHallelujah(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _error,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            HandDrawnButton(
              text: 'Try Again',
              onPressed: _generateContent,
              backgroundColor: Colors.blue[100],
              textColor: Colors.blue[800],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideshowContent() {
    if (_slides.isEmpty) {
      return Center(
        child: Text(
          'No content generated. Try again with a different query.',
          style: GoogleFonts.gloriaHallelujah(
            fontSize: 18,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        // Header with theme and character info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Character image placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.grey[400]),
                ),
                const SizedBox(width: 15),
                // Character and theme info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Narrated by ${widget.character.name}',
                        style: GoogleFonts.gloriaHallelujah(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'In ${widget.theme.name} style',
                        style: GoogleFonts.gloriaHallelujah(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Slide counter
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    '${_currentSlide + 1}/${_slides.length}',
                    style: GoogleFonts.gloriaHallelujah(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Slideshow - simplified to only show images with embedded text
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentSlide = index;
              });
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: slide.imageBase64 != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.memory(
                            base64Decode(slide.imageBase64!),
                            fit: BoxFit.contain,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Image generation failed. Please try again.',
                                  style: GoogleFonts.gloriaHallelujah(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ),

        // Navigation controls
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HandDrawnButton(
                text: 'Previous',
                onPressed: _currentSlide > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : () {},
                backgroundColor:
                    _currentSlide > 0 ? Colors.grey[200] : Colors.grey[100],
                textColor:
                    _currentSlide > 0 ? Colors.grey[800] : Colors.grey[400],
              ),
              HandDrawnButton(
                text: 'Search Again',
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.blue[100],
                textColor: Colors.blue[800],
              ),
              HandDrawnButton(
                text: 'Next',
                onPressed: _currentSlide < _slides.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : () {},
                backgroundColor: _currentSlide < _slides.length - 1
                    ? Colors.grey[200]
                    : Colors.grey[100],
                textColor: _currentSlide < _slides.length - 1
                    ? Colors.grey[800]
                    : Colors.grey[400],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
