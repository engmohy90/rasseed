class Supported_BanksModel {
  final String bank_name;
  final String name;
  final String i_ban;
  final String account_name;
  final String account_number;


  Supported_BanksModel({ this.bank_name,this.name,this.i_ban,this.account_name,this.account_number });

  factory Supported_BanksModel.fromJson(Map<String, dynamic> json) {
    return Supported_BanksModel(
        bank_name: json['bank_name'],
        name: json['name'],
        i_ban: json['i_ban'],
        account_name: json['account_name'],
        account_number: json['account_number']

    );
  }
}