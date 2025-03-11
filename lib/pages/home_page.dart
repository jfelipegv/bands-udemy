import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Molotov', votes: 5),
    Band(id: '2', name: 'Alcolirykoz', votes: 3),
    Band(id: '3', name: 'Héroes del Silencio', votes: 7),
    Band(id: '4', name: 'El cuarteto de nos', votes: 6),
    Band(id: '4', name: 'Calle 13', votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
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
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direction $direction');
        print('id ${band.id}');
      },
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
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Band Name:'),
          content: TextField(controller: textController),
          actions: [
            MaterialButton(
              elevation: 2,
              onPressed: () => addBandToList(textController.text),
              child: Text('Add', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
