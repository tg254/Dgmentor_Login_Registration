import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'inputs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'loging.dart';
import 'textbox.dart';
import 'passwordbox.dart';
import 'Customize_button.dart' show CustermizeButton;
import 'package:eosdart/eosdart.dart' as eos;

class RegistartionPage extends StatefulWidget {
  @override
  _RegistartionPageState createState() => _RegistartionPageState();
}

//final FirebaseAuth _auth = FirebaseAuth.instance;
DateTime date;

class _RegistartionPageState extends State<RegistartionPage> {
  File _image;

  Future _imgFromCamera() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = (_image.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('uploadNew/$fileName');
    eos.UploadTask uploadTask = storageReference.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      print("Done: $value");
      imageUrl = value;
    });
  }

  User loggedInUser;
  String selectedDepartment = 'Non';
  String selectedGendar = 'Male';
  String selectedEducation = 'Non';
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String fname;
  String lname;
  String phoneNo;
  String uCode;
  String bDay;
  String department;
  String gender;
  String eduction;
  String imageUrl;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String getText() {
    if (date == null) {
      return 'Birth Day';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    //
    for (String department in departtlist) {
      // String department = departmentList[i];
      var newItem = DropdownMenuItem(
        //
        child: Text(department),
        value: department,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  List<DropdownMenuItem> getDropdownItemsEdu() {
    //
    List<DropdownMenuItem<String>> dropdownItems1 = [];
    //
    for (String education in education) {
      // String department = departmentList[i];
      var newItem1 = DropdownMenuItem(
        //
        child: Text(education),
        value: education,
      );
      dropdownItems1.add(newItem1);
    }
    return dropdownItems1;
  }

  @override
  Widget build(BuildContext context) {
    getDropdownItems();
    getDropdownItemsEdu();
    Future pickDate(BuildContext context) async {
      final initialDate = DateTime.now();
      final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (newDate == null) return;
      setState(() => date = newDate);
    }

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/user.png'),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Align(
                            alignment: Alignment(1, 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextBox(
                      onChanged: (value) {
                        fname = value;
                      },
                      icon: Icons.person,
                      hintText: 'First Name',
                    ),
                    TextBox(
                      onChanged: (value) {
                        lname = value;
                      },
                      icon: Icons.person,
                      hintText: 'Last Name',
                    ),
                    TextBox(
                      onChanged: (value) {
                        phoneNo = value;
                      },
                      icon: Icons.phone,
                      hintText: 'Phone',
                    ),
                    TextBox(
                      onChanged: (value) {
                        uCode = value;
                      },
                      icon: Icons.format_list_numbered,
                      hintText: 'User Code',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getText(),
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                              onTap: () => pickDate(context),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Department',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DropdownButton<String>(
                                style: TextStyle(color: Color(0XFF9E9E9E)),
                                value: selectedDepartment,
                                //
                                items: getDropdownItems(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDepartment = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Gendar',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DropdownButton<String>(
                                style: TextStyle(color: Color(0XFF9E9E9E)),
                                value: selectedGendar,
                                //
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Male'),
                                    value: 'Male',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Female'),
                                    value: 'Female',
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedGendar = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Education',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              DropdownButton<String>(
                                style: TextStyle(color: Color(0XFF9E9E9E)),
                                value: selectedEducation,
                                //
                                items: getDropdownItemsEdu(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedEducation = value;
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    TextBox(
                      icon: Icons.email,
                      hintText: 'Email',
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    TextBox(
                      onChanged: (value) {
                        email = value;
                      },
                      icon: Icons.email,
                      hintText: 'Confirm Email',
                    ),
                    Passwordbox(
                      onChanged: (value) {
                        password = value;
                      },
                      icon: Icons.lock,
                      hintText: 'Password',
                    ),
                    Passwordbox(
                      onChanged: (value) {
                        password = value;
                      },
                      icon: Icons.lock,
                      hintText: 'Confirm Password',
                    ),
                    CustermizeButton(
                      text: 'Register',
                      onPressed: () async {
                        try {
                          final user =
                              await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          uploadImageToFirebase(context);

                          if (user != null) {
                            _firestore.collection('Users').add({
                              'first name': fname,
                              'last name': lname,
                              'birthday': date,
                              'email': email,
                              'confirm email': email,
                              'password': password,
                              'confirm password': password,
                              'department': selectedDepartment,
                              'education': selectedEducation,
                              'gender': selectedGendar,
                              'phone no': phoneNo,
                              'user code': uCode,
                              'image': imageUrl,
                            });

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Body()),
                            // );
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account?',
                          style: TextStyle(
                              color: Color(0XFF546E7A),
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          child: Text(
                            '  Login.',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
