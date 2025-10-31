import 'package:hng2_inventory_app/Database/inventory_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper()=> _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database !=null) return _database!;

    //to initialise the database if it does'nt exixt 
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'product.db');

    //creating the db table 
    return await openDatabase(
    path,
    version: 1,  
    onCreate: _createDb,
    onUpgrade: (db, oldVersion, newVersion) async {
      // Optional: drop and recreate tables to reset database
      await db.execute('DROP TABLE IF EXISTS products');
      await _createDb(db, newVersion);
    },
  );
}
 Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT,
        code TEXT,
        stock INTEGER,
        price REAL,
        imagePath TEXT,
        supplier TEXT
      )
    ''');
  }

/// PUT THIS IN  A DIFFERENT FILE LATER 
// inserting the product into the table 

Future<int> insertProduct(Product product) async {
  final db = await database;
  return await db.insert(
    'products',
    product.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertSeafoodProducts(List<Product> seafoodProducts) async {
  final db = await database;

  // to check if the products table already has data
  final count = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM products'),
  );

  if (count != null && count > 0) {
    print('Sample products already exist. Skipping insert.');
    return;
  }

  // if not then insert the sample data from seafoodProducts list
  for (final product in seafoodProducts) {
    await insertProduct(product);
  }

  print('SeafoodProducts products inserted successfully.');
}




//Feteching all products from the table
Future <List<Product>> getProducts() async{
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('products');

  return List.generate(maps.length, (i) {
    return Product.fromMap(maps[i]);
  });

}

// Update a product
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

// Delete a product
  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }


// Get a single product by ID
Future<Product?> getProductById(String id) async {
  final db = await database;
  final maps = await db.query(
    'products',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isNotEmpty) {
    return Product.fromMap(maps.first);
  } else {
    return null;
  }
}

}


