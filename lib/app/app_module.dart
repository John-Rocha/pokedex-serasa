import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/features/splash/presentation/pages/splash_page.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/pages/pokemons_list_page.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const SplashPage(),
    );
    r.child(
      '/pokemons/',
      child: (_) => const PokemonsListPage(),
    );
  }
}
