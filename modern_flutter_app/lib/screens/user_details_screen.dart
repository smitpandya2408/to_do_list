import 'package:flutter/material.dart';
import 'package:modern_flutter_app/services/random_user_service.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _service = RandomUserService();
  late Future<RandomUserDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchUser();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.fetchUser();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: FutureBuilder<RandomUserDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('No data'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: Text(user.fullName, style: Theme.of(context).textTheme.titleLarge)),
                const SizedBox(height: 8),
                Center(child: Text(user.email)),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 8),
                            Expanded(child: Text('${user.city}, ${user.country}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
