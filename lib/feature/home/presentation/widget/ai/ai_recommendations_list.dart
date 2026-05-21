import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_recommendation_card.dart';

class AiRecommendationsList extends StatefulWidget {
  const AiRecommendationsList({super.key});

  @override
  State<AiRecommendationsList> createState() => _AiRecommendationsListState();
}

class _AiRecommendationsListState extends State<AiRecommendationsList> {
  @override
  Widget build(BuildContext context) {
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
              return AiRecommendationCard(recommendation: state.models[index]);
            },
            separatorBuilder: (context, index) => SizedBox(height: 19),
            itemCount: state.models.length,
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
