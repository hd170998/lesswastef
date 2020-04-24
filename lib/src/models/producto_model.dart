
import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String id;
  String titulo;
  String descripcion;
  bool disponible;
  String fotoUri;

  ProductoModel({
    this.id,
    this.titulo,
    this.descripcion,
    this.disponible=true,
    this.fotoUri,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
    id: json["id"],
    titulo: json["titulo"],
    descripcion: json["descripcion"],
    disponible: json["disponible"],
    fotoUri: json["fotoUri"],
  );

  Map<String, dynamic> toJson() => {
    //"id": id,
    "titulo": titulo,
    "descripcion": descripcion,
    "disponible": disponible,
    "fotoUri": fotoUri,
  };
}