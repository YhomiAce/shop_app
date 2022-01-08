import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pages
import './pages/products_overview_screen.dart';
import './pages/product_detail_screen.dart';
import './pages/cart_screen.dart';
import './pages/order_screen.dart';
import './pages/user_product_screen.dart';
import './pages/edit_product_screen.dart';
import './pages/auth_screen.dart';

//Providers
import './providers/products.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.products,
          ),
          create: null, // both practices works fine
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: null,
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Orders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'My Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
