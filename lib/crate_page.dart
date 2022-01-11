import 'package:flutter/material.dart';

class cratepage extends StatefulWidget {
  const cratepage({Key? key}) : super(key: key);

  @override
  _cratepageState createState() => _cratepageState();
}

class _cratepageState extends State<cratepage> {


  String dropdownValue = 'Safe Productions';
  String CrateRem= "23";
  var items = [
    'Safe Productions',
    'Temp Productions',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crate Mangment'),
      ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width, // Full Width of Screen
              height: 500.0, // Desired Height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    Text(
                        'Distributor',
                        style: TextStyle(
                            fontSize: 18.5)
                    ),
                    DropdownButton(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down,),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue){
                        setState(() {
                          dropdownValue=newValue!;
                        });
                      },
                    ),
              SizedBox(height: 10,),
                Text(
                    'Crates Recived',
                    style: TextStyle(
                      fontSize: 18.5)

                ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'The remianing Crates left are $CrateRem',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 32.0),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
                onChanged: (value) {
                  //Do something with this value
                },
              ),
                    SizedBox(height: 20.0),
                    MaterialButton(color:Colors.lightBlueAccent,
                        child:Text('Submit',style: TextStyle(color: Colors.white),),onPressed: (){

                    })
            ]),
              ),

        ),

    );
  }
}
