import 'dart:convert';

import 'package:api_product_239/model/data_model.dart';
import 'package:api_product_239/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  Future<DataModel?> getProducts() async {
    DataModel? productData;
    String url = "https://dummyjson.com/products";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var mData = response.body;

      var rawData = jsonDecode(mData);

      productData = DataModel.fromJson(rawData);
    }

    return productData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (_, snap){
          if(snap.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } else if(snap.hasError){
            return Center(child: Text('Error: ${snap.error}'),);
          } else if(snap.hasData){
            return snap.data != null
                ? ListView.builder(
                itemCount: snap.data!.products!.length,
                itemBuilder: (_, index){

                  ProductModel eachProduct = snap.data!.products![index];

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(eachProduct.thumbnail!),
                        ),
                        title: Text(eachProduct.title!),
                        subtitle: Text(eachProduct.description!),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: eachProduct.images!.length,
                            itemBuilder: (_, childIndex){
                              String eachProductImgUrl = eachProduct.images![childIndex];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Image.network(eachProductImgUrl,height: 50, fit: BoxFit.fill,)),
                              );
                            }),
                      )
                    ],
                  );
                })
                : Center(
              child: Text('No Data Found!!'),
            );
          }
          return Container();
        },
      )

      /*floatingActionButton: FloatingActionButton(
        onPressed: (){
          getProducts();
        },
        child: Icon(Icons.refresh),
      ),*/
    );
  }


}
