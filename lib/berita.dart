import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dashboard.dart';
import 'infoPekerjaan.dart';
import 'berita.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomNavBarPage(),
  ));
}

class PopularNewsPage extends StatefulWidget {
  @override
  State<PopularNewsPage> createState() => _PopularNewsPageState();
}

class _PopularNewsPageState extends State<PopularNewsPage> {
  final List<Map<String, String>> newsList = const [
    {
      'image': 'assets/pasar.jpeg',
      'title': 'Wisata kuliner',
      'description':
          'Night Market Taipei yang sangat ramai dan dipenuhi dengan berbagai macam makanan khas dari daerah Taiwan, mulai dari makanan laut, camilan manis, minuman segar, hingga hiburan lokal yang meriah dan ramah wisatawan.',
      'date': '17 Mei 2025'
    },
    {
      'image': 'assets/dibakar.png',
      'title': 'Pria Nekat',
      'description':
          'Jenazah Ayah Dibakar karena alasan yang masih belum diketahui, polisi sedang menyelidiki kasus ini lebih lanjut dengan memeriksa saksi dan barang bukti serta menunggu hasil forensik dari laboratorium untuk memastikan penyebab kematian.',
      'date': '16 Mei 2025'
    },
    {
      'image': 'assets/jalaniSumpah.jpeg',
      'title': 'Jay Idzes',
      'description':
          'Rampung jalani pengambilan sumpah sebagai warga negara Indonesia yang sah dan resmi diumumkan oleh Kemenkumham setelah melalui proses naturalisasi dan pengambilan sumpah sesuai hukum yang berlaku.',
      'date': '15 Mei 2025'
    },
    {
      'image': 'assets/fotodashboard2.png',
      'title': 'Berita Promo',
      'description':
          'Promo Sale besar-besaran untuk berbagai produk kebutuhan rumah tangga dan elektronik di awal bulan ini, diskon mencapai hingga 70% hanya di beberapa toko tertentu dan berlaku selama persediaan masih ada.',
      'date': '14 Mei 2025'
    },
  ];

  final Set<int> expandedIndex = {};

  String getShortText(String text) {
    final words = text.split(' ');
    final half = (words.length / 2).ceil();
    return words.sublist(0, half).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Popular News",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  final isExpanded = expandedIndex.contains(index);
                  final description = news['description']!;
                  final displayText =
                      isExpanded ? description : getShortText(description);

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            news['image']!,
                            height: 80,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news['title']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displayText,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    news['date']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isExpanded) {
                                          expandedIndex.remove(index);
                                        } else {
                                          expandedIndex.add(index);
                                        }
                                      });
                                    },
                                    child: Text(
                                      isExpanded ? "Tutup" : "Selanjutnya",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavBarPage extends StatefulWidget {
  final int initialIndex;
  const CustomNavBarPage({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  State<CustomNavBarPage> createState() => _CustomNavBarPageState();
}

class _CustomNavBarPageState extends State<CustomNavBarPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return JobInfoPage();
      case 1:
        return Dashboard();
      case 2:
        return PopularNewsPage();
      default:
        return Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.work_outline, size: 30, color: Colors.grey),
      Icon(Icons.home, size: 30, color: Colors.grey),
      Icon(Icons.newspaper, size: 30, color: Colors.grey),
    ];

    return Container(
      color: Colors.pink[100],
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: _getPageByIndex(_currentIndex),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade100,
                  const Color.fromARGB(255, 255, 243, 214),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CurvedNavigationBar(
              key: navigationKey,
              color: Colors.transparent,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              height: 60,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              index: _currentIndex,
              items: items,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}
