import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
  ));
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 1;

  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  TextEditingController controllerMoto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.settings),
                  Icon(Icons.person_outline),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/google.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: 160,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Grow better\ntogether',
                      style: TextStyle(
                        color: Color.fromARGB(255, 245, 211, 211),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "More",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 250, 195, 213),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
                children: [
                  _buildMenuItem(Icons.article, "reference"),
                  _buildMenuItem(Icons.school, "graduation"),
                  _buildMenuItem(Icons.work, "job vacancy"),
                  _buildMenuItem(Icons.person, "personal data"),
                  _buildMenuItem(Icons.article, "payment"),
                  _buildMenuItem(Icons.school, "training subject"),
                  _buildMenuItem(Icons.work, "popular news"),
                  _buildMenuItem(Icons.person, "final score"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink[100]!,
            Color.fromARGB(255, 244, 229, 186),
          ],
        ),
      ),
  child: BottomNavigationBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    currentIndex: _currentIndex,
    selectedItemColor: const Color.fromARGB(255, 255, 255, 255), 
    unselectedItemColor: Colors.grey, 
    onTap: (index) {
      setState(() {
        _currentIndex = index;
      });
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.flight_takeoff),
        label: "departure",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: "schedule",
      ),
    ],
  ),
),
);
}

  Widget _buildMenuItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.pink[100]!, Color.fromARGB(255, 244, 229, 186)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.grey[800]),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
