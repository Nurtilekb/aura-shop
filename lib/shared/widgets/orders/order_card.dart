import 'package:aurashop/shared/models/order_model.dart';
import 'package:aurashop/shared/models/order_status.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.order, this.onStatusChanged});

  final OrderItem order;
  final ValueChanged<String>? onStatusChanged;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.order.status;
  }

  Color _statusColor(String status) {
    return OrderStatusPalette.textColor(status);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 0.6, color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  Text(
                    '${widget.order.total} ₽',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.order.items.join(' • '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFE5E5EA), height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Статус:',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: widget.onStatusChanged == null
                            ? null
                            : () {
                                _selectStatus(context);
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: const Color(0xFFE5E5EA),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              // If user cannot change status, show larger static status
                              widget.onStatusChanged == null
                                  ? Expanded(
                                      child: Text(
                                        _status,
                                        style: TextStyle(
                                          color: _statusColor(_status),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            _status,
                                            style: TextStyle(
                                              color: _statusColor(_status),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStatus(BuildContext context) async {
    final selectedStatus = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Статус заказа',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              for (final status in OrderStatusPalette.labels)
                ListTile(
                  leading: Icon(
                    status == _status
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: _statusColor(status),
                  ),
                  title: Text(status),
                  onTap: () => Navigator.pop(context, status),
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selectedStatus == null || selectedStatus == _status || !mounted) {
      return;
    }

    setState(() {
      _status = selectedStatus;
    });
    widget.onStatusChanged?.call(selectedStatus);
  }
}
