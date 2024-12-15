import 'dart:io';

import 'package:camera/components/detail_container.dart';
import 'package:camera/components/ingredients_container.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ProductDetail extends StatelessWidget {
  final Map itemDetail;

  late String imageUrl;
  late String uploadTime;
  late Map analysis;
  late String analysisSummary;
  late List ingredients;
  late Map result;
  late String productName;

  ProductDetail({super.key, required this.itemDetail}) {
    imageUrl = itemDetail['image'];
    uploadTime= itemDetail['upload_time'].toString();
    analysis = itemDetail['analysis'];
    analysisSummary=analysis['summary'];
    ingredients=analysis['ingredientsAnalysis'];
    result=analysis['result'];
    productName=itemDetail['product_name'];
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(toTitleCase(itemDetail['product_name']),style: TextStyle(fontSize: 40,color: Colors.blue),)),
        ),
        Image.network(
          '$SERVER_URL$imageUrl',
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DetailContainer(children: [
                // Text(analysisSummary.toString()),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nutritional Info:",
                      style: TextStyle(color: Colors.blue,fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IngredientsContainer(ingredients: ingredients),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Analysis: ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Overall Safety: "),
                            (result['overAllSafety']=='Healthy')
                            ?Text(result['overAllSafety'],style: TextStyle(color: Colors.green))
                                :Text(result['overAllSafety'],style: TextStyle(color: Colors.red))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Healthy Rate: "),
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 5,
                                  child: LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(10),
                                    value: result['healthyRate']/100,
                                    backgroundColor: Colors.grey,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(result['healthyRate'].toString())
                              ],
                            ),
                            // LinearProgressIndicator(value: result['healthyRate']/100),

                          ],
                        ),
                      ],
                    ),  
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("FeedBack: ",style: TextStyle(fontSize: 20,color: Colors.blue),),
                    const SizedBox(height: 5,),
                    Text(result['overAllFeedback']),
                  ],
                )
              ]),
              InkWell(
                onTap: ()=>shareAnalysisWithFriends(context),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Share Analysis",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ]))
      ]),
    );
  }

  void shareAnalysisWithFriends(context) async{
    final String imagePath='$SERVER_URL$imageUrl';
    final url=Uri.parse(imagePath);

    final response=await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
      return FutureBuilder(future: http.get(url), builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          Navigator.of(context).pop(snapshot.data);
          return Container();
        }else{
          return const Center(child: CircularProgressIndicator(),);
        }
      });
    });
    await http.get(url);

    final bytes=response.bodyBytes;
    final temp=await getTemporaryDirectory();
    final path='${temp.path}/image.png';
    File(path).writeAsBytesSync(bytes);

    await Share.shareXFiles([XFile(path)],text: '$productName\n$analysisSummary');
    print("Share Analysis with Friends");
  }
}
