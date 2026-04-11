import 'package:coding_interview_frontend/core/utils/currency_catalog.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_event.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '100');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ConversionBloc>().add(const ConversionAppStarted());
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ConversionBloc, ConversionState>(
          builder: (BuildContext context, ConversionState state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<Currency>(
                  initialValue: state.sourceCurrency,
                  decoration: const InputDecoration(labelText: 'Input currency'),
                  items: <Currency>[
                    ...CurrencyCatalog.fiat,
                    CurrencyCatalog.usdtTron,
                  ].map((Currency currency) {
                    return DropdownMenuItem<Currency>(
                      value: currency,
                      child: Text(currency.code),
                    );
                  }).toList(),
                  onChanged: (Currency? value) {
                    if (value != null) {
                      context.read<ConversionBloc>().add(
                            SourceCurrencyChanged(value),
                          );
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Currency>(
                  initialValue: state.fiatCurrency,
                  decoration: const InputDecoration(labelText: 'Fiat currency'),
                  items: CurrencyCatalog.fiat.map((Currency currency) {
                    return DropdownMenuItem<Currency>(
                      value: currency,
                      child: Text(currency.code),
                    );
                  }).toList(),
                  onChanged: (Currency? value) {
                    if (value != null) {
                      context.read<ConversionBloc>().add(
                            FiatCurrencyChanged(value),
                          );
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Amount'),
                  onChanged: (String value) {
                    context.read<ConversionBloc>().add(AmountChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<ConversionBloc>().add(
                                const ConvertRequested(),
                              );
                        },
                  child: const Text('Convert'),
                ),
                const SizedBox(height: 20),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.errorMessage != null)
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                else if (state.quote != null)
                  Text(
                    'Rate: ${state.quote!.rate.toStringAsFixed(6)}\n'
                    'You receive: ${state.quote!.convertedAmount.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
