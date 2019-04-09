import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Exemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Exemplo controller listener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  BehaviorSubject<String> _rxController = BehaviorSubject();
  bool _listenerAtivo = true;

  @override
  void dispose() {
    _rxController.close();
    controller.dispose();
    super.dispose();
  }

  _handlerTextController() {
    _rxController.sink.add(controller.text);
  }

  @override
  void initState() {
    controller.addListener(_handlerTextController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Exemplo de controller com listener',
              ),
              TextField(
                controller: controller,
              ),
              Divider(
                height: 10,
              ),
              StreamBuilder<String>(
                stream: _rxController.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data ?? "",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_listenerAtivo) {
            _listenerAtivo = false;
            controller.removeListener(_handlerTextController);
          } else {
            _listenerAtivo = true;
            controller.addListener(_handlerTextController);
          }
        },
        tooltip: 'Ativa',
        child: Icon(Icons.autorenew),
      ),
    );
  }
}
