import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'とぅどぅりすと',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(list: ""),
        '/addPage': (context) => TodoAddPage(),
        '/changePage': (context) => TodoChangePage(),
      },
    );
  }
}

// リスト（初期値）
List<String> todoList = [
  '朝起きる',
  '立ち上がる',
  '歯を磨く',
  'パソコンの電源ON',
  'スマホを触る',
];

class MyHomePage extends StatefulWidget {
  final String list;
  final String flag;
  final int index;

  // コンストラクタ
  MyHomePage({Key key, this.flag, this.list, this.index}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // 状態管理
    if (widget.flag == "update") {
      setState(() {
        todoList[widget.index] = widget.list;
      });
    } else if (widget.flag == "create") {
      setState(() {
        todoList.add(widget.list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("とぅどぅりすと"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('戻るだけですね'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('戻るだけ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('戻るだけ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              // 左から右
              todoList.removeAt(index);

              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("削除しました。")));
            },
            child: Card(
                child: ListTile(
              leading: Icon(Icons.check),
              title: Text(todoList[index]),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面としてリスト追加画面を指定
                    return TodoChangePage(title: todoList[index], index: index);
                  }),
                );
              },
            )),
            background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Icon(Icons.delete)),
          );
        },
        itemCount: todoList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TodoAddPage();
            }),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TodoAddPage extends StatefulWidget {
  TodoAddPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<TodoAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('リスト追加'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  onChanged: (String value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return MyHomePage(list: _text, flag: "create");
                        }),
                      );
                    },
                    child: Text('リスト追加', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('キャンセル'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class TodoChangePage extends StatefulWidget {
  TodoChangePage({Key key, this.title, this.index}) : super(key: key);

  final String title;
  final int index;

  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<TodoChangePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('リスト変更'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: widget.title,
                  onChanged: (String value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return MyHomePage(
                              list: _text, index: widget.index, flag: "update");
                        }),
                      );
                    },
                    child: Text('リスト変更', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('キャンセル'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
