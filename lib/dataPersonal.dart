import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dataPersonal2.dart';
import 'package:simi/dashboard.dart';
import 'package:simi/infoBerangkat.dart';
import 'package:simi/trainingSchadule.dart';

void main() {
  runApp(MaterialApp(
    home: PersonalDataPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class PersonalDataPage extends StatefulWidget {
  final int activeNavIndex;
  
  const PersonalDataPage({Key? key, this.activeNavIndex = 1}) : super(key: key);
  
  @override
  _PersonalDataPageState createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  late int currentIndex;
  
  final TextEditingController idPmiController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noKkController = TextEditingController();
  final TextEditingController noKtpController = TextEditingController();
  final TextEditingController noPasporController = TextEditingController();
  final TextEditingController noIjazahController = TextEditingController();
  final TextEditingController tglPendaftaranController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController tglDaftarController = TextEditingController();
  final TextEditingController fullMedicalController = TextEditingController();
  final TextEditingController praMedicalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.activeNavIndex;
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    idPmiController.dispose();
    namaLengkapController.dispose();
    tempatLahirController.dispose();
    nikController.dispose();
    noKkController.dispose();
    noKtpController.dispose();
    noPasporController.dispose();
    noIjazahController.dispose();
    tglPendaftaranController.dispose();
    tglLahirController.dispose();
    tglDaftarController.dispose();
    fullMedicalController.dispose();
    praMedicalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const Text(
                    "Complete your data here !",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PersonalData2Page()),
                      );
                    },
                    child: const Icon(Icons.arrow_forward_ios, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTwoFields("ID PMI", idPmiController, "Tgl. Pendaftaran", tglPendaftaranController),
                    const SizedBox(height: 16),
                    buildTextField("Nama Lengkap", controller: namaLengkapController),
                    const SizedBox(height: 16),
                    buildTextField("Tempat Lahir", controller: tempatLahirController),
                    const SizedBox(height: 16),
                    buildDateField("Tgl. Lahir", tglLahirController),
                    const SizedBox(height: 16),
                    buildTextField("NIK", controller: nikController),
                    const SizedBox(height: 16),
                    buildTextField("No. KK", controller: noKkController),
                    const SizedBox(height: 16),
                    buildTextField("No. KTP", controller: noKtpController),
                    const SizedBox(height: 16),
                    buildTextField("No. Paspor", controller: noPasporController),
                    const SizedBox(height: 16),
                    buildTextField("No. Ijazah", controller: noIjazahController),
                    const SizedBox(height: 16),
                    buildDateField("Tgl. Daftar", tglDaftarController),
                    const SizedBox(height: 16),
                    buildDateField("Full Medical", fullMedicalController),
                    const SizedBox(height: 16),
                    buildDateField("Pra Medical", praMedicalController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    extendBody: true,
    );
  }

 Widget buildTextField(String label, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              border: const UnderlineInputBorder(),
            ),
            onTap: () => _selectDate(context, controller),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today_outlined, size: 20),
          onPressed: () => _selectDate(context, controller),
        ),
      ],
    );
  }

  Widget buildTwoFields(
    String labelLeft,
    TextEditingController leftController,
    String labelRight,
    TextEditingController rightController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: leftController,
            decoration: InputDecoration(
              labelText: labelLeft,
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: rightController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: labelRight,
                    border: const UnderlineInputBorder(),
                  ),
                  onTap: () => _selectDate(context, rightController),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined, size: 20),
                onPressed: () => _selectDate(context, rightController),
              ),
            ],
          ),
        ),
      ],
    );
  }}