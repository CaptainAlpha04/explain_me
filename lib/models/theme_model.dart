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
      description: 'Hand-drawn sketches with a pencil style'),
  ArtTheme(
      name: 'Comic', description: 'Colorful comic book style illustrations'),
  ArtTheme(
      name: 'Anime',
      description: 'Japanese anime style with vibrant characters'),
  ArtTheme(
      name: 'Watercolor',
      description: 'Soft watercolor illustrations with artistic flair'),
];

// List of available characters
final List<Character> characters = [
  Character(
    name: 'Snuggly Cat',
    description: 'A cute, cuddly cat that loves to explain things',
    imagePath: 'assets/images/snuggly_cat.png',
  ),
  Character(
    name: 'Robot',
    description: 'A friendly robot with knowledge of all subjects',
    imagePath: 'assets/images/robot.png',
  ),
  Character(
    name: 'Puppy',
    description: 'An enthusiastic puppy that makes learning fun',
    imagePath: 'assets/images/puppy.png',
  ),
  Character(
    name: 'Tom with Noogler Hat',
    description: 'A curious character wearing the iconic Noogler hat',
    imagePath: 'assets/images/tom_noogler.png',
  ),
];
