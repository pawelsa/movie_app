extension MappingIterables<T, R> on List<T> {
  List<R> mapIndexed<R>(R Function(int, T) mapper) {
    return asMap()
        .map((key, value) => MapEntry(key, mapper(key, value)))
        .values
        .toList();
  }
}
