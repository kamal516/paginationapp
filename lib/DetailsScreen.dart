import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'HomeListData.dart';
import 'Utils.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  String imageUrl = "";

  @override
  State<StatefulWidget> createState() => DetailsScreenView();

  DetailsScreen(this.imageUrl);
}

class DetailsScreenView extends State<DetailsScreen>
    with TickerProviderStateMixin {
  List<Images> homeList = [];
  var img = Image.asset("assets/images/place.png", fit: BoxFit.cover);
  bool isLoading = false;
  Image? _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Details",
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: Text(
              "Details",
              style: TextStyle(
                  fontFamily: "Prompt", fontSize: 16, color: Colors.white),
            ),
          ),
          body: SafeArea(
            bottom: false,
            top: false,
            child: ModalProgressHUD(
              opacity: 0.0,
              inAsyncCall: isLoading,
              child: mainScreenView(),
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  mainScreenView() {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey, width: 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                //elevation: 10.0,
                child: GestureDetector(
                  onTap: () {
                    getImage().then((value) => {setImage(value)});
                  },
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: _image == null
                            ? (widget.imageUrl.isNotEmpty
                                ? Image.network(
                                    widget.imageUrl,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitWidth,
                                  )
                                : img)
                            : _image,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("First Name")),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: fNameController,
                              textAlign: TextAlign.start,
                              enabled: true,
                              maxLines: 1,
                              maxLength: 20,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                  fontFamily: "Prompt",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("Last Name")),
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.blueAccent, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0))),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: lNameController,
                                textAlign: TextAlign.start,
                                enabled: true,
                                maxLines: 1,
                                maxLength: 20,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontFamily: "Prompt",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  counterText: "",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              ),
                            )))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("Email")),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.blueAccent, width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: emailController,
                              textAlign: TextAlign.start,
                              enabled: true,
                              maxLines: 1,
                              maxLength: 20,
                              autofocus: false,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                  fontFamily: "Prompt",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                counterText: "",
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text("Phone number")),
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            width: MediaQuery.of(context).size.width,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.blueAccent, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0))),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: phoneController,
                                textAlign: TextAlign.start,
                                enabled: true,
                                maxLines: 1,
                                maxLength: 20,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                    fontFamily: "Prompt",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  counterText: "",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              ),
                            )))
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                    margin:
                        const EdgeInsets.only(top: 20, left: 15.0, right: 15.0),
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border:
                            Border.all(color: Colors.blueAccent, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0))),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontFamily: "Prompt",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ))),
                onTap: () {
                  if (checkValidation()) {
                    if (file != null) {
                      callIImagesListList();
                    } else {
                      Utils().showToast("Please add a photo.");
                    }
                  }
                },
              )
            ],
          ),
        ));
  }

  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: const Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: ImgSource.Gallery,
        barrierDismissible: true,
        cameraIcon: const Icon(
          Icons.camera_alt,
          color: Colors.red,
        ),
        //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        cameraText: const Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: const Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    return image;
  }

  callIImagesListList() async {
    showProgress();
    var req = http.MultipartRequest(
        'POST', Uri.parse("http://dev3.xicom.us/xttest/savedata.php"));
    req.fields["first_name"] = "108";
    req.fields["last_name"] = "1";
    req.fields["email"] = "popular";
    req.fields["phone"] = "popular";
    req.files.add(http.MultipartFile.fromBytes(
        'user_image', file!.readAsBytesSync(),
        filename: file!.path.split("/").last));
    var response = await req.send();
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        setAPIResponse(HomeListData.fromJson(jsonDecode(value)));
        hideProgress();
      });
    } else {
      hideProgress();
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return "";
    }
  }

  setAPIResponse(HomeListData response) {
    hideProgress();
    if (response != null) {
      if (response.status != null && response.status == "success") {
        Utils().showToast("Uploaded successfully!!");
      } else {
        Utils().showToast("Something went wrong");
      }
    } else {
      Utils().showToast("Something went wrong");
    }
  }

  showProgress() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
  }

  refreshState() {
    if (mounted) {
      setState(() {});
    }
  }

  hideProgress() {
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  File? file;
  setImage(value) {
    file = File(value.path);
    _image = Image(
      image: FileImage(file!),
      fit: BoxFit.cover, // use this
    );
    setState(() {});
  }

  bool checkValidation() {
    if (fNameController.text == "") {
      Utils().showToast("Please enter first name.");
      return false;
    }
    if (lNameController.text == "") {
      Utils().showToast("Please enter last name.");
      return false;
    }
    if (emailController.text == "") {
      Utils().showToast("Please enter email address.");
      return false;
    }
    if (phoneController.text == "") {
      Utils().showToast("Please enter phone number.");
      return false;
    } else
      return true;
  }
}
