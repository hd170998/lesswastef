import 'dart:io';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductoBloc{
  final _productoController = new BehaviorSubject<List<ProductoModel>>();

  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productoStream => _productoController;
  Stream<bool> get cargando => _cargandoController;


  void cargarProductos()async{
    final productos = await _productosProvider.cargarProductos();
    _productoController.sink.add(productos);
  }
  
  void agregarProducto(ProductoModel producto)async{
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }
  
  Future<String> subirFoto(File foto)async{
    _cargandoController.sink.add(true);
    final fotoURL = await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);

    return fotoURL;
  }

  void editarProducto(ProductoModel producto)async{
    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoController.sink.add(false);
  }
  void borrarProducto( String id)async{
    await _productosProvider.borrarProducto(id);
  }

  

  dispose(){
    _productoController?.close();
    _cargandoController?.close();
  }
}