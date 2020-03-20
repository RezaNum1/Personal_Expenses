import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function adTx;

  NewTransaction(this.adTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount is! double ||
        _selectedDate == null) {
      return;
    }
    widget.adTx(enteredTitle, enteredAmount,
        _selectedDate); // ini function main yg diekseskusi di sini
    Navigator.of(context).pop();
  }

//UNTUK MENAMPILKAN DATE PICKER
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    }); // then berfungsi untk mengeksekusi setelah user pilih nilai, KARENA DATEPICKER INI FUTURE<>
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          height: 500,
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              // agar ada space pas keyboard muncul, nanti nonggol dikit textfieldnya, jd diatur tingginya
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                CupertinoTextField(),
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) {
                  //   titleInput = val;
                  // },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  // (_) digunakan untuk, menghiraukan argument pada onSubmited, jadi kalo manggil suatu function tidak pake argu gg papa
                  // si onSubmitted => utk menggunakanya dia butuh argument string makanya di submit Data harus pake string argu, tp bisa dihiraukan
                  // onChanged: (val) {
                  //   amountInput = val;
                  // },
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      //AGAR LETAK BUTTON DISEBLAHNYA STAY, JADI FIX GITU TEMPATNY
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : 'Picked Date: ${DateFormat.yMMMMd().format(_selectedDate)}',
                        ),
                      ),
                      AdaptiveFlatButton(
                        'Choose Date',
                        _presentDatePicker,
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text('Add Transaction'),
                  textColor: Theme.of(context).textTheme.button.color,
                  color: Theme.of(context).primaryColor,
                  onPressed: _submitData,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
