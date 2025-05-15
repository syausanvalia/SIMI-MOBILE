import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simi/dashboard.dart';

class konfirmasiPayment extends StatefulWidget {
  const konfirmasiPayment({Key? key}) : super(key: key);

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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
    if (pickedFile != null) {
      setState(() {
        _buktiTransfer = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
              children: [
                const Text(
                  "Konfirmasi Pembayaran",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel("ID Pelatihan"),
                _buildDisabledField("E43252"),
                _buildLabel("Kode Invoice"),
                _buildInputField(_kodeInvoiceController, "Masukkan Kode Invoice"),
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
                _buildLabel("Status"),
                _buildDisabledField(_status),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[100],
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    return Row(
      children: [
        Expanded(
          child: Text(
            _selectedDate == null
                ? 'Belum dipilih'
                : DateFormat('dd-MM-yyyy').format(_selectedDate!),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _pickDate,
        ),
      ],
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
