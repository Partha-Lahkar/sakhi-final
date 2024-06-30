import 'package:flutter/material.dart';

class ButtonScreen extends StatelessWidget {
  const ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 204, 216),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/places');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120, // Adjust size as needed
                    height: 160, // Adjust size as needed
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        image: AssetImage(
                            'lib/assets/findway.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Adjust spacing between image and text
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120, // Adjust size as needed
                    height: 160, // Adjust size as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        image: AssetImage(
                            'lib/assets/medicine.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Adjust spacing between image and text
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120, // Adjust size as needed
                    height: 160, // Adjust size as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        image: AssetImage(
                            'lib/assets/appointment.png'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Adjust spacing between image and text
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
