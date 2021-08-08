import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function fun;
  NewTransaction(this.fun);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final title = TextEditingController();
  final amount = TextEditingController();
  DateTime _date;

  void submit() {
    if (title.text.isEmpty ||
        amount.text.isEmpty ||
        double.parse(amount.text) <= 0 ||
        _date == null) {
      return;
    }
    widget.fun(title.text, double.parse(amount.text), _date);
    Navigator.of(context).pop();
  }

  void _chooseDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _date = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: title,
                  onSubmitted: (_) => submit()),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amount,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submit(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_date == null
                            ? 'No Date Chosen!'
                            : 'Date:${DateFormat.yMd().format(_date)}')),
                    FlatButton(
                      onPressed: _chooseDate,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submit,
                child: Text('Add'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
