import 'dart:io';

import 'package:camera/components/food_card.dart';
import 'package:camera/service/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> scanItems;
  File? selectedImage;
  bool isUploading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scanItems = UploadService().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Food Pharmer",style: TextStyle(fontSize: 30),))
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showImageSourceActionSheet,
        label: const Text("Scan Your Food",style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.camera_alt,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isUploading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: scanItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data?[index].runtimeType);
                    return FoodCard(
                      itemData: snapshot.data?[index],
                    );
                  },
                );
              }),
    );
  }

  void showImageSourceActionSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              )
            ],
          ));
        });
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    askForProductName(returnedImage);
  }

  void uploadImage(XFile image, String productName) async {
    setState(() {
      isUploading = true;
    });
    if (await UploadService().uploadImage(image, productName)) {
      setState(() {
        scanItems = UploadService().fetchItems();
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image Successfully Uploaded')),
      );
    }
    else {
      //show snackbar
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  Future<void> askForProductName(XFile image) async {
    String productName = '';
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Product Name'),
            content: TextField(
              onChanged: (value) {
                productName = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter Product Name',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    uploadImage(image, productName);
                  },
                  child: const Text('Submit')),
            ],
          );
        });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    askForProductName(returnedImage);
  }
}
