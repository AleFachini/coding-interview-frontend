import 'package:coding_interview_frontend/core/utils/currency_catalog.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_event.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_state.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/theme/conversion_colors.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/widgets/conversion_background.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/widgets/currency_bottom_sheets.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/widgets/currency_swap_pill.dart';
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
    _amountController = TextEditingController(text: '5.00');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _openLeftPicker(BuildContext context, ConversionState state) {
    if (state.rightCurrency.type == CurrencyType.fiat) {
      return showCryptoCurrencyPicker(
        context,
        currencies: <Currency>[CurrencyCatalog.usdtTron],
        selected: state.leftCurrency,
        onPicked: (Currency c) {
          context.read<ConversionBloc>().add(LeftCurrencyChanged(c));
        },
      );
    }
    return showFiatCurrencyPicker(
      context,
      currencies: CurrencyCatalog.fiat,
      selected: state.leftCurrency,
      onPicked: (Currency c) {
        context.read<ConversionBloc>().add(LeftCurrencyChanged(c));
      },
    );
  }

  Future<void> _openRightPicker(BuildContext context, ConversionState state) {
    if (state.leftCurrency.type == CurrencyType.crypto) {
      return showFiatCurrencyPicker(
        context,
        currencies: CurrencyCatalog.fiat,
        selected: state.rightCurrency,
        onPicked: (Currency c) {
          context.read<ConversionBloc>().add(RightCurrencyChanged(c));
        },
      );
    }
    return showCryptoCurrencyPicker(
      context,
      currencies: <Currency>[CurrencyCatalog.usdtTron],
      selected: state.rightCurrency,
      onPicked: (Currency c) {
        context.read<ConversionBloc>().add(RightCurrencyChanged(c));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ConversionColors.scaffoldBackground,
      body: SafeArea(
        child: ConversionBackground(
          child: BlocConsumer<ConversionBloc, ConversionState>(
            listenWhen: (ConversionState p, ConversionState c) =>
                p.amountText != c.amountText,
            listener: (BuildContext context, ConversionState state) {
              if (_amountController.text != state.amountText) {
                _amountController.text = state.amountText;
                _amountController.selection = TextSelection.collapsed(
                  offset: state.amountText.length,
                );
              }
            },
            builder: (BuildContext context, ConversionState state) {
              return Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ConversionColors.card,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CurrencySwapPill(
                            leftCurrency: state.leftCurrency,
                            rightCurrency: state.rightCurrency,
                            onLeftTap: () => _openLeftPicker(context, state),
                            onRightTap: () => _openRightPicker(context, state),
                            onSwap: () {
                              context.read<ConversionBloc>().add(
                                    const SwapCurrenciesRequested(),
                                  );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: textTheme.titleMedium?.copyWith(
                              color: ConversionColors.amountValue,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              prefixText: '${state.leftCurrency.code} ',
                              prefixStyle: textTheme.titleMedium?.copyWith(
                                color: ConversionColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: ConversionColors.accent,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: ConversionColors.accent,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: ConversionColors.accentDark,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (String value) {
                              final String normalizedValue =
                                  _normalizeAmountForDisplay(value);
                              context.read<ConversionBloc>().add(
                                    AmountChanged(normalizedValue),
                                  );
                            },
                          ),
                          const SizedBox(height: 20),
                          _SummaryRow(
                            label: 'Tasa estimada',
                            value: state.quote != null
                                ? '≈ ${state.quote!.rate.toStringAsFixed(2)} ${state.fiatSide.code}'
                                : '—',
                          ),
                          const SizedBox(height: 10),
                          _SummaryRow(
                            label: 'Recibirás',
                            value: state.quote != null
                                ? '≈ ${state.quote!.convertedAmount.toStringAsFixed(2)} ${_outputCurrencyCode(state)}'
                                : '—',
                          ),
                          const SizedBox(height: 10),
                          const _SummaryRow(
                            label: 'Tiempo estimado',
                            value: '≈ 10 Min',
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: ConversionColors.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      context.read<ConversionBloc>().add(
                                            const ConvertRequested(),
                                          );
                                    },
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Cambiar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          if (state.errorMessage != null) ...<Widget>[
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _outputCurrencyCode(ConversionState state) {
    return state.requestType == 0 ? state.fiatSide.code : state.cryptoSide.code;
  }

  String _normalizeAmountForDisplay(String rawValue) {
    final String value = rawValue.trim().replaceAll(',', '.');
    if (value.isEmpty) {
      return value;
    }

    final double? parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return value;
    }

    return parsedValue.toStringAsFixed(2);
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ConversionColors.summaryText,
              ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ConversionColors.summaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
