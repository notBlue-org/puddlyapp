import 'package:driversapp/screens/app/home_page.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessState();
}

class _SuccessState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptySection(
            emptyImg: 'assets/images/success.gif',
            emptyMsg: 'Success !!',
          ),
          const SubTitle(
            subTitleText: 'Your have sucessfully delivered this order',
          ),
          ElevatedButton(
            child: const Text('Go back Home'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String subTitleText;
  const SubTitle({
    Key? key,
    required this.subTitleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Text(
        subTitleText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18.0,
          color: Color(0xFF808080),
        ),
      ),
    );
  }
}

class EmptySection extends StatelessWidget {
  final String emptyImg, emptyMsg;
  const EmptySection({
    Key? key,
    required this.emptyImg,
    required this.emptyMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(emptyImg),
            height: 150.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              emptyMsg,
              style: const TextStyle(fontSize: 20.0, color: Color(0xFF303030)),
            ),
          ),
        ],
      ),
    );
  }
}
