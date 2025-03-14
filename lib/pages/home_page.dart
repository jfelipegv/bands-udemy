import 'package:band_names/models/band.dart';
import 'package:band_names/services/sockets_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Molotov', votes: 5),
    // Band(id: '2', name: 'Alcolirykoz', votes: 3),
    // Band(id: '3', name: 'Héroes del Silencio', votes: 7),
    // Band(id: '4', name: 'El cuarteto de nos', votes: 6),
    // Band(id: '4', name: 'Calle 13', votes: 3),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketsService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic data) {
    bands = (data as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketsService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
                socketService.serverStatus == ServerStatus.Online
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: _showGraph()),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: Colors.white70,
        shape: CircleBorder(),
        onPressed: addNewBand,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketsService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.blueGrey,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(162, 96, 125, 139),
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(
          band.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('New Band Name:'),
            content: TextField(controller: textController),
            actions: [
              MaterialButton(
                elevation: 2,
                onPressed: () {
                  addBandToList(textController.text);
                },
                child: Text('Add', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
    );
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketsService>(context, listen: false);
    if (name.length > 1) {
      socketService.emit('add-band', name);
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    // Map<String, double> dataMap = {
    //   'Flutter': 5,
    //   'React': 3,
    //   'Xamarin': 2,
    //   'Ionic': 2,
    // };

    return PieChart(

      dataMap: dataMap,
      chartType: ChartType.ring,);
  }
}
