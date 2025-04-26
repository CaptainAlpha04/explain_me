class ArtTheme {
  final String name;
  final String description;

  ArtTheme({required this.name, required this.description});
}

class Character {
  final String name;
  final String description;
  final String imagePath; // Path to the character image for each art style

  Character(
      {required this.name, required this.description, required this.imagePath});
}

// List of available art themes
final List<ArtTheme> artThemes = [
  ArtTheme(
      name: 'Pencil Drawn',
      description:
          'Hand-drawn sketches with a pencil style, black pen on white background'),
  ArtTheme(
      name: 'Comic',
      description:
          'Colorful comic book style illustrations with bold lines, punchy colors, and dynamic poses'),
  ArtTheme(
      name: 'Anime',
      description:
          'Modern Anime style with vibrant characters, colorful and dynamic'),
  ArtTheme(
      name: 'Watercolor',
      description:
          'Soft watercolor illustrations with artistic flairs and textures, blending colors'),
];

// List of available characters
final List<Character> characters = [
  Character(
    name: 'Tiny Cat',
    description: 'A tiny cute, cuddly cat',
    imagePath: 'assets/images/snuggly_cat.png',
  ),
  Character(
    name: 'Curious Robot',
    description: 'A friendly robot with wheels',
    imagePath: 'assets/images/robot.png',
  ),
  Character(
    name: 'Dancing puppy',
    description: 'An enthusiastic puppy',
    imagePath: 'assets/images/puppy.png',
  ),
  Character(
    name: 'Tom Noogler',
    description: 'A curious character wearing the iconic Noogler hat',
    imagePath: 'assets/images/tom_noogler.png',
  ),
];
