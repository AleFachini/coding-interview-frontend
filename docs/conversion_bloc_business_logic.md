# Conversion bloc business logic

This document explains the business logic implemented in `ConversionBloc` for the conversion feature.

## Purpose

`ConversionBloc` coordinates the conversion flow between UI events and domain use cases. It is responsible for:

- Tracking selected currencies and input amount.
- Building a stable conversion query contract.
- Applying conversion math based on direction in presentation logic.
- Managing loading, quote, and error states.

## Key state fields

The bloc works mainly with these `ConversionState` fields:

- `leftCurrency`: currency shown in **tengo** (input side).
- `rightCurrency`: currency shown in **quiero** (output side).
- `amountCurrency`: currency that `amountText` belongs to (sent as `amountCurrencyId`).
- `amountText`: user input amount as text.
- `quote`: computed output (`rate` + `convertedAmount`) shown in summary.
- `isLoading`: active request flag.
- `errorMessage`: user-facing validation or API calculation error.

Direction is inferred from `leftCurrency.type`:

- `crypto -> fiat` when left is crypto.
- `fiat -> crypto` when left is fiat.

## Request normalization strategy

The bloc uses a fixed request builder for API calls:

- `type` is always forced to `0`.
- `cryptoCurrencyId` is fixed to USDT (catalog value used in the feature).
- `fiatCurrencyId` comes from the currently selected fiat side.
- `amount` comes from parsed user input.
- `amountCurrencyId` comes from the current input side (`amountCurrency`).

This keeps the query shape stable regardless of UI direction while still letting the user choose fiat side and input side correctly.

## Conversion formula responsibility

The data layer now provides the exchange rate as source-of-truth.  
The bloc computes `convertedAmount` based on current transaction direction:

- if `crypto -> fiat`: `convertedAmount = amount * rate`
- if `fiat -> crypto`: `convertedAmount = amount / rate`

Guard:

- If `rate <= 0`, conversion is treated as invalid and bloc emits a controlled error state.

## Event-by-event behavior

### Left Currency Changed

- Updates `leftCurrency`.
- Aligns `amountCurrency` with the new left side (input side).
- Clears previous quote and error because direction/input context changed.

### Right Currency Changed

- Updates `rightCurrency`.
- Clears previous quote and error.

### Amount Changed

- Updates `amountText`.
- Clears previous quote and error to avoid showing stale calculations.

### Swap Currencies Requested

- Swaps `leftCurrency` and `rightCurrency`.
- Moves `amountCurrency` to new left side.
- If a valid quote exists and current amount is valid:
  - Keeps the same fetched rate.
  - Moves previous output amount into `amountText` (because after swap that becomes new input).
  - Recomputes `convertedAmount` using the new direction math.
- If quote is not reusable, clears quote.

This behavior avoids stale/inverted-rate issues and keeps swap mathematically consistent with the current business rule.

### Convert Requested

1. Parse and validate `amountText`.
   - If invalid or `<= 0`, emit validation error and stop.
2. Emit loading state.
3. Call use case with normalized request params (`type=0`).
4. Apply direction math in bloc (`*` or `/` by direction).
5. Emit quote on success, or controlled error if rate invalid.
6. On domain failure, emit mapped error message and clear quote.

## Why this design?

- Keeps API query contract stable.
- Centralizes direction-sensitive business rules in one place (`ConversionBloc`).
- Preserves clean architecture boundaries:
  - data layer: fetch/parsing and failure mapping.
  - presentation bloc: UI-facing conversion behavior.
- Makes direction math testable with bloc tests.

## Covered test expectations

Current bloc tests validate:

- Fixed query type (`type=0`) in both directions.
- Multiply path for `crypto -> fiat`.
- Divide path for `fiat -> crypto`.
- Controlled error when rate is invalid (`rate <= 0`).
- Swap recalculation behavior with existing quote.

