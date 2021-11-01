class DataModel {
  int? id;
  String property;
  String bedrooms;
  String price;
  String furniture;
  String reporter;

  DataModel(
      {this.id,
      required this.property,
      required this.bedrooms,
      required this.price,
      required this.furniture,
      required this.reporter}
 );
  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
      id: json['id'],
      property: json['property'],
      bedrooms: json['bedrooms'],
      price: json['price'],
      furniture: json['furniture'],
      reporter: json['reporter']
  );

  Map<String, dynamic> toMap() => {
        'id': id,
        'property': property,
        'bedrooms': bedrooms,
        'price': price,
        'furniture': furniture,
        'reporter': reporter,
  };
}
