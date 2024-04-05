import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class MyScrollPagination extends StatelessWidget {
  const MyScrollPagination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class Item {
  final int id;

  Item(this.id);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, Item> _pagingController =
  PagingController(firstPageKey: 0);

  Future<List<Item>> _fetchPage(int pageKey) async {
    try {
      // Generate a list of items based on the pageKey
      final List<Item> items =
      List.generate(10, (index) => Item(pageKey * 10 + index));
      // Return the fetched data
      return items;
    } catch (error) {
      // Handle error and return an empty list
      _pagingController.error = error;
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey).then((items) {
        _pagingController.appendPage(items, pageKey + 1);
      });
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll'),
      ),
      body: PagedListView<int, Item>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Item>(
          itemBuilder: (context, item, index) => ListTile(
            title: Text('Item ${item.id}'),
          ),
          firstPageErrorIndicatorBuilder: (context) => const Center(
            child: Text('Error loading data!'),
          ),
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Text('No items found.'),
          ),
        ),
      ),
    );
  }
}
