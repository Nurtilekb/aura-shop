import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:flutter/material.dart';

class TransperetContWidget extends StatefulWidget {
  const TransperetContWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isIncenterWidget,
    this.leadWidget,
    this.adress,
  });
  final String label;
  final String value;
  final String icon;
  final Widget? isIncenterWidget;
  final Widget? leadWidget;
  final String? adress;
  @override
  State<TransperetContWidget> createState() => _TransperetContWidgetState();
}

class _TransperetContWidgetState extends State<TransperetContWidget> {
  final TextEditingController _tempController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: colorScheme.primary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.leadWidget ??
              Text(widget.icon, style: TextStyle(fontSize: 25)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),

                Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          widget.isIncenterWidget ??
              TextButton(
                child: Text(
                  'Изм.',
                  style: TextStyle(color: colorScheme.primary),
                ),

                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(_focusNode);
                      });
                      return AlertDialog(
                        title: const Text('Редактирование'),
                        content: AppInputWidget(
                          label: widget.adress,

                          controller: _tempController,
                          focusNode: _focusNode, // Автофокус
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите имя';
                            }
                            return null;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Отмена'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_tempController.text.isNotEmpty) {
                                Navigator.pop(context, _tempController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Сохранено: ${_tempController.text}',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text('Сохранить'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
        ],
      ),
    );
  }
}
