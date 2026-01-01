import 'package:equatable/equatable.dart';

class Evolution extends Equatable {
  final String pokeNum;
  final String name;

  const Evolution({
    required this.pokeNum,
    required this.name,
  });

  @override
  List<Object?> get props => [pokeNum, name];
}

class Pokemon extends Equatable {
  final int id;
  final String pokeNum;
  final String name;
  final String img;
  final List<String> type;
  final String height;
  final String weight;
  final String candy;
  final int? candyCount;
  final String egg;
  final double spawnChance;
  final double avgSpawns;
  final String spawnTime;
  final List<double>? multipliers;
  final List<String> weaknesses;
  final List<Evolution>? nextEvolution;
  final List<Evolution>? prevEvolution;

  const Pokemon({
    required this.id,
    required this.pokeNum,
    required this.name,
    required this.img,
    required this.type,
    required this.height,
    required this.weight,
    required this.candy,
    required this.egg,
    required this.spawnChance,
    required this.avgSpawns,
    required this.spawnTime,
    required this.weaknesses,
    this.candyCount,
    this.multipliers,
    this.nextEvolution,
    this.prevEvolution,
  });

  @override
  List<Object?> get props => [
    id,
    pokeNum,
    name,
    img,
    type,
    height,
    weight,
    candy,
    candyCount,
    egg,
    spawnChance,
    avgSpawns,
    spawnTime,
    multipliers,
    weaknesses,
    nextEvolution,
    prevEvolution,
  ];
}
