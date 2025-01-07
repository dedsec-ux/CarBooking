import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/managecars.dart';

class ManageCarsPage extends StatefulWidget {
  @override
  _ManageCarsPageState createState() => _ManageCarsPageState();
}

class _ManageCarsPageState extends State<ManageCarsPage> {
  final CarController _carController = CarController();

  void _showAddCarDialog() {
    final _formKey = GlobalKey<FormState>();
    final Map<String, dynamic> carData = {
      'image_url': '',
      'name': '',
      'model': '',
      'price': 0,
      'description': '',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Car'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onSaved: (value) => carData['image_url'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter image URL' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) => carData['name'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter name' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Model'),
                  onSaved: (value) => carData['model'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter model' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      carData['price'] = int.tryParse(value ?? '0') ?? 0,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter price' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => carData['description'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter description' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                _carController.addCar(carData);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCarDialog(String carId, Map<String, dynamic> existingCarData) {
    final _formKey = GlobalKey<FormState>();
    final Map<String, dynamic> carData = Map.from(existingCarData);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Car Details'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  initialValue: carData['image_url'],
                  onSaved: (value) => carData['image_url'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter image URL' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  initialValue: carData['name'],
                  onSaved: (value) => carData['name'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter name' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Model'),
                  initialValue: carData['model'],
                  onSaved: (value) => carData['model'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter model' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  initialValue: carData['price'].toString(),
                  onSaved: (value) =>
                      carData['price'] = int.tryParse(value ?? '0') ?? 0,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter price' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  initialValue: carData['description'],
                  onSaved: (value) => carData['description'] = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter description' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                _carController.editCar(carId, carData);
                Navigator.pop(context);
              }
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Cars'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _carController.getCarsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final cars = snapshot.data?.docs ?? [];

                  if (cars.isEmpty) {
                    return Center(child: Text('No cars available'));
                  }

                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index].data() as Map<String, dynamic>;
                      final carId = cars[index].id;

                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: car['image_url'] != null
                              ? SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(
                                    car['image_url'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.directions_car,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                          title: Text(
                            car['name'] ?? 'Unknown Car',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                              'Model: ${car['model']}, Price: \$${car['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  _showEditCarDialog(carId, car);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _carController.deleteCar(carId),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAddCarDialog,
              icon: Icon(Icons.add),
              label: Text('Add New Car'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
