import 'package:flutter/material.dart';

class PokemonsListPage extends StatefulWidget {
  const PokemonsListPage({super.key});

  @override
  State<PokemonsListPage> createState() => _PokemonsListPageState();
}

class _PokemonsListPageState extends State<PokemonsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons'),
      ),
      body: Container(),
    );
  }
}
