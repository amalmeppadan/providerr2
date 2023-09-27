import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerr2/method/Users.dart';
import 'package:http/http.dart' as http;



class UserProvider extends ChangeNotifier {
  List<Users> _users = []; // Initialize an empty list to store users

  List<Users> get users => _users;

  set users(List<Users> value) {
    _users = value;

  } // Getter to access the user list

  // Function to set the user list from JSON data
  Future<void> setUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var jsonList=jsonDecode(response.body) as List;
    _users = jsonList.map((json) => Users.fromJson(json)).toList();
    notifyListeners(); // Notify listeners when the data is updated
  }
}

// class UsersProvider extends ChangeNotifier {
//   List<Users> _user = [];
//
//   List<Users> get user => _user;
//
//   Future<void> fetchUsers() async {
//
//     print("api called");
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = json.decode(response.body);
//       var s = responseData.map((data) => Users.fromJson(data)).toList();
//       _user=s;
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load posts');
//     }
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'provider',
        home: Home(),

      ),
    );
  }
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider= Provider.of<UserProvider>(context);
    usersProvider.setUsers();
    return Scaffold(
      appBar: AppBar(),
       body: Container(
         height: MediaQuery.of(context).size.height,
         child: ListView.builder(
                 itemCount: usersProvider.users.length,
                 itemBuilder: (BuildContext context, int index) {
                   final users = usersProvider.users[index];
                   return ListTile(
                     title: Text('${users.id}'),
                     subtitle:  Text('${users.name}'),
                   );
                 },
               ),
       )





    );
  }
}


