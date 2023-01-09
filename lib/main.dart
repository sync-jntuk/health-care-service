import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Care Servives app',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Health Care Servives'),
    );
  }
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementCounter() {
    setState(() {
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
          cardWidth: cardWidth,
          cardHeight: cardHeight,
        ),
        const Spacer(),
        ElevatedCard(
          boxText: Text(
            rightText,
            style: Theme.of(context).textTheme.headline6,
          ),
          cardWidth: cardHeight,
          cardHeight: cardHeight,
        ),
        const Spacer(),
      ],
    );
  }

  List<Widget> getPortal(double squareCardWidth) {
    List<Widget> portals = [];
    List<String> names = [
      "Portal 01",
      "Portal 02",
      "Portal 03",
      "Portal 04",
      "Portal 05",
      "Portal 06",
      "Portal 07",
      "Portal 08",
      "Portal 09",
      "Portal 10",
      "Portal 11",
      "Portal 12",
    ];
    for (int i = 0; i < names.length; i += 2) {
      portals.add(TwoCardWidgets(
          names[i], names[i + 1], squareCardWidth, squareCardWidth));
    }
    return portals;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    double squareCardWidth = width / 2 - 20;
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
                'Count : $_counter',
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

class ElevatedCard extends StatelessWidget {
  Text boxText;
  double cardWidth, cardHeight;
  ElevatedCard(
      {Key? key,
      required this.boxText,
      required this.cardWidth,
      required this.cardHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Center(child: boxText),
        ),
      ),
    );
  }
}
