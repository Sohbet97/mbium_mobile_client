import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_recommendation_card.dart';

import '../../../../../generated/l10n.dart';

class AiRecommendationsList extends StatefulWidget {
  const AiRecommendationsList({super.key});

  @override
  State<AiRecommendationsList> createState() => _AiRecommendationsListState();
}

class _AiRecommendationsListState extends State<AiRecommendationsList> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<AiBloc, AiState>(
      builder: (context, state) {
        if (state is GetRecomendasionListProgress) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is GetRecomendasionListSuccess) {
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  children: [
                    Text(
                      localization.ai_agendyn,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localization.maslahat_beryan_harytlary,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? null : Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                );
              }
              return AiRecommendationCard(
                recommendation: state.models[index - 1],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemCount: state.models.length + 1,
          );
        }
        if (state is GetRecomendasionListError) {
          return Text(state.errorMessage);
        }

        return SizedBox();
      },
    );
  }
}
