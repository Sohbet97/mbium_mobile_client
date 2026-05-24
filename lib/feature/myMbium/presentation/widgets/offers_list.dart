import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/offer_card.dart';

class OffersList extends StatelessWidget {
  const OffersList({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).cardColor;

    return Container(
      height: 112,
      color: color,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemCount: 10,
        itemBuilder: (context, index) => OfferCard(),
      ),
    );
  }
}
