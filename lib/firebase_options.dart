// ⚠️ ARCHIVO TEMPORAL: reemplázalo ejecutando `flutterfire configure` en la raíz
// del proyecto (igual que en Asmodeo). Ese comando genera este archivo con las
// claves reales de tu proyecto de Firebase.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError('Este portafolio solo está configurado para web.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCdDx9_RLiUfCT7ueThYd5_5OEG0eujTaM',
    appId: '1:51092551931:web:bc45adf25bcbe0134dd85e',
    messagingSenderId: '51092551931',
    projectId: 'portafoliojosetrujillo',
    authDomain: 'portafoliojosetrujillo.firebaseapp.com',
    storageBucket: 'portafoliojosetrujillo.firebasestorage.app',
    measurementId: 'G-HGLT4MZCH1',
  );
}
