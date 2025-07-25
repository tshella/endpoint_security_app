class BreachNotifierModel {
  final String message;

  BreachNotifierModel({required this.message});

  factory BreachNotifierModel.fromJson(Map<String, dynamic> json) {
    return BreachNotifierModel(
      message: json['message'],
    );
  }
}
