import 'package:flutter/material.dart';
import 'theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  ArtTheme _selectedTheme = artThemes[0]; // Default to 'Pencil Drawn'
  Character _selectedCharacter = characters[0]; // Default to 'Snuggly Cat'

  ArtTheme get selectedTheme => _selectedTheme;
  Character get selectedCharacter => _selectedCharacter;

  void setTheme(ArtTheme theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void setCharacter(Character character) {
    _selectedCharacter = character;
    notifyListeners();
  }
}
