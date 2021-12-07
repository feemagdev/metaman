class Token {
  final String contractName;
  final String contractTickerSymbol;
  final int contractDecimals;
  final String contractAddress;
  final int coin;
  final String type;
  final String balance;
  final double quote;
  final double quoteRate;
  final String logoUrl;
  final String quoteRate24h;
  final double quoteRate24hPercent;

  Token({
    required this.contractName,
    required this.contractTickerSymbol,
    required this.contractDecimals,
    required this.contractAddress,
    required this.coin,
    required this.type,
    required this.balance,
    required this.quote,
    required this.quoteRate,
    required this.logoUrl,
    required this.quoteRate24h,
    required this.quoteRate24hPercent,
  });
  factory Token.fromMap(Map<String, dynamic> data) {
    return Token(
        contractName: data['contract_name'],
        contractTickerSymbol: data['contract_ticker_symbol'],
        contractDecimals: data['contract_decimals'],
        contractAddress: data['contract_address'],
        coin: data['coin'],
        type: data['type'],
        balance: data['balance'],
        quote: data['quote'].toDouble(),
        quoteRate: data['quote_rate'].toDouble(),
        logoUrl: data['logo_url'],
        quoteRate24h: data['quote_rate_24h'],
        quoteRate24hPercent: data['quote_pct_change_24h'].toDouble());
  }
}
