enum SortOrder {
  none,
  alphabetical,
  idAscending,
  idDescending,
}

extension SortOrderExtension on SortOrder {
  String get label {
    switch (this) {
      case SortOrder.none:
        return 'Nenhum';
      case SortOrder.alphabetical:
        return 'Alfabética (A-Z)';
      case SortOrder.idAscending:
        return 'Código (crescente)';
      case SortOrder.idDescending:
        return 'Código (decrescente)';
    }
  }
}
