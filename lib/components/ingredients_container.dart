import 'package:flutter/material.dart';

class IngredientsContainer extends StatelessWidget {
  final List ingredients;
  const IngredientsContainer({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map((ingredient) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Text(
                          ingredient['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      (ingredient['safetyLevel'] == 'Healthy')
                          ? Container(
                        width: 100,
                            child: Text(
                                ingredient['quantity'],
                                style: TextStyle(color: Colors.green),
                                                    overflow: TextOverflow.ellipsis,
                              ),
                          )
                          : Container(
                        width: 100,
                            child: Text(
                                ingredient['quantity'],
                                style: TextStyle(color: Colors.red),
                                                    overflow: TextOverflow.ellipsis,
                              ),
                          ),

                      // Text(ingredient['safetyLevel']),
                      // Text(ingredient['feedback']),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ))
          .toList(),
    );
  }
}
