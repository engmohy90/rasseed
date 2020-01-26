class BanksModel {
  final String bank_name;
  final String name;

  BanksModel({ this.bank_name,this.name });

  factory BanksModel.fromJson(Map<String, dynamic> json) {
    return BanksModel(
        bank_name: json['bank_name'],
        name: json['name']


    );
  }
}

List<BanksModel> defual_bank = [

  new BanksModel(bank_name : "jjjj",
  name: "kkkk")
];