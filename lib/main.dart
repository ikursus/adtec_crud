import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        appId: '1:600713702593:android:4bcc41408da194f8847840',
        apiKey: 'AIzaSyDmApH5V10NVAP6l4f7Q0mYlmWZDh50yE4',
        messagingSenderId: '600713702593',
        projectId: 'adtec-crud',
        storageBucket: 'adtec-crud.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  // Function yang digunakan untuk trigger pilihan simpanan data. Adakah nak create atau update
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';

    if (documentSnapshot != null) {
      action = 'update';

      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Harga Produk'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String? name = _nameController.text;
                    double? price = double.tryParse(_priceController.text);

                    if (name != null && price != null) {
                      if (action == 'create') {
                        await _products.add({'name': name, 'price': price});
                      }

                      if (action == 'update') {
                        await _products
                            .doc(documentSnapshot!.id)
                            .update({'name': name, 'price': price});
                      }

                      //Setkan field name dan price kosong
                      _nameController.text = '';
                      _priceController.text = '';

                      // Tutup popup/modal selepas selesai simpan data
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(action == 'create' ? 'Simpan' : 'Kemaskini'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekod produk berjaya dihapuskan!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senarai Produk'),
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['price'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
