import 'package:flutter/material.dart';

class HeroAnimationsPage extends StatelessWidget {
  final List<String> images = [
    'assets/image_hero1.jpeg',
    'assets/image_hero2.png',
    'assets/image_hero3.jpeg',
    'assets/image_hero4.jpg',
    'assets/image_hero5.jpeg',
    'assets/image_hero6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hero Animations',
          style: TextStyle(
            color: Colors.purpleAccent.shade200,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => HeroDetailPage(imagePath: images[index]),
                  ),
                );
              },
              child: Hero(
                tag: 'hero-image-$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HeroDetailPage extends StatelessWidget {
  final String imagePath;

  HeroDetailPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hero Animation Detail',
          style: TextStyle(
            color: Colors.purpleAccent.shade200,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'hero-image-${imagePath.hashCode}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
