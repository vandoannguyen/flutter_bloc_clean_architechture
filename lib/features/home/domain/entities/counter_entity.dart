/// Counter domain entity.
/// 
/// This is a pure Dart class representing a counter in the domain layer.
class CounterEntity {
  final int count;

  const CounterEntity({required this.count});

  CounterEntity increment() {
    return CounterEntity(count: count + 1);
  }

  CounterEntity decrement() {
    return CounterEntity(count: count - 1);
  }

  CounterEntity reset() {
    return const CounterEntity(count: 0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterEntity &&
          runtimeType == other.runtimeType &&
          count == other.count;

  @override
  int get hashCode => count.hashCode;

  @override
  String toString() => 'CounterEntity(count: $count)';
}
