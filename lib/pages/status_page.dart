import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/sockets_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketsService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServerStatus: ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.emit('emitir-mensaje', {
            'nombre':'Flutter',
            'mensaje':'hola desde Flutter'
          });
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
