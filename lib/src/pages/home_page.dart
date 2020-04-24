import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/producto_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';

class HomePage  extends StatelessWidget {
  //final productoProvider= new ProductosProvider();
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body:  _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }
  _crearBoton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
    );
  }
  Widget _crearListado(ProductoBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productoStream,
      builder: (BuildContext context , AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,i)=>_crearItem(context,productosBloc,snapshot.data[i])

          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
  
  Widget _crearItem(BuildContext context,ProductoBloc productoBloc,ProductoModel producto){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
        //borrar producto
        //productoProvider.borrarProducto(producto.id);
        productoBloc.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUri == null)? Image(image: AssetImage('assets/no-image.png')):
            FadeInImage(
              image: NetworkImage(producto.fotoUri),
              placeholder: AssetImage('assets/jar-load.gif'),
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${producto.titulo}'),
              subtitle:Text('${producto.descripcion}',overflow: TextOverflow.ellipsis,) ,
              onTap:()=> Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      )
    );
  }

}
