import 'package:api_product_239/model/product_model.dart';

class DataModel{
  int? limit;
  int? skip;
  int? total;
  List<ProductModel>? products;

  DataModel({
    required this.limit,
    required this.skip,
    required this.total,
    required this.products});

  factory DataModel.fromJson(Map<String, dynamic> json){
    List<ProductModel> mProducts = [];

    for(Map<String, dynamic> eachData in json['products']){
      mProducts.add(ProductModel.fromJson(eachData));
    }

    return DataModel(
        limit: json['limit'],
        skip: json['skip'],
        total: json['total'],
        products: mProducts);
  }
}