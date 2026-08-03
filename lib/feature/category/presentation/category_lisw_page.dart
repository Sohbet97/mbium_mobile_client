import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/category_detail_screen.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_breadcrumb_widget.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_focus_panel_widget.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_siblings_list_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late List<CategoryModel> _path;
  late ProductBloc _productBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _scrollController.addListener(_onScroll);
    _path = widget.categories.isEmpty ? [] : [widget.categories.first];
    if (_path.isNotEmpty) {
      _loadProductsForCategory(_path.last);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _productBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  void _loadProductsForCategory(CategoryModel category) {
    _productBloc.add(LoadProducts(FilterModel(categoryId: category.id)));
  }

  // Häzirki derejedäki doganlyk (sibling) kategoriýalar - çep sanaw
  List<CategoryModel> get _siblings =>
      _path.length <= 1 ? widget.categories : _path[_path.length - 2].children;

  CategoryModel? get _focus => _path.isEmpty ? null : _path.last;

  // Çep sanawdan saýlama - şol bir derejede çalyşma
  void _selectSibling(CategoryModel category) {
    if (category.children.isEmpty) {
      _openCategoryDetail(category);
      return;
    }
    setState(() {
      _path = _path.isEmpty
          ? [category]
          : [..._path.sublist(0, _path.length - 1), category];
    });
    _loadProductsForCategory(category);
  }

  // Sag sanawa basmak - has çuňňur derejä geçmek (agaç boýunça aşak düşmek)
  void _drillInto(CategoryModel category) {
    if (category.children.isEmpty) {
      _openCategoryDetail(category);
      return;
    }
    setState(() => _path = [..._path, category]);
    _loadProductsForCategory(category);
  }

  // Iň soňky (leaf) kategoriýa üçin aýratyn ekrana geçmek
  void _openCategoryDetail(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(category: category),
      ),
    );
  }

  void _jumpToBreadcrumb(int index) {
    setState(() => _path = _path.sublist(0, index + 1));
    _loadProductsForCategory(_path.last);
  }

  bool get _canPopScreen => _path.length <= 1;

  void _popOneLevel() {
    setState(() => _path = _path.sublist(0, _path.length - 1));
    _loadProductsForCategory(_path.last);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<MainBloc>().state.languageCode;
    final focus = _focus;

    return PopScope(
      canPop: _canPopScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _popOneLevel();
      },
      child: SafeArea(
        child: BlocProvider.value(
          value: _productBloc,
          child: Column(
            children: [
              CategoryBreadcrumbWidget(
                path: _path,
                languageCode: languageCode,
                onSegmentTap: _jumpToBreadcrumb,
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 30,
                      child: CategorySiblingsListWidget(
                        categories: _siblings,
                        selected: focus,
                        onTap: _selectSibling,
                      ),
                    ),

                    Flexible(
                      flex: 70,
                      child: focus == null
                          ? const SizedBox.shrink()
                          : CategoryFocusPanelWidget(
                              focus: focus,
                              languageCode: languageCode,
                              scrollController: _scrollController,
                              onChildTap: _drillInto,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
