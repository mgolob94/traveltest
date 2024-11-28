import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ProfileScreenState(),
    );
  }
}

class ProfileScreenState extends StatefulWidget {
  const ProfileScreenState({super.key});

  @override
  State<ProfileScreenState> createState() => _ProfileScreenStateState();
}

class _ProfileScreenStateState extends State<ProfileScreenState> {
  final TextEditingController _apiKeyController = TextEditingController();
  String? _savedApiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  // Load the saved API key from Shared preferences
  Future<void> _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedApiKey = prefs.getString('api_key');
      if (_savedApiKey != null) {
        _apiKeyController.text = _savedApiKey!;
      }
    });
  }

  // Save the API key to Shared preferences
  Future<void> _saveApiKey() async {
    String apiKey = _apiKeyController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', apiKey);

    setState(() {
      _savedApiKey = apiKey;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API ključ aktiviran')),
      );
    }
  }

  // Remove the API key from Shared preferences
  Future<void> _removeApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_key');

    setState(() {
      _savedApiKey = null;
      _apiKeyController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API ključ deaktiviran')),
      );
    }
  }

  // Display only the last 4 characters of the API key, masking the rest
  String _getMaskedApiKey(String apiKey) {
    if (apiKey.length <= 4) {
      return apiKey;
    }
    return '*' * (apiKey.length - 4) + apiKey.substring(apiKey.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 137, 200, 216),
        title: const Text(
          'Nastavitve',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_savedApiKey == null) ...[
              const Text(
                  'Ali želiš aktivirati API dostop do vaše aplikacije? '),
              TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Vpiši API ključ',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveApiKey,
                child: const Text('Aktiviraj API ključ'),
              ),
            ],
            const SizedBox(height: 16),
            if (_savedApiKey != null) ...[
              Text('Tvoj API ključ: ${_getMaskedApiKey(_savedApiKey!)}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _removeApiKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Deaktiviraj API ključ',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
