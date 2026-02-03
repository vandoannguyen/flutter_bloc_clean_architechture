import 'package:injectable/injectable.dart';
import '../entities/counter_entity.dart';

/// Use case for incrementing counter.
@injectable
class IncrementCounterUseCase {
  IncrementCounterUseCase();

  /// Increments the counter.
  CounterEntity call(CounterEntity counter) {
    return counter.increment();
  }
}
