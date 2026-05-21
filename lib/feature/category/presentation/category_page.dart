import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/core/widgets/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';

import '../../../generated/l10n.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent(isRefresh: false));
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final bloc = context.read<CategoryBloc>();
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is LoadCategoriesProgress) {
          return const MyLoadingWidget();
        }

        if (state is LoadCategoriesError) {
          return MyErrorWidget(
            message: localization.nasazlyk_yuze_cykdy,
            onReload: () {
              bloc.add(LoadCategoriesEvent(isRefresh: true));
            },
          );
        }

        if (state is LoadCategoriesSuccess) {
          final cats;
          return Text('data');
        }
        return SizedBox.shrink();
      },
    );
  }
}
