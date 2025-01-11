import 'dart:async';

import 'package:bloc/bloc.dart';

mixin BlocSideEffect<S, P> on BlocBase<S> {
  final _sideEffectStream = StreamController<P>.broadcast();

  Stream<P> get presentation => _sideEffectStream.stream;

  void emitSideEffect(P event) => _sideEffectStream.add(event);

  @override
  Future<void> close() async {
    await _sideEffectStream.close();
    await super.close();
  }

  Future<void> closeStream() async {
    await _sideEffectStream.close();
  }
}
