import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './trans.dart';
import 'package:intl/intl.dart';

import 'trans.dart';

class Items extends StatelessWidget {
  final List<Transaction> _transactions;
  Function _deleteFun;
  Items(this._transactions, this._deleteFun);
  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No Transaction Added Yet!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.7,
                  child: Image.asset(
                    'assets/fonts/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (c, i) {
              return Card(
                elevation: 10,
                margin: EdgeInsets.all(6),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(
                      child: Text('\$${_transactions[i].amount}'),
                    ),
                  ),
                  title: Text(_transactions[i].title),
                  subtitle:
                      Text(DateFormat.yMMMd().format(_transactions[i].date)),
                  trailing: IconButton(
                    onPressed: () => _deleteFun(_transactions[i].id),
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                  ),
                ),
              );
            },
          );
  }
}
