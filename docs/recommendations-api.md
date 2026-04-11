# Public Conversion API

Reference for the El Dorado–style **orderbook public Conversion** endpoint used by this project.

## Endpoint

- **Method:** `GET`
- **Base URL:**  
  `https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations`

## Query parameters

| Parameter            | Description |
|----------------------|-------------|
| `type`               | `0` = CRYPTO → FIAT, `1` = FIAT → CRYPTO |
| `cryptoCurrencyId`   | Crypto id from the asset file name (e.g. `TATUM-TRON-USDT`) |
| `fiatCurrencyId`     | Fiat id from the asset file name (e.g. `BRL`) |
| `amount`             | Amount to convert |
| `amountCurrencyId`   | Id of the currency in which `amount` is expressed |

Currency ids are **strings** (not numeric), matching the asset naming convention in the repo.

## Example request (captured)

Full URL:

```http
GET https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations?type=0&cryptoCurrencyId=TATUM-TRON-USDT&fiatCurrencyId=BRL&amount=100&amountCurrencyId=BRL
```

## Response shape

The JSON root is a single object with a `data` property. Under `data` there are **three** Conversion buckets, each containing a full **offer** payload (same overall structure in typical responses):

| Key             | Role |
|-----------------|------|
| `data.byPrice`  | Conversion biased toward price |
| `data.bySpeed`  | Conversion biased toward speed |
| `data.byReputation` | Conversion biased toward reputation |

Each of those objects includes (non-exhaustive):

- **Offer identity:** `offerId`, `offerStatus`, `offerType`, `createdAt`, `description`
- **Currencies:** `cryptoCurrencyId`, `chain`, `fiatCurrencyId`
- **Rate:** `fiatToCryptoExchangeRate` — returned as a **string** in JSON (e.g. `"5.1"`). Parse to a number in the client.
- **Limits:** `limits.crypto` / `limits.fiat` with `maxLimit`, `minLimit`, `marketSize`, `availableSize` (often high-precision decimals as strings)
- **Counterparty:** `user` (e.g. `id`, `username`), `offerMakerStats`, `mmScore`, `mtScore`, score tiers, `scorePerFeature`, etc.
- **Operational:** `paymentMethods`, `paused`, `visibility`, `escrow`, flags such as `orderRequestEnabled`, `allowsThirdPartyPayments`, etc.

In the sample capture, `byPrice`, `bySpeed`, and `byReputation` pointed at the **same** `offerId` with the same `fiatToCryptoExchangeRate`; in other market conditions they may differ.

### Field used by this app

The Flutter client reads **`data.byPrice.fiatToCryptoExchangeRate`** and combines it with `type` and `amount` to derive the displayed converted amount (see `ConversionResponseModel` and `ConversionRepositoryImpl`).

## Sample response file

A verbatim JSON body for the example request above is stored at:

[`docs/samples/recommendations-type0.response.json`](samples/recommendations-type0.response.json)

Use it for fixtures, Postman mocks, or diffing against live responses. Unit tests load this file directly (`conversion_response_model_test.dart`) so parsing stays aligned with a real captured body.

## Notes

- **Types:** Many numeric-looking values are serialized as **strings** to preserve precision.
- **Stability:** Extra fields may appear; clients should tolerate unknown keys.
- **Manual testing:** Paste the example `GET` URL into a browser or Postman; compare with the sample file and with `ConversionApiService.buildConversionUri` in code.
