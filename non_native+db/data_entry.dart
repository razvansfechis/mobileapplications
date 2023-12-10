// data_entry_page.dart
import 'package:flutter/material.dart';
import 'package:crudproject_nonnative/db_helper.dart';

class DataEntryPage extends StatelessWidget {
  final int? id;
  final Map<String, dynamic>? existingData;

  DataEntryPage({Key? key, this.id, this.existingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _businessNameController = TextEditingController();
    final TextEditingController _businessTypeController = TextEditingController();
    final TextEditingController _noEmployeesController = TextEditingController();
    final TextEditingController _noCustomersController = TextEditingController();
    final TextEditingController _incomeController = TextEditingController();

    // Load existing data if updating
    if (existingData != null) {
      _businessNameController.text = existingData!['businessName'];
      _businessTypeController.text = existingData!['businessType'];
      _noEmployeesController.text = existingData!['noEmployees']?.toString() ?? '';
      _noCustomersController.text = existingData!['noCustomers']?.toString() ?? '';
      _incomeController.text = existingData!['income']?.toString() ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'Add Data' : 'Update Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(labelText: 'Business Name'),
            ),
            TextField(
              controller: _businessTypeController,
              decoration: InputDecoration(labelText: 'Business Type'),
            ),
            TextField(
              controller: _noEmployeesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'No. Employees'),
            ),
            TextField(
              controller: _noCustomersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'No. Customers'),
            ),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Income'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Implement your logic for adding or updating data
                final businessName = _businessNameController.text;
                final businessType = _businessTypeController.text;
                final noEmployees = int.tryParse(_noEmployeesController.text.isNotEmpty ? _noEmployeesController.text : '0') ?? 0;
                final noCustomers = int.tryParse(_noCustomersController.text.isNotEmpty ? _noCustomersController.text : '0') ?? 0;
                final income = int.tryParse(_incomeController.text.isNotEmpty ? _incomeController.text : '0') ?? 0;

                if (id == null) {
                  // Add logic for adding data
                  await SqlHelper.createData(businessName, businessType, noEmployees, noCustomers, income);
                } else {
                  // Add logic for updating data
                  await SqlHelper.updateData(id, businessName, businessType, noEmployees, noCustomers, income);
                }
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Add Data' : 'Update Data'),
            ),
          ],
        ),
      ),
    );
  }
}