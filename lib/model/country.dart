class Country {
  Country({this.name, this.slug, this.iso2});

  String name;
  String slug;
  String iso2;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['Country'],
      slug: json['Slug'],
      iso2: json['ISO2'],
    );
  }

  static Country getGlobal() =>
      Country(name: 'Global', slug: 'global', iso2: 'global');

  static List<Country> parseCountries(List<dynamic> countries) {
    return countries.map((item) {
      return Country.fromJson(item as Map<String, dynamic>);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  String get iso2Lower => this.iso2.toLowerCase();

  static String fixCountryNames(String countryName) {
    if (countryName == 'Cabo Verde') {
      return 'Cape Verde';
    }
    if (countryName == 'Cote d\'Ivoire') {
      return 'Côte d\'Ivoire';
    }
    if (countryName == 'Czechia') {
      return 'Czech Republic';
    }
    if (countryName == 'Holy See') {
      return 'Holy See (Vatican City State)';
    }
    if (countryName == 'Iran') {
      return 'Iran, Islamic Republic of';
    }
    if (countryName == 'Korea, South') {
      return 'Korea (South)';
    }
    if (countryName == 'North Macedonia') {
      return 'Macedonia, Republic of';
    }
    if (countryName == 'Saint Vincent and the Grenadines') {
      return 'Saint Vincent and Grenadines';
    }
    if (countryName == 'Vietnam') {
      return 'Viet Nam';
    }
    if (countryName == 'Taiwan*') {
      return 'Taiwan';
    }
    return countryName;
  }
}
