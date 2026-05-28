import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/mbium_menu_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/offers_list.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/settings_banner_widget.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_in_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_litle_data_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import 'package:mbium_mobile_client/main.dart';

import '../../../generated/l10n.dart';

class MyMbiumPage extends StatelessWidget {
  const MyMbiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<PersonRepository>().preferences.isRegistered(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == true
              ? _MyMbiumDataPage()
              : const LoginInScreen();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _MyMbiumDataPage extends StatelessWidget {
  const _MyMbiumDataPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = S.of(context);

    final primaryColor = theme.colorScheme.primary;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
                    primaryColor.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            const SizedBox(width: 5),

            _buildActionButton('assets/icons/support.svg', () {
              Navigator.pushNamed(context, '/support');
            }),
            const SizedBox(width: 5),

            _buildActionButton('assets/icons/scan.svg', () {
              // TODO click to scan
            }),
            const SizedBox(width: 5),

            _buildActionButton('assets/icons/settings.svg', () {
              Navigator.pushNamed(context, '/settings');
            }),
          ],
          title: const PersonLittleDataWidget(),
        ),
        const SliverToBoxAdapter(child: MbiumMenuWidget()),
        const SliverToBoxAdapter(child: SettingsBannerWidget()),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(color: theme.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.menin_sargytlarym,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isDarkTheme ? Colors.black : null,
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: OffersList()),
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/aiPodpiska');
            },
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(color: theme.cardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/melek_ai.png',
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(width: 10),
                  Text(
                    localization.ai_agendin_mugt_dowri,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: !isDarkTheme ? Colors.black : null,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            decoration: BoxDecoration(color: theme.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo_kici.png',
                  height: 50,
                  width: 50,
                ),
                SizedBox(width: 10),
                Text(
                  localization.mbiumda_satyp_basla,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isDarkTheme ? Colors.black : null,
                  ),
                ),
                Expanded(child: SizedBox()),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsGeometry.only(
              top: 20,
              left: 10,
              bottom: 3,
            ),
            child: Text(
              S.of(context).sizin_ucin,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: MyLoadingWidget(),
                ),
              );
            }

            if (state is ProductError) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(state.message),
                  ),
                ),
              );
            }

            if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return SliverToBoxAdapter(
                  child: MyEmptyWidget(emptyText: S.of(context).product_empty),
                );
              }

              return SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductMassonGridItem(product: product);
                },
                childCount: products.length,
              );
            }
            return SliverToBoxAdapter();
          },
        ),
      ],
    );
  }

  GestureDetector _buildActionButton(String iconUrl, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsGeometry.only(right: 12),
          child: SvgIcon(iconName: iconUrl),
        ),
      );
}
