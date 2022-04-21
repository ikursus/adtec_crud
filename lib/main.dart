import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Senarai Produk'),
        ),
        body: ListView(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text('Produk A'),
                subtitle: Text('9.99'),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
