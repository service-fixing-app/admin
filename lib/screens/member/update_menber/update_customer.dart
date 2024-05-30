import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/controllers/member/add_customerController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCustomer extends StatefulWidget {
  UpdateCustomer({Key? key}) : super(key: key);

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  String _selectGender = '';
  DateTime? _selectedDate;
  // final selectedCustomer = MenuAppController.instance.selectedCustomerData.value;
  late Map<String, dynamic> _selectedCustomerData;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Selected province and district
  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> stateMasters = [];
  List<Map<String, dynamic>> states = [];

  String? selectedProvince;
  String? selectedState;

  @override
  void initState() {
    super.initState();

    provinces = [
      {"val": 1, "name": "ນະຄອນຫຼວງຈັນ"},
      // Add more provinces here
    ];

    stateMasters = [
      {"ID": 1, "Name": "ເມືອງຈັນທະບູລີ", "ParentId": 1},
      // Add more states here
    ];

    _selectedCustomerData =
        MenuAppController.instance.selectedCustomerData.value!;

    if (_selectedCustomerData != null) {
      firstNameController.text = _selectedCustomerData['first_name'] ?? '';
      lastNameController.text = _selectedCustomerData['last_name'] ?? '';
      ageController.text = _selectedCustomerData['age'] ?? '';
      villageController.text = _selectedCustomerData['village'] ?? '';
      phoneNumberController.text = _selectedCustomerData['phone'] ?? '';
      passwordController.text = _selectedCustomerData['password'] ?? '';
      repasswordController.text = _selectedCustomerData['password'] ?? '';
      _selectGender = _selectedCustomerData['gender'] ?? '';
      selectedProvince = _selectedCustomerData['province'] ?? '';
      selectedState = _selectedCustomerData['district'] ?? '';
      // _selectedDate = DateTime.parse(_selectedCustomerData['birthdate']) ?? ;
    }
  }

  void _initializeFormFields() {
    _selectedCustomerData =
        MenuAppController.instance.selectedCustomerData.value ?? {};

    firstNameController.text = _selectedCustomerData['first_name'] ?? '';
    lastNameController.text = _selectedCustomerData['last_name'] ?? '';
    ageController.text = _selectedCustomerData['age'] ?? '';
    villageController.text = _selectedCustomerData['village'] ?? '';
    phoneNumberController.text = _selectedCustomerData['phone'] ?? '';
    passwordController.text = _selectedCustomerData['password'] ?? '';
    repasswordController.text = _selectedCustomerData['password'] ?? '';
    _selectGender = _selectedCustomerData['gender'] ?? '';
    selectedProvince = _selectedCustomerData['province'] ?? '';
    selectedState = _selectedCustomerData['district'] ?? '';
    _selectedDate = _selectedCustomerData['birthdate'] != null
        ? DateTime.parse(_selectedCustomerData['birthdate'])
        : null;
  }

  // Define variables for text
  final CustomerRegisterController _customerRegisterController =
      Get.put(CustomerRegisterController());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  String countryCode = '+856';
  bool _hidePassword = true;
  bool isLoading = false;
  // Upload user profile
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();
  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        // print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ລົງທະບຽນລູກຄ້າໃໝ່',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'phetsarath_ot',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            // Text Field register
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: FloatingActionButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text('ຮູບພາບ'),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          _getImage(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          tooltip: 'ອັບໂລດຮູບ profile',
                          child: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 130),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'ຊື່ຜູ້ໃຊ້',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'ນາມສະກຸນ',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'ອາຍຸ',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ເພດ',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'phetsarath_ot',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Radio<String?>(
                            value: 'ຊາຍ',
                            groupValue: _selectGender,
                            onChanged: (String? value) {
                              setState(() {
                                _selectGender = value!;
                              });
                            },
                          ),
                          const Text('ຊາຍ'),
                          Radio<String?>(
                            value: 'ຍິງ',
                            groupValue: _selectGender,
                            onChanged: (String? value) {
                              setState(() {
                                _selectGender = value!;
                              });
                            },
                          ),
                          const Text('ຍິງ'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: villageController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'ບ້ານ',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ວັນ, ເດືອນ, ປີເກີດ',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'phetsarath_ot',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          hintText: _selectedDate == null
                              ? 'ເລືອກວັນເດືອນປີ'
                              : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ແຂວງ',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'phetsarath_ot',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedProvince,
                        onChanged: (String? value) {
                          setState(() {
                            selectedProvince = value;
                            selectedState = null;
                            states = stateMasters
                                .where((state) =>
                                    state['ParentId'] ==
                                    provinces.firstWhere((province) =>
                                        province['name'] == value)['val'])
                                .toList();
                          });
                        },
                        items: provinces.map((province) {
                          return DropdownMenuItem<String>(
                            value: province['name'],
                            child: Text(province['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ເມືອງ',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'phetsarath_ot',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedState,
                        onChanged: (String? value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                        items: states.map((state) {
                          return DropdownMenuItem<String>(
                            value: state['Name'],
                            child: Text(state['Name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'ເບີໂທ',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: 'ລະຫັດຜ່ານ',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: repasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: 'ຢືນຢັນລະຫັດຜ່ານ',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Update button
            Center(
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Add validation and API call here
                  },
                  child: const Text(
                    'ອັບເດດລູກຄ້າ',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'phetsarath_ot',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
