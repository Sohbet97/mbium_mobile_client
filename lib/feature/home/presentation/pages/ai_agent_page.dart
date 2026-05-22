import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_recommendations_list.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/bonus_banner_card.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/promt_filed_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/refresh_button.dart';

import '../../../../generated/l10n.dart';

class AiAgetntPage extends StatefulWidget {
  const AiAgetntPage({super.key});

  @override
  State<AiAgetntPage> createState() => _AiAgetntPageState();
}

class _AiAgetntPageState extends State<AiAgetntPage> {
  late AiBloc _aiBloc;
  @override
  void initState() {
    super.initState();
    _aiBloc = context.read<AiBloc>();
    _aiBloc.add(GetRecomendasionListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return BlocConsumer<AiBloc, AiState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: AiInputFieldFab(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AiHistoryButton(onTap: () {}),
                    BonusBannerCard(
                      title: localization.derejani_galdyr,
                      coinIcon: 'assets/images/coin_image.png',
                      coinQuantity: '20',
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: 8),

                AiRecommendationsList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
