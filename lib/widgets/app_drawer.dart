import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  var adminMode = true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello Friend"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
          ),
          Visibility(visible: adminMode == true, child: Divider()),
          Visibility(
            visible: adminMode == true,
            child: ListTile(
              leading: Icon(Icons.edit),
              // enabled: adminMode = false,
              title: Text("Manage Products"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
        ],
      ),
    );
  }
}
