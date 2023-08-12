import 'package:brain_voice/features/on_boarding/presentation/view/widgets/on_boarding.dart';
import 'package:flutter/material.dart';

class MainOnBoarding extends StatelessWidget {
  const MainOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          OnBoardingScreen(
            title: 'Hi there!',
            subTitle: '''Hello, I’m Hugo, Brain Voice’s virtual
    translator of sign language and
                          I will help you.''',
          ),
          OnBoardingScreen(
              title: 'About App',
              subTitle: '''
              Brain Voice uses AI to translate ASL,
                 Libras and helps you learn and 
                    understand sign language. ''',
          ),
          OnBoardingScreen(
            title: 'How it works',
            subTitle: '''
            The app uses Artificial Intelligence to
                 translate from English to ASL.
            
            It means that the characters can learn and
               improve the translations with phrases,
                               context and feedback''',
          ),
          OnBoardingScreen(
            title: 'Recommend!',
            subTitle: '''
            Sign language that consists of a single 
            movement can be stopped continuously.''',
          ),
        ],
      ),
    );
  }
}
