import 'dart:io';

import 'package:camera/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class UploadService{
  final String SERVER_ADDR=SERVER_URL;
  Future<List<dynamic>> fetchItems() async{
    // Fetch items from server
    Response response=await Dio().post('$SERVER_ADDR/report/fetch-all-reports');
    if(response.statusCode==200){
      // List analysedItems=response.data;
      List analysedItems=response.data;
      //reverse the list to show the latest item first
      analysedItems=analysedItems.reversed.toList();
      return analysedItems;
    }else{
      // return [];
      throw Exception('Failed to load items');
    }
  }

  Future getProductDetail(int id) async{
    // Fetch product detail from server
    Response response=await Dio().post('$SERVER_ADDR/report/fetch-report',data: {'id':id});
    if(response.statusCode==200){
      return response.data;
    }else{
      print(response.data);
      throw Exception('Failed to load product detail');
    }
  }

  Future<bool> uploadImage(XFile? pickedImage,String productName) async {
    // Upload image to server
    if(pickedImage!=null){
      FormData formData=FormData.fromMap({
        'reportImg':await MultipartFile.fromFile(pickedImage.path,filename: pickedImage.name),
        'product_name':productName,
      });

      Response response=await Dio().post(
        '${SERVER_ADDR}/report/new',
        data: formData,
      );
      if(response.statusCode==200){
        return true;
        // response.data
      }
      else {
        throw Exception('Failed to upload image');
      }
    }
    return false;
    // Upload image to server
  }
}