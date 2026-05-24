import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/core/widgets/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/presentation/category_lisw_page.dart';

import '../../../generated/l10n.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent(isRefresh: false));
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final bloc = context.read<CategoryBloc>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(localization.categories),
        surfaceTintColor: Theme.of(context).cardColor,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) =>
            current is LoadCategoriesError ||
            current is LoadCategoriesProgress ||
            current is LoadCategoriesSuccess,
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
            final cats = state.categories;

            return CategoryListPage(categories: cats);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
