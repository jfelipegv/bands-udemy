import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketsService with ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketsService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io(
      'http://192.168.12.30:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    // _socket.connect();

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // _socket.emit('emitir-mensaje', (payload) {
    //   print('emitir-mensaje');
    //   print('nombre: ' + payload['nombre']);
    //   print('mensaje: ' + payload['mensaje']);
    // });

    // _socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje :');
    //   print('nombre : ' + payload['nombre']);
    //   print('mensaje : ' + payload['mensaje']);
    //   print(
    //     payload.containsKey('mensaje2')
    //         ? payload['mensaje2']
    //         : 'no hay mensaje2',
    //   );
    // });
  }
}
