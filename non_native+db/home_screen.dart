import 'package:flutter/material.dart';
import 'data_entry.dart';
import 'package:crudproject_nonnative/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  // Get All data from Database
  void _refreshData() async {
    final data = await SqlHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Add Data
  Future<void> _addData() async {
    await SqlHelper.createData(
      _businessNameController.text,
      _businessTypeController.text,
      int.parse(_noEmployeesController.text),
      int.parse(_noCustomersController.text),
      int.parse(_incomeController.text),
    );

    _refreshData();
  }

  // Update Data
  Future<void> _updateData(int? id) async {
    if (id != null) {
      await SqlHelper.updateData(
        id!,
        _businessNameController.text,
        _businessTypeController.text,
        int.tryParse(_noEmployeesController.text.isNotEmpty ? _noEmployeesController.text : '0') ?? 0,
        int.tryParse(_noCustomersController.text.isNotEmpty ? _noCustomersController.text : '0') ?? 0,
        int.tryParse(_incomeController.text.isNotEmpty ? _incomeController.text : '0') ?? 0,
      );
      _refreshData();
    }
  }

  // Delete Data
  void _deleteData(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Business"),
          content: Text("Are you sure you want to delete this business?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Delete the data
                await SqlHelper.deleteData(id);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text("Data Deleted"),
                  ),
                );
                _refreshData();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _noEmployeesController = TextEditingController();
  final TextEditingController _noCustomersController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  void _navigateToDataEntryPage(int? id) async {
    List<Map<String, dynamic>> existingDataList = [];

    // Fetch existing data if updating
    if (id != null) {
      existingDataList = await SqlHelper.getSingleData(id);
    }

    // Use the first item from the list as existing data
    Map<String, dynamic>? existingData = existingDataList.isNotEmpty ? existingDataList.first : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataEntryPage(id: id, existingData: existingData),
      ),
    ).then((value) {
      // Refresh data when returning from DataEntryPage
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEA4),
      appBar: AppBar(
        title: Text("Business Management Application"),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                _allData[index]['businessName'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type: ${_allData[index]['businessType'] ?? 'No Type'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Employees: ${_allData[index]['noEmployees']?.toString() ?? 'No Employees'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Customers: ${_allData[index]['noCustomers']?.toString() ?? 'No Customers'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Income: ${_allData[index]['income']?.toString() ?? 'No Income'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _navigateToDataEntryPage(_allData[index]['id']);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _deleteData(_allData[index]['id']);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDataEntryPage(null),
        child: Icon(Icons.add),
      ),
    );
  }
}