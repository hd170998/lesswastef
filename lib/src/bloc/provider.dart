import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/producto_bloc.dart';


class Provider extends InheritedWidget{
  final loginBloc = new LoginBloc();
  final _productosBloc= new ProductoBloc();


  static Provider _intancia;


  factory Provider({Key key, Widget child}){
    if (_intancia == null){
      _intancia = new Provider._internal(key:key, child: child,);
    }
    return _intancia;
  }



  Provider._internal({Key key, Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
  static LoginBloc of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductoBloc productosBloc ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }

}