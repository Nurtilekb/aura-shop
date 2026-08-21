class OrderItem {
  const OrderItem({
    required this.id,
    required this.status,
    required this.date,
    required this.total,
    required this.items,
  });

  final String id;
  final String status;
  final String date;
  final int total;
  final List<String> items;
}
