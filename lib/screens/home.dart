import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_user/models/random_user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Result? userToDisplay;

  @override
  void initState() {
    super.initState();
    _generateRandomUser();
  }

  @override
  Widget build(BuildContext context) {
    CountryDetails? details;
    try {
      details = CountryCodes.detailsFromAlpha2(userToDisplay?.nat ?? '');
      debugPrint(details.name);
    } catch (e) {
      debugPrint('Country not found: ${e.toString()}');
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Random User')),
        body: (userToDisplay == null)
            ? const Center(
                child: Text('Click the button to generate a random user'))
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            NetworkImage(userToDisplay!.picture.large),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${userToDisplay!.name.first} ${userToDisplay!.name.last}',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.place),
                        title: Text(
                            '${userToDisplay!.location.city}, ${userToDisplay!.location.state}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(userToDisplay!.email),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(userToDisplay!.phone),
                      ),
                      ListTile(
                        leading: const Icon(Icons.cake),
                        title: Text(userToDisplay!.dob.date.toString()),
                      ),
                      ListTile(
                        leading: CountryFlag.fromCountryCode(
                          userToDisplay!.nat,
                          shape: const RoundedRectangle(6),
                        ),
                        title: Text(details?.name ?? ""),
                      )
                    ],
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _generateRandomUser,
          child: const Icon(Icons.add),
        ));
  }

  Future<void> _generateRandomUser() async {
    var response = await http.get(Uri.parse('https://randomuser.me/api/'));
    var randomUser = randomUserFromJson(response.body);
    userToDisplay = randomUser.results.first;
    setState(() {});
  }
}
