import 'package:flutter/material.dart';

/// Generic bottom-sheet picker — used for both region and city selection in
/// [AddressFormSheet], each just supplying its own [fetch] call and label.
/// Lists the full result set with no search input; the [fetch] signature
/// still takes a text query for symmetry with the search endpoints, but is
/// always called with an empty string.
class LocationPickerSheet<T> extends StatefulWidget {
  const LocationPickerSheet({
    super.key,
    required this.title,
    required this.fetch,
    required this.labelOf,
  });

  final String title;
  final Future<({List<T> items, int count})> Function(String text) fetch;
  final String Function(T item) labelOf;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Future<({List<T> items, int count})> Function(String text) fetch,
    required String Function(T item) labelOf,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          LocationPickerSheet<T>(title: title, fetch: fetch, labelOf: labelOf),
    );
  }

  @override
  State<LocationPickerSheet<T>> createState() => _LocationPickerSheetState<T>();
}

class _LocationPickerSheetState<T> extends State<LocationPickerSheet<T>> {
  List<T> _items = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.fetch('');
      if (!mounted) return;
      setState(() {
        _items = result.items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_items.isEmpty) {
      return const Center(child: Text('Netije tapylmady'));
    }
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          title: Text(widget.labelOf(item)),
          onTap: () => Navigator.of(context).pop(item),
        );
      },
    );
  }
}
