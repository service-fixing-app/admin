import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/controllers/member/add_customerController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  String _selectGender = '';
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
                    keyboardType: TextInputType.name,
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
                      LengthLimitingTextInputFormatter(50),
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
                          Radio<String?>(
                            value: 'ອື່ນໆ',
                            groupValue: _selectGender,
                            onChanged: (String? value) {
                              setState(() {
                                _selectGender = value!;
                              });
                            },
                          ),
                          const Text('ອື່ນໆ'),
                        ],
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
                      prefixText: countryCode,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 2.0),
                      ),

                      // suffixIcon: Icon(
                      //   otpController.isVerified.value
                      //       ? Icons.check_circle
                      //       : Icons.error_outline,
                      //   color: otpController.isVerified.value
                      //       ? Colors.green
                      //       : Colors.red,
                      // ),
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: _hidePassword,
                    controller: passwordController,
                    keyboardType: TextInputType.name,
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
                        vertical: 15.0,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(5),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: _hidePassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const SizedBox(width: 20),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedDate != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: 'ວັນທີ່ເດືອນປີເກີດ',
                            labelStyle: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'phetsarath_ot',
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_month_outlined),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 52,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 4.0,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedProvince,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: 'ເລືອກແຂວງ',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    items: provinces.map((province) {
                      return DropdownMenuItem<String>(
                        value: province['name'],
                        child: Text(province['name']),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(
                        () {
                          selectedProvince = newValue;
                          selectedState = null;
                          states = stateMasters
                              .where((state) =>
                                  state['ParentId'] ==
                                  provinces.firstWhere(
                                    (province) => province['name'] == newValue,
                                  )['val'])
                              .toList();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 52,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 4.0,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedState,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: 'ເລືອກເມືອງ',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'phetsarath_ot',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    items: states.map((state) {
                      return DropdownMenuItem<String>(
                        value: state['Name'],
                        child: Text(state['Name']),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedState = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: villageController,
                    keyboardType: TextInputType.name,
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
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 52.0,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      // logic
                      final customer = Customer(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        tel: phoneNumberController.text,
                        password: passwordController.text,
                        age: ageController.text,
                        gender: _selectGender,
                        birthdate: _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : '',
                        province: selectedProvince ?? '',
                        district: selectedState ?? '',
                        village: villageController.text,
                      );

                      firstNameController.clear();
                      lastNameController.clear();
                      phoneNumberController.clear();
                      passwordController.clear();
                      ageController.clear();
                      villageController.clear();

                      // print('firstname: ${firstNameController.text}');
                      // print('lastName: ${lastNameController.text}');
                      // print('tel: ${phoneNumberController.text}');
                      // print('password: ${passwordController.text}');
                      // print('age: ${ageController.text}');
                      // print(
                      //     'birthdate: ${_selectedDate != null ? _selectedDate.toString() : 'Not selected'}');
                      // print('province: ${selectedProvince ?? 'Not selected'}');
                      // print('district: ${selectedState ?? 'Not selected'}');
                      // print('village: ${villageController.text}');

                      await _customerRegisterController
                          .customerRegistrationData(customer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3.0,
                    ),
                    child: Obx(() {
                      return _customerRegisterController.isLoading.value
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : const Text(
                              'ສົ່ງຟອມສະໝັກ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'phetsarath_ot',
                              ),
                            );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
