import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String seletedPortal = "None";
String tt = "";
Position? _currentPosition;

void test() async {
  var response = await http.get(Uri.parse('http://127.0.0.1:5000'));
  seletedPortal = json.decode(response.body).toString();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  static const TextStyle buttomNavbarText =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _buttomNavbarOptions = <Widget>[
    Text(
      'Home',
      style: buttomNavbarText,
    ),
    Text(
      'Business',
      style: buttomNavbarText,
    ),
    Text(
      'Settings',
      style: buttomNavbarText,
    ),
  ];

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementCounter() {
    _getCurrentPosition();
    setState(() {
      test();
      tt = _currentPosition.toString();
      _counter++;
    });
  }

  Widget TwoCardWidgets(
      String leftText, String rightText, double cardWidth, double cardHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        ElevatedCard(
          boxText: Text(
            leftText,
            style: Theme.of(context).textTheme.headline6,
          ),
          portalName: leftText,
          cardWidth: cardWidth,
          cardHeight: cardHeight,
        ),
        const Spacer(),
        ElevatedCard(
          boxText: Text(
            rightText,
            style: Theme.of(context).textTheme.headline6,
          ),
          portalName: rightText,
          cardWidth: cardHeight,
          cardHeight: cardHeight,
        ),
        const Spacer(),
      ],
    );
  }

  List<String> names = [
    "Regular\nCheckup",
    "Doctor",
    "Lab Results",
    "Consult\nSpecialist",
    // "Regular\nCheckup",
    // "Doctor",
    // "Lab Results",
    // "Consult\nSpecialist",
  ];

  List<Widget> getPortal(double squareCardWidth) {
    List<Widget> portals = [];
    for (int i = 0; i < names.length - names.length % 2; i += 2) {
      portals.add(TwoCardWidgets(
          names[i], names[i + 1], squareCardWidth, squareCardWidth));
    }
    return portals;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    double squareCardWidth = width / 2 - 40;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ...getPortal(squareCardWidth),
              _buttomNavbarOptions[_selectedIndex],
              Text(
                'Portal Name: $seletedPortal',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'Count : $_counter',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                'Location : $tt',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 38, 64, 91),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ElevatedCard extends StatefulWidget {
  int count = 0;
  Text boxText;
  String portalName;
  double cardWidth, cardHeight;
  ElevatedCard(
      {Key? key,
      required this.boxText,
      required this.cardWidth,
      required this.cardHeight,
      required this.portalName})
      : super(key: key);
  @override
  _ElevatedCard createState() => _ElevatedCard();
}

class _ElevatedCard extends State<ElevatedCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ElevatedButton(
            child: SizedBox(
              width: widget.cardWidth,
              height: widget.cardHeight,
              child: Center(child: widget.boxText),
            ),
            onPressed: () {
              setState(() {
                // seletedPortal = widget.portalName;
                widget.count++;
                widget.boxText = Text(
                  '${widget.portalName} ${widget.count}',
                  style: Theme.of(context).textTheme.headline6,
                );
              });
            }),
      ),
    );
  }
}

// class ElevatedCard extends StatelessWidget {
//   Text boxText;
//   String portalName;
//   double cardWidth, cardHeight;
//   ElevatedCard(
//       {Key? key,
//       required this.boxText,
//       required this.cardWidth,
//       required this.cardHeight,
//       required this.portalName})
//       : super(key: key);
//   void changePortal() {
//     seletedPortal = portalName;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         child: ElevatedButton(
//             child: SizedBox(
//               width: cardWidth,
//               height: cardHeight,
//               child: Center(child: boxText),
//             ),
//             onPressed: changePortal),
//       ),
//     );
//   }
// }
