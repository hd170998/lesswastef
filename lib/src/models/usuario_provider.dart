import 'dart:convert';

import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioProvider{


  final String firebaseToken= 'AIzaSyD9yTAZj_g1b23-WpyE6KMtC557plh1Z_U';

  final _prefs = new PreferenciasUsuario();

  Future<Map<String,dynamic>> login(String email, String password) async {
    final authData={
      'email': email,
      'password':password,
      'returnSecureToke': true
    };
    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('idToken')){
      _prefs.token=decodeResp['idToken'];
      return {'ok':true, 'token': decodeResp['idToken']};
    }
    else{
      return {'ok':false, 'mensaje': decodeResp["error"]['message']};
    }
  }

  Future<Map<String,dynamic>> nuevoUsuario(String email, String password) async{
    final authData={
      'email': email,
      'password':password,
      'returnSecureToke': true
    };
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    if(decodeResp.containsKey('idToken')){
      _prefs.token=decodeResp['idToken'];
      return {'ok':true, 'token': decodeResp['idToken']};
    }
    else{
      return {'ok' : false, 'mensaje': decodeResp["error"]['message']};
    }
  }
}