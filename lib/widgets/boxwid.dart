import 'package:flutter/material.dart';

class BoxWid extends StatelessWidget {
  const BoxWid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          //SizedBox Widget
            child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  <Widget>[
                SizedBox(
                  width: 90.0, height: 75.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Center(
                      child: Text('First',
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ),
                 SizedBox(
                    width: 90.0, height: 75.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Center(
                        child: Text('Second',
                        style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                ),
                SizedBox(
                    width: 90.0, height: 75.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Center(
                        child: Text('Third',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                ),
                SizedBox(
                    width: 90.0, height: 75.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Center(
                        child: Text('Forth',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                ),
              ]
            )
        )
    );
  }
}
