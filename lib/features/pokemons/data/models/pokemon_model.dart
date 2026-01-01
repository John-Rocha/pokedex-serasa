import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class EvolutionModel extends Equatable {
  final String pokeNum;
  final String name;

  const EvolutionModel({
    required this.pokeNum,
    required this.name,
  });

  factory EvolutionModel.fromJson(Map<String, dynamic> json) {
    return EvolutionModel(
      pokeNum: json['num'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'num': pokeNum,
      'name': name,
    };
  }

  Evolution toEntity() {
    return Evolution(
      pokeNum: pokeNum,
      name: name,
    );
  }

  @override
  List<Object?> get props => [pokeNum, name];
}

class PokemonModel extends Equatable {
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
  final List<EvolutionModel>? nextEvolution;
  final List<EvolutionModel>? prevEvolution;

  const PokemonModel({
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

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'] as int,
      pokeNum: json['num'] as String,
      name: json['name'] as String,
      img: json['img'] as String,
      type: (json['type'] as List<dynamic>).map((e) => e as String).toList(),
      height: json['height'] as String,
      weight: json['weight'] as String,
      candy: json['candy'] as String,
      candyCount: json['candy_count'] as int?,
      egg: json['egg'] as String,
      spawnChance: _toDouble(json['spawn_chance']),
      avgSpawns: _toDouble(json['avg_spawns']),
      spawnTime: json['spawn_time'] as String,
      multipliers: (json['multipliers'] as List<dynamic>?)
          ?.map((e) => _toDouble(e))
          .toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nextEvolution: (json['next_evolution'] as List<dynamic>?)
          ?.map((e) => EvolutionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      prevEvolution: (json['prev_evolution'] as List<dynamic>?)
          ?.map((e) => EvolutionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.parse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': pokeNum,
      'name': name,
      'img': img,
      'type': type,
      'height': height,
      'weight': weight,
      'candy': candy,
      'candy_count': candyCount,
      'egg': egg,
      'spawn_chance': spawnChance,
      'avg_spawns': avgSpawns,
      'spawn_time': spawnTime,
      'multipliers': multipliers,
      'weaknesses': weaknesses,
      'next_evolution': nextEvolution?.map((e) => e.toJson()).toList(),
      'prev_evolution': prevEvolution?.map((e) => e.toJson()).toList(),
    };
  }

  Pokemon toEntity() {
    return Pokemon(
      id: id,
      pokeNum: pokeNum,
      name: name,
      img: img,
      type: type,
      height: height,
      weight: weight,
      candy: candy,
      candyCount: candyCount,
      egg: egg,
      spawnChance: spawnChance,
      avgSpawns: avgSpawns,
      spawnTime: spawnTime,
      multipliers: multipliers,
      weaknesses: weaknesses,
      nextEvolution: nextEvolution?.map((e) => e.toEntity()).toList(),
      prevEvolution: prevEvolution?.map((e) => e.toEntity()).toList(),
    );
  }

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
