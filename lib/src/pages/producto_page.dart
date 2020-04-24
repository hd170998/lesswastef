import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/producto_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formkey= GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoBloc productosBloc;
  //final productoProvider= new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null){
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
              ),
          IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white,),
              onPressed: _tomarFoto,
          ),
        ],
      ),
      body:  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre Receta'
      ),
      onSaved: (value)=> producto.titulo=value,
      validator: (value){
        if(value.length<5){
          return 'Ingrese el nombre del producto';
        }else{
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.descripcion.toString(),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
          labelText: 'Descripcion'
      ),
      onSaved: (value)=> producto.descripcion = value,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Guarda en Favoritos'),
      activeColor: Colors.deepPurple,
      onChanged: (value)=> setState((){
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        onPressed: (_guardando) ? null: _submit,
        icon: Icon(Icons.save, color: Colors.white,),
        label: Text('Guardar',style: TextStyle(color: Colors.white),));
  }

  void _submit()async{
    if(!formkey.currentState.validate()) return;
    formkey.currentState.save();

    setState(() {
      _guardando= true;
    });

    if(foto!= null){
      producto.fotoUri= await productosBloc.subirFoto(foto);
    }

    if(producto.id == null){
      productosBloc.agregarProducto(producto);
    }else {
      productosBloc.editarProducto(producto);
    }
    mostrarSnackBar(context,'Registro Guardado');
    setState(() {
      _guardando= false;
    });

  }
  void mostrarSnackBar(BuildContext context ,String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds:  1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    Navigator.pop(context);
  }

  Widget _mostrarFoto(){
    if (producto.fotoUri != null){
      return FadeInImage(
        image: NetworkImage(producto.fotoUri,),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{
      return Image(
        height: 300.0,
        fit: BoxFit.cover,
        image: AssetImage(foto?.path ??'assets/no-image.png'),
      );
    }
  }

  void _seleccionarFoto() async {
    foto = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(foto != null){

      setState(() {});
    }
  }

  void _tomarFoto() async{
    foto = await ImagePicker.pickImage(source: ImageSource.camera);
    if(foto != null){

      setState(() {});
    }
  }
  _procesarImagen(ImageSource tipo)async{
    foto = await ImagePicker.pickImage(source: tipo);
    if(foto != null){
      producto.fotoUri=null;
    }
    setState(() {});
  }
}
