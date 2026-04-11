import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/utils/currency_sheet_subtitles.dart';
import 'package:flutter/material.dart';

Future<void> showFiatCurrencyPicker(
  BuildContext context, {
  required List<Currency> currencies,
  required Currency selected,
  required ValueChanged<Currency> onPicked,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return _CurrencyPickerSheet(
        title: 'FIAT',
        currencies: currencies,
        selected: selected,
        onPicked: (Currency c) {
          onPicked(c);
          Navigator.of(sheetContext).pop();
        },
      );
    },
  );
}

Future<void> showCryptoCurrencyPicker(
  BuildContext context, {
  required List<Currency> currencies,
  required Currency selected,
  required ValueChanged<Currency> onPicked,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return _CurrencyPickerSheet(
        title: 'Cripto',
        currencies: currencies,
        selected: selected,
        onPicked: (Currency c) {
          onPicked(c);
          Navigator.of(sheetContext).pop();
        },
      );
    },
  );
}

class _CurrencyPickerSheet extends StatelessWidget {
  const _CurrencyPickerSheet({
    required this.title,
    required this.currencies,
    required this.selected,
    required this.onPicked,
  });

  final String title;
  final List<Currency> currencies;
  final Currency selected;
  final ValueChanged<Currency> onPicked;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: currencies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Currency c = currencies[index];
                    final bool isSelected = c.id == selected.id;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          c.assetPath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        c.code,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        CurrencySheetSubtitles.forCurrency(c),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected ? Colors.black87 : Colors.grey,
                      ),
                      onTap: () => onPicked(c),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
