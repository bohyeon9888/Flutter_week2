import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/widgetss/chart.dart';
import 'package:widgets/widgetss/new_transaction.dart';
import 'package:widgets/widgetss/transaction_list.dart';
import './models/transaction.dart';
import './widgetss/chart.dart';
import 'dart:io';

void main() {
  /*SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              // ignore: prefer_const_constructors
              titleMedium: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      // ignore: prefer_const_constructors
                      titleSmall: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    /*Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    )*/
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddnewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      // ignore: prefer_const_constructors
      title: Text(
        'Personal Expenses',
        style: TextStyle(fontFamily: 'OpenSans'),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => _startAddnewTransaction(context),
          icon: Icon(Icons.add),
        )
      ],
    );
    final txListWidget = Container(
        height:
            (mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top) *
                0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (mediaQuery.size.height -
                          kToolbarHeight -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              kToolbarHeight -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txListWidget
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddnewTransaction(context),
            ),
    );
  }
}
