import 'package:flutter/material.dart';
import './trans.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
class Chart extends StatelessWidget {
  List<Transaction> trans;
  Chart(this.trans);
  List<Map<String, Object>> get createChart{
    return List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: index));
      var sum = 0.0;
      for(var i=0;i<trans.length;i++)
      {
        if(trans[i].date.day == day.day && trans[i].date.month == day.month && trans[i].date.year == day.year )
        {
          sum+=trans[i].amount;
        }
      }
      return {'day':DateFormat.E().format(day).substring(0,2),'amount':sum};
    }).reversed.toList();
  }
  double get totalAmount{
    return createChart.fold(0.0, (sum, x) {
      return sum + x['amount'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:createChart.map((e) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(e['day'], e['amount'],totalAmount == 0.0 ? 0.0 : (e['amount'] as double) / totalAmount));
        }).toList() ),
      ),
    );
  }
}