import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simi/payment_status_manager.dart';
import 'api_services.dart';
import 'dashboard.dart';
import 'berita.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'infoPekerjaan.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;


class konfirmasiPayment extends StatefulWidget {
  final int trainingId;

  const konfirmasiPayment({Key? key, required this.trainingId})
      : super(key: key);

  @override
  State<konfirmasiPayment> createState() => _konfirmasiPaymentPageState();
}

class _konfirmasiPaymentPageState extends State<konfirmasiPayment> {
  final TextEditingController _kodeInvoiceController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _buktiTransfer;
  final String _status = "Menunggu Konfirmasi";

  Future<void> _pickDate() async {
    try {
      // Tambahkan safety check untuk context
      if (!mounted) return;

      // Gunakan MaterialApp theme untuk styling yang konsisten
      final ThemeData theme = Theme.of(context);

      final DateTime currentDate = DateTime.now();
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialEntryMode: DatePickerEntryMode.calendar, // Memaksa mode kalender
        helpText: 'Pilih Tanggal Transfer', // Teks header
        cancelText: 'BATAL',
        confirmText: 'PILIH',
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: theme.copyWith(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              colorScheme: theme.colorScheme.copyWith(
                primary: Colors.pink[100],
                surface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.pink[100],
                ),
              ),
            ),
            child: child ?? Container(),
          );
        },
        errorFormatText: 'Format tanggal tidak valid',
        errorInvalidText: 'Tanggal tidak valid',
      );

      // Handle hasil pemilihan
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    } catch (e) {
      // Error handling yang lebih informatif
      print('Error saat membuka date picker: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka kalender. Silakan coba lagi.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String formatTimeOfDay24(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dt);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    print("Gambar tidak dipilih.");
    return;
  }

  final File originalFile = File(pickedFile.path);
  final double originalSizeMB = (await originalFile.length()) / (1024 * 1024);

  print('Path asli: ${originalFile.path}');
  print('Ukuran asli: ${originalSizeMB.toStringAsFixed(2)} MB');

  if (originalSizeMB > 2.0) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ukuran Gambar Terlalu Besar'),
        content: Text(
            'Ukuran bukti transfer lebih dari 2MB (${originalSizeMB.toStringAsFixed(2)} MB). '
            'Silakan unggah gambar dengan ukuran lebih kecil.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  setState(() {
    _buktiTransfer = originalFile;
  });
}


  @override
  void dispose() {
    _kodeInvoiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Penting untuk scroll
                children: [
                  const Text(
                    "Pending",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("ID Pelatihan (training_registration)"),
                  _buildDisabledField(widget.trainingId.toString()),
                  _buildLabel("Kode Invoice"),
                  _buildInputField(
                      _kodeInvoiceController, "Masukkan Kode Invoice"),
                  _buildLabel("Tgl. Transfer"),
                  _buildDatePicker(),
                  _buildLabel("Jam Transfer"),
                  _buildTimePicker(),
                  _buildLabel("Bukti Transfer"),
                  _buildUploadButton(),
                  if (_buktiTransfer != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.file(_buktiTransfer!, height: 100),
                    ),
                  _buildLabel("Status Pembayaran"),
                  _buildDisabledField(_status),
                  _buildLabel("Status Registrasi"),
                  _buildDisabledField(_status),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Tambahan supaya tidak mepet layar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  

 Future<void> _submitPayment() async {
  if (!_validateInputs()) return;

  // Format waktu dengan benar
  final transferTime = formatTimeOfDay24(_selectedTime!);
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  final result = await ApiService.submitPayment(
    trainingRegistrationId: widget.trainingId,
    invoiceCode: _kodeInvoiceController.text,
    transferDate: _selectedDate!,
    transferTime: transferTime,
    proofOfTransfer: _buktiTransfer!,
  );

  Navigator.of(context).pop(); // tutup loading dialog

  if (result['success'] == true) {
    await PaymentStatusManager.setPaymentStatus(widget.trainingId, true);
    if (mounted) {
      // Tampilkan dialog sukses dengan animasi Lottie
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/lottie/payment.json',
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Berhasil melakukan pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Harap menunggu konfirmasi admin',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomNavBarPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[100],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  } else {
    if (mounted) {
      // Tampilkan detail error jika ada
      String errorMessage = result['message'];
      if (result['errors'] != null) {
        errorMessage += '\n${result['errors'].toString()}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}

  bool _validateInputs() {
    if (_kodeInvoiceController.text.isEmpty) {
      _showError('Kode Invoice wajib diisi');
      return false;
    }
    if (_selectedDate == null) {
      _showError('Tanggal transfer wajib dipilih');
      return false;
    }
    if (_selectedTime == null) {
      _showError('Waktu transfer wajib dipilih');
      return false;
    }
    if (_buktiTransfer == null) {
      _showError('Bukti transfer wajib diunggah');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: const UnderlineInputBorder(),
      ),
    );
  }

  Widget _buildDisabledField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(value),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _selectedDate == null
                    ? 'Pilih tanggal transfer'
                    : DateFormat('dd MMMM yyyy', 'id_ID')
                        .format(_selectedDate!),
                style: TextStyle(
                  color: _selectedDate == null ? Colors.grey : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: _pickDate,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.pink[100],
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _selectedTime == null
                ? 'Belum dipilih'
                : _selectedTime!.format(context),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: _pickTime,
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return OutlinedButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.upload_file),
      label: const Text("Pilih Gambar"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: const BorderSide(color: Colors.pink),
        foregroundColor: Colors.pink,
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
      Icon(Icons.article_outlined, size: 30, color: Colors.grey),
    ];

          return Container(
      color: Colors.pink[100],
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: _getPageByIndex (_currentIndex),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(248, 187, 208, 1),
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
