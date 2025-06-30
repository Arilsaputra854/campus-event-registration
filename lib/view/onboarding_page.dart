import 'package:campus_event_registration/view/login_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Selamat Datang!',
      'subtitle': 'Ayo mulai perjalanan serumu bersama aplikasi kami!',
      'image': 'https://via.placeholder.com/300x200'
    },
    {
      'title': 'Eksplorasi Fitur',
      'subtitle': 'Nikmati berbagai fitur keren dan bermanfaat.',
      'image': 'https://via.placeholder.com/300x200'
    },
    {
      'title': 'Gabung Sekarang!',
      'subtitle': 'Login dan mulai petualanganmu hari ini.',
      'image': 'https://via.placeholder.com/300x200'
    },
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
      
    }
  }

  Widget _buildPageContent(Map<String, String> page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(page['image']!, height: 200),
        const SizedBox(height: 40),
        Text(
          page['title']!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          page['subtitle']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildPageContent(_pages[index]),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                width: _currentIndex == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext,
                child: Text(_currentIndex == _pages.length - 1 ? 'Mulai' : 'Lanjut'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
