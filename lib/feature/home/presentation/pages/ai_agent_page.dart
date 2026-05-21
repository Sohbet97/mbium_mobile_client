import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_recommendations_list.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/bonus_banner_card.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/refresh_button.dart';

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
    return BlocConsumer<AiBloc, AiState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RefreshButton(),
                  BonusBannerCard(
                    title: 'Derejani galdyr',
                    coinIcon: 'assets/images/coin_image.png',
                    coinQuantity: '20',
                  ),
                ],
              ),

              SizedBox(height: 9),
              BonusBannerCard(
                title: 'Häzir barlap gör - her gün 100 karz berilýär!',
              ),
              SizedBox(height: 17),
              Row(
                children: [
                  Text(
                    'AI Agendyň ',
                    style: context.appTextStyles.s16w600clBlack.copyWith(
                      color: AppColors.bonusBannerTextGreen,
                    ),
                  ),
                  Text(
                    'masdlahat berýän harytlary',
                    style: context.appTextStyles.s16w600clBlack,
                  ),
                ],
              ),
              SizedBox(height: 8),

              AiRecommendationsList(),
            ],
          ),
        );
      },
    );
  }
}
