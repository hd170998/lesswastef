import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider{
  final String _url = 'https://flutter-varios-f217f.firebaseio.com';

  Future<bool> crearProducto (ProductoModel producto) async{
    final url = '$_url/productos.json';
    final resp = await http.post(url,body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    return true;

  }
  Future<List<ProductoModel>> cargarProductos()async{
    final url = '$_url/productos.json';
    final res = await http.get(url);
    final Map <String,dynamic> decodedData = json.decode(res.body);
    final List<ProductoModel> productos = new List();
    if (decodedData == null){
      return [];
    }
    if( decodedData['error']!= null ) return [];
    decodedData.forEach((id, prod){
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id= id;
      productos.add(prodTemp);
    });
    return productos;
  }

  Future<bool> editarProducto(ProductoModel producto)async{
    final url = '$_url/productos/${producto.id}.json';
    final resp = await http.put(url,body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    return true;
  }

  Future<int> borrarProducto(String id) async{
    final url = '$_url/productos/$id.json';
    final resp = await http.delete(url);
    return 1;
  }
  Future<String> subirImagen(File image)async{
    final url= Uri.parse('https://api.cloudinary.com/v1_1/dgvo26bly/image/upload?upload_preset=t3uyccxt');
    final mimeType =mime(image.path).split('/');
    final imageUploadRequest= http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', image.path, contentType: MediaType(mimeType[0],mimeType[1]));


    imageUploadRequest.files.add(file);
    final streamResponse= await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode!= 200 && resp.statusCode!=201){
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    return respData['secure_url'];

  }
}