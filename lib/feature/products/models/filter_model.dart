class FilterModel {
  final int? selectedCategory;
  final String? search;
  final double? minPrce;
  final double? maxPrice;

  FilterModel({
    required this.selectedCategory,
    required this.search,
    required this.minPrce,
    required this.maxPrice,
  });
}
