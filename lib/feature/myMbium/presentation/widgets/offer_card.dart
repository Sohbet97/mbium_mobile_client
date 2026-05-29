import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      height: 73,
      width: 179,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.2),
            primaryColor.withOpacity(0.4),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Mugt dostawka',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                //SizedBox(height: 5),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Haryt gozle',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Image.asset('assets/images/delivery-truck.png'),
        ],
      ),
    );
  }
}
