import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/theme/conversion_colors.dart';
import 'package:flutter/material.dart';

/// Flag / code / chevron row used inside the swap pill (no border).
class CurrencySelectorTriggerBody extends StatelessWidget {
  const CurrencySelectorTriggerBody({
    required this.currency,
    super.key,
  });

  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            currency.assetPath,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          currency.code,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ConversionColors.amountValue,
                fontWeight: FontWeight.w600,
              ),
        ),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: ConversionColors.chevron,
          size: 28,
        ),
      ],
    );
  }
}
