import 'dart:async';

enum CounterAction { increment, decrement, reset }

class CounterBloc {
  int counter = 0;
  final _stateStreamController = StreamController<int>();
  StreamSink<int> get _counterSink => _stateStreamController.sink;
  Stream<int> get counterStream => _stateStreamController.stream;

  final _evenStreamController = StreamController<CounterAction>();
  StreamSink<CounterAction> get eventSink => _evenStreamController.sink;
  Stream<CounterAction> get _evenStream => _evenStreamController.stream;

  CounterBloc() {
    counter = 0;
    _evenStream.listen((event) {
      if (event == CounterAction.increment) {
        counter++;
      } else if (event == CounterAction.decrement) {
        counter--;
      } else if (event == CounterAction.reset) {
        counter = 0;
      }

      _counterSink.add(counter);
    });
  }
}
