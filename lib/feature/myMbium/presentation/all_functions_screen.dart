import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

import '../../../generated/l10n.dart';
import '../../favorite/bloc/favorite_bloc.dart';
import '../../splash/bloc/main_bloc.dart';

class AllFunctionsScreen extends StatefulWidget {
  const AllFunctionsScreen({super.key});

  @override
  State<AllFunctionsScreen> createState() => _AllFunctionsScreenState();
}

class _AllFunctionsScreenState extends State<AllFunctionsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final localization = S.of(context);

        return Scaffold(
          appBar: AppBar(title: Text(localization.all_functions)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _buildItem(
                            title: localization.profil,
                            onTap: () {
                              // TODO click to person
                            },
                          ),
                          _buildItem(
                            title: localization.podpiska,
                            onTap: () {
                              Navigator.pushNamed(context, '/aiPodpiska');
                            },
                          ),
                          _buildItem(
                            title: localization.language,
                            trailing: const LanguageWidget(),
                            onTap: () => _shomLanguagePicker(context),
                          ),

                          _buildItem(
                            title: localization.addresses,
                            onTap: () {
                              Navigator.pushNamed(context, '/addresses');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _buildItem(
                            title: localization.search,
                            onTap: () {
                              // TODO click to support
                            },
                          ),
                          _buildItem(
                            title: localization.orders,
                            onTap: () {
                              Navigator.pushNamed(context, '/orders');
                            },
                          ),
                          _buildItem(
                            title: localization.favorites,
                            onTap: () {
                              Navigator.pushNamed(context, '/favorite');
                            },
                            trailing: BlocBuilder<FavoriteBloc, FavoriteState>(
                              builder: (context, state) {
                                final favoriteCount = state is FavoriteLoaded
                                    ? state.favorites.length
                                    : 0;
                                return favoriteCount > 0
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            favoriteCount.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppColors.primaryGreen,
                                            ),
                                          ),

                                          const SizedBox(width: 5),

                                          Icon(
                                            Icons.arrow_right,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      )
                                    : Icon(
                                        Icons.arrow_right,
                                        color: Colors.grey,
                                      );
                              },
                            ),
                          ),

                          _buildItem(
                            title: localization.sargytlar,
                            onTap: () {
                              Navigator.pushNamed(context, '/orders');
                            },
                          ),

                          _buildItem(
                            title: localization.gorulen_harytlar,
                            onTap: () {
                              Navigator.pushNamed(context, '/review');
                            },
                          ),

                          _buildItem(
                            title: localization.cupons,
                            onTap: () {
                              Navigator.pushNamed(context, '/cupons');
                            },
                          ),

                          _buildItem(
                            title: localization.tolegler,
                            onTap: () {
                              Navigator.pushNamed(context, '/tolegler');
                            },
                          ),

                          _buildItem(
                            title: localization.abuna,
                            onTap: () {
                              Navigator.pushNamed(context, '/abuna');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsetsGeometry.all(8),
                      child: Column(
                        children: [
                          _buildItem(
                            title: localization.mbiumda_satyp_basla,
                            onTap: () {
                              Navigator.pushNamed(context, '/reg_shop');
                            },
                          ),

                          _buildItem(
                            title: localization.categories,
                            onTap: () {
                              Navigator.pushNamed(context, '/categories');
                            },
                          ),

                          _buildItem(
                            title: localization.support,
                            onTap: () {
                              Navigator.pushNamed(context, '/support');
                            },
                          ),

                          _buildItem(
                            title: localization.ulanys_duzgunleri,
                            onTap: () {
                              Navigator.pushNamed(context, '/duzgunler');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem({
    required String title,
    IconData? icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) => ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    leading: icon != null ? Icon(icon, color: Colors.grey) : null,
    title: Text(title),
    trailing: trailing ?? Icon(Icons.arrow_right, color: Colors.grey),
  );

  void _shomLanguagePicker(BuildContext context) async {
    final localization = S.of(context);
    final currentLocale = context.read<MainBloc>().state.languageCode;
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                context.read<MainBloc>().add(
                  ChangeLanguage(languageCode: 'en'),
                );
                Navigator.pop(context);
              },
              leading: Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: Text(localization.english),
              trailing: currentLocale == 'en'
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
            ),
            ListTile(
              onTap: () {
                context.read<MainBloc>().add(
                  ChangeLanguage(languageCode: 'ru'),
                );
                Navigator.pop(context);
              },
              leading: Text('🇷🇺', style: TextStyle(fontSize: 20)),
              title: Text(localization.russkiy),
              trailing: currentLocale == 'ru'
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
            ),
            ListTile(
              onTap: () {
                context.read<MainBloc>().add(
                  ChangeLanguage(languageCode: 'tk'),
                );
                Navigator.pop(context);
              },
              leading: Text('🇹🇲', style: TextStyle(fontSize: 20)),
              title: Text(localization.turkmence),
              trailing: currentLocale == 'tk'
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final currentCode = state.languageCode;
        final countryFlag = currentCode == 'en'
            ? '🇺🇸'
            : currentCode == 'tk'
            ? '🇹🇲'
            : currentCode == 'ru'
            ? '🇷🇺'
            : '';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(countryFlag, style: TextStyle(fontSize: 18)),
            Container(
              height: 15,
              width: 2,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(horizontal: 5),
            ),
            Text(currentCode.toUpperCase()),
            const SizedBox(width: 5),
            Icon(Icons.arrow_right, color: Colors.grey),
          ],
        );
      },
    );
  }
}
