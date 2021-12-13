// ignore_for_file: prefer_typing_uninitialized_variables

class TokenMarketModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final String balance;
  final int contractDecimals;
  var currentPrice;
  var marketCap;
  var priceChange24h;
  var priceChange7d;
  var priceChange30d;

  TokenMarketModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.marketCap,
    required this.priceChange24h,
    required this.priceChange30d,
    required this.priceChange7d,
    required this.currentPrice,
    required this.balance,
    required this.contractDecimals,
  });

  factory TokenMarketModel.from(
      Map<String, dynamic> data, String balance, int contractDecimals) {
    return TokenMarketModel(
      id: data['id'] ?? '',
      symbol: data['symbol'] ?? '',
      name: data['name'] ?? '',
      marketCap: data['market_cap'] ?? 0.0,
      priceChange24h: data['price_change_percentage_24h_in_currency'] ?? 0.0,
      priceChange30d: data['price_change_percentage_30d_in_currency'] ?? 0.0,
      priceChange7d: data['price_change_percentage_7d_in_currency'] ?? 0.0,
      currentPrice: data['current_price'] ?? 0.0,
      image: data['image'] ?? '',
      balance: balance,
      contractDecimals: contractDecimals,
    );
  }
}
