import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;

  TransactionList(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (ctx, Constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: Constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\$${transaction[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transaction[index].title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transaction[index].date)),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            icon: Icon(Icons.delete),
                            label: Text('Delete'),
                            style: TextButton.styleFrom(
                                primary: Theme.of(context).colorScheme.error),
                            onPressed: () => deleteTx(transaction[index].id),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).colorScheme.error,
                            onPressed: () => deleteTx(transaction[index].id),
                          ),
                  ),
                );
              },
              itemCount: transaction.length,
            ),
    );
  }
}
