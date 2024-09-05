import 'dart:convert'; // Para manejar la conversión JSON
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP

// Definir la clase User fuera de main
class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({required this.id, required this.name, required this.username, required this.email});

  // Constructor factory para crear una instancia de User a partir de JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}

// Función para obtener los usuarios desde la API
Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar los usuarios');
  }
}

void main() async {
  try {
    // Llamada a la función fetchUsers
    List<User> users = await fetchUsers();

    // Mostrar los usuarios en la consola
    for (var user in users) {
      print('ID: ${user.id}, Name: ${user.name}, Username: ${user.username}, Email: ${user.email}');
    }

    // Operaciones adicionales: filtrar y contar usuarios
    filterUsersByUsernameLength(users);
    countUsersWithBizDomain(users);
  } catch (e) {
    print('Error: $e');
  }
}

// Función para filtrar usuarios con nombres de usuario de más de 6 caracteres
void filterUsersByUsernameLength(List<User> users) {
  var filteredUsers = users.where((user) => user.username.length > 6).toList();
  print('Usuarios con nombre de usuario de más de 6 caracteres:');
  for (var user in filteredUsers) {
    print('ID: ${user.id}, Username: ${user.username}');
  }
}

// Función para contar usuarios con correos del dominio 'biz'
void countUsersWithBizDomain(List<User> users) {
  var bizUsersCount = users.where((user) => user.email.endsWith('.biz')).length;
  print('Cantidad de usuarios con email del dominio ".biz": $bizUsersCount');
}
