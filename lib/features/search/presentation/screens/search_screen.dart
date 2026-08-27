import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/repositories/product_repository.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final ProductRepository _productRepository = ProductRepository();

  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        title: _buildSearchField(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 8),
      child: AppInputWidget(
        focusNode: _searchFocusNode,
        isBorder: true,
        borderColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _isSearching = value.isNotEmpty;
          });
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        filledColor: Colors.transparent,
        hintText: 'Поиск товаров...',
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('🔍', style: TextStyle(fontSize: 20)),
        ),
        trailing: IconButton(
          icon: Icon(Icons.settings),
          iconSize: 15,
          onPressed: () {
            setState(() {
              _searchController.clear();
              _searchQuery = '';
              _isSearching = false;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isSearching) {
      return _buildSearchResults();
    }
    return _buildInitialState();
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ИСТОРИЯ ПОИСКА',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {});
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Очистить',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<List<Product>>(
      stream: _productRepository.watchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildEmptyState('Не удалось загрузить товары');
        }

        final query = _searchQuery.trim().toLowerCase();
        final results = (snapshot.data ?? const <Product>[])
            .where((product) {
              return product.name.toLowerCase().contains(query) ||
                  product.category.toLowerCase().contains(query) ||
                  product.description.toLowerCase().contains(query);
            })
            .toList(growable: false);

        if (results.isEmpty) return _buildEmptyState('Ничего не найдено');
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: results.length,
          separatorBuilder: (_, _) => const Divider(height: 0.5),
          itemBuilder: (context, index) => _buildProductItem(results[index]),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить запрос',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return InkWell(
      onTap: () => context.router.push(ProductDetailRoute(product: product)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.search, size: 18, color: Colors.grey.shade500),
            ),
            const SizedBox(width: 1),
            Expanded(
              child: Text(
                maxLines: 2,
                product.name,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            SizedBox(width: 10),
            Text('${product.price} ₽'),
          ],
        ),
      ),
    );
  }
}
