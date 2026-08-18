import 'package:aurashop/widgets/app_input_widget.dart';
import 'package:aurashop/widgets/custom_widgets/popu;ar_chips_widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = ['худи oversize', 'рюкзак городской'];
  final List<String> _popularQueries = [
    'Наушники',
    'Куртка зима',
    'Часы',
    'Платье',
    'Кроссовки',
  ];

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
        isBorder: true,
        borderColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _isSearching = value.isNotEmpty;
          });
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        filledColor: Colors.white,
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

  // Начальное состояние с историей и популярными запросами
  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // История поиска
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
                  setState(() {
                    // Очистить историю
                  });
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

          // Список истории
          ..._searchHistory.map((query) => _buildHistoryItem(query)).toList(),

          if (_searchHistory.isNotEmpty) const SizedBox(height: 24),

          // Популярные запросы
          const Text(
            'ПОПУЛЯРНЫЕ ЗАПРОСЫ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          // Чипы популярных запросов
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularQueries
                .map((query) => PopularChips(query: query))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String query) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.history, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              query,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Удалить из истории
            },
            child: Icon(Icons.clear, size: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // Результаты поиска
  Widget _buildSearchResults() {
    // Имитация результатов поиска
    final results = _getSearchResults(_searchQuery);

    if (results.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) => _buildResultItem(results[index]),
    );
  }

  // Пустое состояние (нет результатов)
  Widget _buildEmptyState() {
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
            'Ничего не найдено',
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

  Widget _buildResultItem(String result) {
    return Container(
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
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Имитация поиска
  List<String> _getSearchResults(String query) {
    final allItems = [
      'Худи oversize черный',
      'Худи oversize белый',
      'Рюкзак городской черный',
      'Рюкзак городской синий',
      'Наушники беспроводные',
      'Куртка зимняя',
      'Часы наручные',
      'Платье летнее',
      'Кроссовки белые',
    ];

    if (query.isEmpty) return [];

    return allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
