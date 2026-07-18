/// The coins API serializes decimal fields (money, coin amounts) as either
/// JSON numbers or numeric strings (e.g. `"amount_tmt": "50.00"`) depending
/// on the endpoint, so every model parses them through this helper instead
/// of a plain `as num?` cast.
double parseCoinDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}
