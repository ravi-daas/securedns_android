import 'package:flutter/material.dart';

class CyberTipsView extends StatelessWidget {
  const CyberTipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
