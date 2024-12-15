import 'package:camera/pages/product_detail.dart';
import 'package:camera/service/upload_service.dart';
import 'package:camera/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodCard extends StatelessWidget {
  final Map itemData;
  late String productName;
  late String imageUrl;
  late String uploadTime;
  late String status;
  FoodCard({super.key, required this.itemData}) {
    productName = (itemData['product_name'] != null)
        ? itemData['product_name']
        : "Product ${itemData['id']}";
    imageUrl = itemData['image'];
    uploadTime = itemData['upload_time'].toString();
    status = "Healthy"; //itemData['result']['overAllSafety'];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final itemDetail =
            await UploadService().getProductDetail(itemData['id']);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetail(
                  itemDetail: itemDetail,
                )));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Image.network(
                        '$SERVER_URL$imageUrl',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              height: 180,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            /*Text("Status: $status",
                                style: const TextStyle(
                                    fontSize: 12, backgroundColor: Colors.red)),*/
                          ],
                        ),
                        (itemData['summary']
                                    .toString()
                                    .toLowerCase()
                                    .contains("unsafe") ||
                                itemData['summary']
                                    .toString()
                                    .toLowerCase()
                                    .contains("unhealthy") ||
                                itemData['summary']
                                    .toString()
                                    .toLowerCase()
                                    .contains("poor"))
                            ? Text(
                                itemData['summary'],
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.red),
                              )
                            : Text(
                                itemData['summary'],
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.green),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(itemData['upload_time'])),
                                style: const TextStyle(
                                    fontSize: 12,
                                    backgroundColor: Color(0x000000FF))),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
