import 'package:easy_localization/easy_localization.dart';

/// Single source of truth for app currency.
///
/// Contains all world currencies with code, name, symbol, and country flag.
///
/// Language rules:
/// - MMK:
///   - If language is Myanmar ('my') -> 'ကျပ်'
///   - If language is English ('en') -> 'MMK'
/// - Any other currency (USD $, EUR €, GBP £, THB ฿, etc.):
///   - Always maintains its symbol in both languages.
class AppCurrency {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final bool symbolPrefix;

  const AppCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    this.symbolPrefix = false,
  });

  bool get isMmk => code.toUpperCase() == 'MMK';
  bool get isUsd => code.toUpperCase() == 'USD';

  /// Returns the currency symbol/unit string based on [languageCode]:
  /// - MMK: 'ကျပ်' (if 'my'), 'MMK' (if 'en' or other)
  /// - All other world currencies: unchanged [symbol]
  String unit(String languageCode) {
    if (isMmk) {
      return languageCode == 'my' ? 'ကျပ်' : 'MMK';
    }
    return symbol;
  }

  /// Clean display label for dropdowns.
  ///
  /// Examples:
  /// - MMK in 'my': 'MMK (ကျပ်)'
  /// - MMK in 'en': 'MMK'
  /// - USD: 'USD ($)'
  /// - THB: 'THB (฿)'
  String dropdownLabel(String languageCode) {
    if (isMmk) {
      return languageCode == 'my' ? 'MMK (ကျပ်)' : 'MMK';
    }
    return '$code ($symbol)';
  }

  /// Formats an amount with this currency according to [languageCode].
  String format(num amount, String languageCode) {
    if (isMmk) {
      final formattedNumber = NumberFormat('#,###').format(amount.round());
      return '$formattedNumber ${unit(languageCode)}';
    }

    final isWhole = amount % 1 == 0;
    final formattedNumber = isWhole
        ? NumberFormat('#,###').format(amount)
        : NumberFormat('#,###.00').format(amount);

    if (symbolPrefix) {
      return '$symbol$formattedNumber';
    }
    return '$formattedNumber $symbol';
  }

  static const AppCurrency mmk = AppCurrency(
    code: 'MMK',
    name: 'Myanmar Kyat',
    symbol: 'MMK',
    flag: '🇲🇲',
  );

  static const AppCurrency usd = AppCurrency(
    code: 'USD',
    name: 'US Dollar',
    symbol: r'$',
    flag: '🇺🇸',
    symbolPrefix: true,
  );

  static AppCurrency fromStorage(String? value) {
    if (value == null || value.isEmpty) return AppCurrency.mmk;
    if (value == r'$' || value.toUpperCase() == 'USD') return AppCurrency.usd;
    final upper = value.toUpperCase();
    for (final c in allCurrencies) {
      if (c.code.toUpperCase() == upper) return c;
    }
    return AppCurrency.mmk;
  }

  static AppCurrency fromCode(String code) => fromStorage(code);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppCurrency && other.code.toUpperCase() == code.toUpperCase());

  @override
  int get hashCode => code.toUpperCase().hashCode;

  @override
  String toString() => '$flag $code ($symbol)';

  static const List<AppCurrency> popularCurrencies = [
    mmk,
    usd,
    AppCurrency(code: 'THB', name: 'Thai Baht', symbol: '฿', flag: '🇹🇭'),
    AppCurrency(code: 'SGD', name: 'Singapore Dollar', symbol: r'S$', flag: '🇸🇬', symbolPrefix: true),
    AppCurrency(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', flag: '🇲🇾', symbolPrefix: true),
    AppCurrency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺', symbolPrefix: true),
    AppCurrency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧', symbolPrefix: true),
    AppCurrency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵', symbolPrefix: true),
    AppCurrency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳', symbolPrefix: true),
    AppCurrency(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳', symbolPrefix: true),
    AppCurrency(code: 'KRW', name: 'South Korean Won', symbol: '₩', flag: '🇰🇷', symbolPrefix: true),
    AppCurrency(code: 'AUD', name: 'Australian Dollar', symbol: r'A$', flag: '🇦🇺', symbolPrefix: true),
    AppCurrency(code: 'CAD', name: 'Canadian Dollar', symbol: r'C$', flag: '🇨🇦', symbolPrefix: true),
    AppCurrency(code: 'AED', name: 'UAE Dirham', symbol: 'AED', flag: '🇦🇪'),
  ];

  static const List<AppCurrency> allCurrencies = [
    AppCurrency(code: 'MMK', name: 'Myanmar Kyat', symbol: r'MMK', flag: '🇲🇲'),
    AppCurrency(code: 'USD', name: 'US Dollar', symbol: r'$', flag: '🇺🇸', symbolPrefix: true),
    AppCurrency(code: 'THB', name: 'Thai Baht', symbol: r'฿', flag: '🇹🇭'),
    AppCurrency(code: 'SGD', name: 'Singapore Dollar', symbol: r'S$', flag: '🇸🇬', symbolPrefix: true),
    AppCurrency(code: 'MYR', name: 'Malaysian Ringgit', symbol: r'RM', flag: '🇲🇾', symbolPrefix: true),
    AppCurrency(code: 'EUR', name: 'Euro', symbol: r'€', flag: '🇪🇺', symbolPrefix: true),
    AppCurrency(code: 'GBP', name: 'British Pound', symbol: r'£', flag: '🇬🇧', symbolPrefix: true),
    AppCurrency(code: 'JPY', name: 'Japanese Yen', symbol: r'¥', flag: '🇯🇵', symbolPrefix: true),
    AppCurrency(code: 'CNY', name: 'Chinese Yuan', symbol: r'¥', flag: '🇨🇳', symbolPrefix: true),
    AppCurrency(code: 'INR', name: 'Indian Rupee', symbol: r'₹', flag: '🇮🇳', symbolPrefix: true),
    AppCurrency(code: 'KRW', name: 'South Korean Won', symbol: r'₩', flag: '🇰🇷', symbolPrefix: true),
    AppCurrency(code: 'AUD', name: 'Australian Dollar', symbol: r'A$', flag: '🇦🇺', symbolPrefix: true),
    AppCurrency(code: 'CAD', name: 'Canadian Dollar', symbol: r'C$', flag: '🇨🇦', symbolPrefix: true),
    AppCurrency(code: 'CHF', name: 'Swiss Franc', symbol: r'CHF', flag: '🇨🇭'),
    AppCurrency(code: 'HKD', name: 'Hong Kong Dollar', symbol: r'HK$', flag: '🇭🇰', symbolPrefix: true),
    AppCurrency(code: 'TWD', name: 'New Taiwan Dollar', symbol: r'NT$', flag: '🇹🇼', symbolPrefix: true),
    AppCurrency(code: 'NZD', name: 'New Zealand Dollar', symbol: r'NZ$', flag: '🇳🇿', symbolPrefix: true),
    AppCurrency(code: 'AED', name: 'UAE Dirham', symbol: r'AED', flag: '🇦🇪'),
    AppCurrency(code: 'SAR', name: 'Saudi Riyal', symbol: r'SAR', flag: '🇸🇦'),
    AppCurrency(code: 'QAR', name: 'Qatari Riyal', symbol: r'QAR', flag: '🇶🇦'),
    AppCurrency(code: 'KWD', name: 'Kuwaiti Dinar', symbol: r'KWD', flag: '🇰🇼'),
    AppCurrency(code: 'BHD', name: 'Bahraini Dinar', symbol: r'BHD', flag: '🇧🇭'),
    AppCurrency(code: 'OMR', name: 'Omani Rial', symbol: r'OMR', flag: '🇴🇲'),
    AppCurrency(code: 'IDR', name: 'Indonesian Rupiah', symbol: r'Rp', flag: '🇮🇩', symbolPrefix: true),
    AppCurrency(code: 'VND', name: 'Vietnamese Dong', symbol: r'₫', flag: '🇻🇳'),
    AppCurrency(code: 'PHP', name: 'Philippine Peso', symbol: r'₱', flag: '🇵🇭', symbolPrefix: true),
    AppCurrency(code: 'TRY', name: 'Turkish Lira', symbol: r'₺', flag: '🇹🇷', symbolPrefix: true),
    AppCurrency(code: 'RUB', name: 'Russian Ruble', symbol: r'₽', flag: '🇷🇺'),
    AppCurrency(code: 'BRL', name: 'Brazilian Real', symbol: r'R$', flag: '🇧🇷', symbolPrefix: true),
    AppCurrency(code: 'MXN', name: 'Mexican Peso', symbol: r'Mex$', flag: '🇲🇽', symbolPrefix: true),
    AppCurrency(code: 'ZAR', name: 'South African Rand', symbol: r'R', flag: '🇿🇦', symbolPrefix: true),
    AppCurrency(code: 'SEK', name: 'Swedish Krona', symbol: r'kr', flag: '🇸🇪'),
    AppCurrency(code: 'NOK', name: 'Norwegian Krone', symbol: r'kr', flag: '🇳🇴'),
    AppCurrency(code: 'DKK', name: 'Danish Krone', symbol: r'kr', flag: '🇩🇰'),
    AppCurrency(code: 'PLN', name: 'Polish Zloty', symbol: r'zł', flag: '🇵🇱'),
    AppCurrency(code: 'CZK', name: 'Czech Koruna', symbol: r'Kč', flag: '🇨🇿'),
    AppCurrency(code: 'HUF', name: 'Hungarian Forint', symbol: r'Ft', flag: '🇭🇺'),
    AppCurrency(code: 'ILS', name: 'Israeli New Shekel', symbol: r'₪', flag: '🇮🇱', symbolPrefix: true),
    AppCurrency(code: 'EGP', name: 'Egyptian Pound', symbol: r'E£', flag: '🇪🇬', symbolPrefix: true),
    AppCurrency(code: 'NGN', name: 'Nigerian Naira', symbol: r'₦', flag: '🇳🇬', symbolPrefix: true),
    AppCurrency(code: 'KES', name: 'Kenyan Shilling', symbol: r'KSh', flag: '🇰🇪', symbolPrefix: true),
    AppCurrency(code: 'GHS', name: 'Ghanaian Cedi', symbol: r'GH₵', flag: '🇬🇭', symbolPrefix: true),
    AppCurrency(code: 'PKR', name: 'Pakistani Rupee', symbol: r'₨', flag: '🇵🇰', symbolPrefix: true),
    AppCurrency(code: 'BDT', name: 'Bangladeshi Taka', symbol: r'৳', flag: '🇧🇩', symbolPrefix: true),
    AppCurrency(code: 'LKR', name: 'Sri Lankan Rupee', symbol: r'Rs', flag: '🇱🇰', symbolPrefix: true),
    AppCurrency(code: 'NPR', name: 'Nepalese Rupee', symbol: r'Rs', flag: '🇳🇵', symbolPrefix: true),
    AppCurrency(code: 'KHR', name: 'Cambodian Riel', symbol: r'៛', flag: '🇰🇭'),
    AppCurrency(code: 'LAK', name: 'Lao Kip', symbol: r'₭', flag: '🇱🇦'),
    AppCurrency(code: 'BND', name: 'Brunei Dollar', symbol: r'B$', flag: '🇧🇳', symbolPrefix: true),
    AppCurrency(code: 'MNT', name: 'Mongolian Tugrik', symbol: r'₮', flag: '🇲🇳'),
    AppCurrency(code: 'UZS', name: 'Uzbekistani Som', symbol: r'UZS', flag: '🇺🇿'),
    AppCurrency(code: 'KZT', name: 'Kazakhstani Tenge', symbol: r'₸', flag: '🇰🇿'),
    AppCurrency(code: 'GEL', name: 'Georgian Lari', symbol: r'₾', flag: '🇬🇪'),
    AppCurrency(code: 'AMD', name: 'Armenian Dram', symbol: r'֏', flag: '🇦🇲'),
    AppCurrency(code: 'AZN', name: 'Azerbaijani Manat', symbol: r'₼', flag: '🇦🇿'),
    AppCurrency(code: 'BYN', name: 'Belarusian Ruble', symbol: r'Br', flag: '🇧🇾'),
    AppCurrency(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: r'₴', flag: '🇺🇦'),
    AppCurrency(code: 'ALL', name: 'Albanian Lek', symbol: r'L', flag: '🇦🇱'),
    AppCurrency(code: 'BAM', name: 'Bosnia-Herzegovina Mark', symbol: r'KM', flag: '🇧🇦'),
    AppCurrency(code: 'BGN', name: 'Bulgarian Lev', symbol: r'лв', flag: '🇧🇬'),
    AppCurrency(code: 'RSD', name: 'Serbian Dinar', symbol: r'дин.', flag: '🇷🇸'),
    AppCurrency(code: 'MKD', name: 'Macedonian Denar', symbol: r'ден', flag: '🇲🇰'),
    AppCurrency(code: 'ISK', name: 'Icelandic Krona', symbol: r'kr', flag: '🇮🇸'),
    AppCurrency(code: 'MAD', name: 'Moroccan Dirham', symbol: r'MAD', flag: '🇲🇦'),
    AppCurrency(code: 'TND', name: 'Tunisian Dinar', symbol: r'DT', flag: '🇹🇳'),
    AppCurrency(code: 'DZD', name: 'Algerian Dinar', symbol: r'DA', flag: '🇩🇿'),
    AppCurrency(code: 'LYD', name: 'Libyan Dinar', symbol: r'LD', flag: '🇱🇾'),
    AppCurrency(code: 'IQD', name: 'Iraqi Dinar', symbol: r'IQD', flag: '🇮🇶'),
    AppCurrency(code: 'JOD', name: 'Jordanian Dinar', symbol: r'JD', flag: '🇯🇴'),
    AppCurrency(code: 'LBP', name: 'Lebanese Pound', symbol: r'L£', flag: '🇱🇧', symbolPrefix: true),
    AppCurrency(code: 'YER', name: 'Yemeni Rial', symbol: r'YR', flag: '🇾🇪'),
    AppCurrency(code: 'ETB', name: 'Ethiopian Birr', symbol: r'Br', flag: '🇪🇹'),
    AppCurrency(code: 'TZS', name: 'Tanzanian Shilling', symbol: r'TSh', flag: '🇹🇿'),
    AppCurrency(code: 'UGX', name: 'Ugandan Shilling', symbol: r'USh', flag: '🇺🇬'),
    AppCurrency(code: 'RWF', name: 'Rwandan Franc', symbol: r'RF', flag: '🇷🇼'),
    AppCurrency(code: 'XOF', name: 'West African CFA Franc', symbol: r'CFA', flag: '🇸🇳'),
    AppCurrency(code: 'XAF', name: 'Central African CFA Franc', symbol: r'FCFA', flag: '🇨🇲'),
    AppCurrency(code: 'MZN', name: 'Mozambican Metical', symbol: r'MT', flag: '🇲🇿'),
    AppCurrency(code: 'AOA', name: 'Angolan Kwanza', symbol: r'Kz', flag: '🇦🇴'),
    AppCurrency(code: 'ZMW', name: 'Zambian Kwacha', symbol: r'ZK', flag: '🇿🇲'),
    AppCurrency(code: 'BWP', name: 'Botswanan Pula', symbol: r'P', flag: '🇧🇼'),
    AppCurrency(code: 'NAD', name: 'Namibian Dollar', symbol: r'N$', flag: '🇳🇦', symbolPrefix: true),
    AppCurrency(code: 'MUR', name: 'Mauritian Rupee', symbol: r'₨', flag: '🇲🇺', symbolPrefix: true),
    AppCurrency(code: 'SCR', name: 'Seychellois Rupee', symbol: r'SR', flag: '🇸🇨'),
    AppCurrency(code: 'MGA', name: 'Malagasy Ariary', symbol: r'Ar', flag: '🇲🇬'),
    AppCurrency(code: 'MWK', name: 'Malawian Kwacha', symbol: r'MK', flag: '🇲🇼'),
    AppCurrency(code: 'SLL', name: 'Sierra Leonean Leone', symbol: r'Le', flag: '🇸🇱'),
    AppCurrency(code: 'GNF', name: 'Guinean Franc', symbol: r'FG', flag: '🇬🇳'),
    AppCurrency(code: 'CDF', name: 'Congolese Franc', symbol: r'FC', flag: '🇨🇩'),
    AppCurrency(code: 'ARS', name: 'Argentine Peso', symbol: r'$', flag: '🇦🇷', symbolPrefix: true),
    AppCurrency(code: 'CLP', name: 'Chilean Peso', symbol: r'$', flag: '🇨🇱', symbolPrefix: true),
    AppCurrency(code: 'COP', name: 'Colombian Peso', symbol: r'$', flag: '🇨🇴', symbolPrefix: true),
    AppCurrency(code: 'PEN', name: 'Peruvian Sol', symbol: r'S/', flag: '🇵🇪', symbolPrefix: true),
    AppCurrency(code: 'UYU', name: 'Uruguayan Peso', symbol: r'$U', flag: '🇺🇾', symbolPrefix: true),
    AppCurrency(code: 'PYG', name: 'Paraguayan Guarani', symbol: r'₲', flag: '🇵🇾'),
    AppCurrency(code: 'BOB', name: 'Bolivian Boliviano', symbol: r'Bs.', flag: '🇧🇴'),
    AppCurrency(code: 'VES', name: 'Venezuelan Bolivar', symbol: r'Bs.S', flag: '🇻🇪'),
    AppCurrency(code: 'CRC', name: 'Costa Rican Colon', symbol: r'₡', flag: '🇨🇷', symbolPrefix: true),
    AppCurrency(code: 'DOP', name: 'Dominican Peso', symbol: r'RD$', flag: '🇩🇴', symbolPrefix: true),
    AppCurrency(code: 'GTQ', name: 'Guatemalan Quetzal', symbol: r'Q', flag: '🇬🇹', symbolPrefix: true),
    AppCurrency(code: 'HNL', name: 'Honduran Lempira', symbol: r'L', flag: '🇭🇳', symbolPrefix: true),
    AppCurrency(code: 'NIO', name: 'Nicaraguan Cordoba', symbol: r'C$', flag: '🇳🇮', symbolPrefix: true),
    AppCurrency(code: 'PAB', name: 'Panamanian Balboa', symbol: r'B/.', flag: '🇵🇦', symbolPrefix: true),
    AppCurrency(code: 'JMD', name: 'Jamaican Dollar', symbol: r'J$', flag: '🇯🇲', symbolPrefix: true),
    AppCurrency(code: 'TTD', name: 'Trinidad & Tobago Dollar', symbol: r'TT$', flag: '🇹🇹', symbolPrefix: true),
    AppCurrency(code: 'BSD', name: 'Bahamian Dollar', symbol: r'B$', flag: '🇧🇸', symbolPrefix: true),
    AppCurrency(code: 'BBD', name: 'Barbadian Dollar', symbol: r'Bds$', flag: '🇧🇧', symbolPrefix: true),
    AppCurrency(code: 'BZD', name: 'Belizean Dollar', symbol: r'BZ$', flag: '🇧🇿', symbolPrefix: true),
    AppCurrency(code: 'XCD', name: 'East Caribbean Dollar', symbol: r'EC$', flag: '🇦🇬', symbolPrefix: true),
    AppCurrency(code: 'FJD', name: 'Fijian Dollar', symbol: r'FJ$', flag: '🇫🇯', symbolPrefix: true),
    AppCurrency(code: 'PGK', name: 'Papua New Guinean Kina', symbol: r'K', flag: '🇵🇬'),
    AppCurrency(code: 'WST', name: 'Samoan Tala', symbol: r'WS$', flag: '🇼🇸', symbolPrefix: true),
    AppCurrency(code: 'TOP', name: 'Tongan Paʻanga', symbol: r'T$', flag: '🇹🇴', symbolPrefix: true),
    AppCurrency(code: 'VUV', name: 'Vanuatu Vatu', symbol: r'VT', flag: '🇻🇺'),
    AppCurrency(code: 'SBD', name: 'Solomon Islands Dollar', symbol: r'SI$', flag: '🇸🇧', symbolPrefix: true),
    AppCurrency(code: 'AFN', name: 'Afghan Afghani', symbol: r'؋', flag: '🇦🇫'),
    AppCurrency(code: 'IRR', name: 'Iranian Rial', symbol: r'IRR', flag: '🇮🇷'),
    AppCurrency(code: 'SOS', name: 'Somali Shilling', symbol: r'Sh', flag: '🇸🇴'),
    AppCurrency(code: 'SDG', name: 'Sudanese Pound', symbol: r'SDG', flag: '🇸🇩'),
    AppCurrency(code: 'SSP', name: 'South Sudanese Pound', symbol: r'SSP', flag: '🇸🇸'),
    AppCurrency(code: 'ERN', name: 'Eritrean Nakfa', symbol: r'Nfk', flag: '🇪🇷'),
    AppCurrency(code: 'DJF', name: 'Djiboutian Franc', symbol: r'Fdj', flag: '🇩🇯'),
    AppCurrency(code: 'KMF', name: 'Comorian Franc', symbol: r'CF', flag: '🇰🇲'),
    AppCurrency(code: 'STN', name: 'Sao Tome Dobra', symbol: r'Db', flag: '🇸🇹'),
    AppCurrency(code: 'CVE', name: 'Cape Verdean Escudo', symbol: r'Esc', flag: '🇨🇻'),
    AppCurrency(code: 'GMD', name: 'Gambian Dalasi', symbol: r'D', flag: '🇬🇲'),
    AppCurrency(code: 'LSL', name: 'Lesotho Loti', symbol: r'L', flag: '🇱🇸'),
    AppCurrency(code: 'SZL', name: 'Swazi Lilangeni', symbol: r'E', flag: '🇸🇿'),
    AppCurrency(code: 'BMD', name: 'Bermudian Dollar', symbol: r'BD$', flag: '🇧🇲', symbolPrefix: true),
    AppCurrency(code: 'KYD', name: 'Cayman Islands Dollar', symbol: r'CI$', flag: '🇰🇾', symbolPrefix: true),
    AppCurrency(code: 'AWG', name: 'Aruban Florin', symbol: r'Afl.', flag: '🇦🇼'),
    AppCurrency(code: 'ANG', name: 'Netherlands Antillean Guilder', symbol: r'NAƒ', flag: '🇨🇼'),
    AppCurrency(code: 'SRD', name: 'Surinamese Dollar', symbol: r'Sr$', flag: '🇸🇷', symbolPrefix: true),
    AppCurrency(code: 'GYD', name: 'Guyanese Dollar', symbol: r'GY$', flag: '🇬🇾', symbolPrefix: true),
    AppCurrency(code: 'HTG', name: 'Haitian Gourde', symbol: r'G', flag: '🇭🇹'),
    AppCurrency(code: 'CUP', name: 'Cuban Peso', symbol: r'$MN', flag: '🇨🇺', symbolPrefix: true),
  ];
}
