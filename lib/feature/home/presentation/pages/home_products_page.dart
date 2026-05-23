import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/home_menu_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';

class HomeProductsPage extends StatefulWidget {
  const HomeProductsPage({super.key});

  @override
  State<HomeProductsPage> createState() => _HomeProductsPageState();
}

class _HomeProductsPageState extends State<HomeProductsPage> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SearchWidget(
            controller: _searchController,
            onTapPhoto: () {},
            onTapAudio: () {},
            onTapAi: () {},
            onSubmit: () {},
          ),
          const SizedBox(height: 10),
          const HomeMenuWidget(),
        ],
      ),
    );
  }
}
