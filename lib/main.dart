import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_list/card.dart';
import './trans.dart';
import './new_transaction.dart';
import './chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoping App',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showChart = false;
  final List<Transaction> _transactions = [];

  void _addNewTrans(String title, double amount, DateTime date) {
    final newval = Transaction(DateTime.now().toString(), title, amount, date);
    setState(() {
      _transactions.add(newval);
    });
  }

  void _createTrans(BuildContext c1) {
    showModalBottomSheet(
        context: c1,
        builder: (_) {
          return NewTransaction(_addNewTrans);
        });
  }

  List<Transaction> get _lastTrans {
    return _transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _deleteTrans(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
            icon: Icon(Icons.add), onPressed: () => _createTrans(context))
      ],
    );
    final body = SafeArea(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandScape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandScape)
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_lastTrans)),
          if (!isLandScape)
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: Items(_transactions, _deleteTrans)),
          if (isLandScape)
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Chart(_lastTrans))
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: Items(_transactions, _deleteTrans)),
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: CupertinoNavigationBar(
              middle: Text('Personal Expenses'),
              trailing: GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _createTrans(context),
              ),
            ))
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _createTrans(context),
                  ),
          );
  }
}
