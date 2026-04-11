import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/theme/conversion_colors.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/widgets/currency_selector_trigger_body.dart';
import 'package:flutter/material.dart';

/// Single bordered pill with legend labels and a centered swap control.
class CurrencySwapPill extends StatelessWidget {
  const CurrencySwapPill({
    required this.leftCurrency,
    required this.rightCurrency,
    required this.onLeftTap,
    required this.onRightTap,
    required this.onSwap,
    super.key,
  });

  final Currency leftCurrency;
  final Currency rightCurrency;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final VoidCallback onSwap;

  static const double _pillRadius = 26;
  static const double _swapDiameter = 56;
  static const double _swapSlotWidth = 48;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_pillRadius),
              border: Border.all(
                color: ConversionColors.accent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double swapLeft =
                      (constraints.maxWidth - _swapDiameter) / 2;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                key: const Key('currency_swap_pill_left'),
                                onTap: onLeftTap,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: CurrencySelectorTriggerBody(
                                    currency: leftCurrency,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: _swapSlotWidth),
                          Flexible(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                key: const Key('currency_swap_pill_right'),
                                onTap: onRightTap,
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: CurrencySelectorTriggerBody(
                                    currency: rightCurrency,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -10,
                        left: swapLeft,
                        child: SizedBox(
                          width: _swapDiameter,
                          height: _swapDiameter,
                          child: Material(
                            key: const Key('currency_swap_pill_swap'),
                            color: ConversionColors.accent,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onSwap,
                              child: const Center(
                                child: Icon(
                                  Icons.swap_horiz_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 18,
          child: _LegendLabel(
            text: 'TENGO',
            style: textTheme.labelSmall?.copyWith(
              color: ConversionColors.summaryText,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 18,
          child: _LegendLabel(
            text: 'QUIERO',
            style: textTheme.labelSmall?.copyWith(
              color: ConversionColors.summaryText,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendLabel extends StatelessWidget {
  const _LegendLabel({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
