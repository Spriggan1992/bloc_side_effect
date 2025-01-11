import 'dart:async';

import 'package:bloc_side_effect/src/bloc_side_effect.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

typedef BlocPresentationWidgetListener<P> = void Function(
  BuildContext context,
  P event,
);

class BlocSideEffectListener<B extends BlocSideEffect<dynamic, P>, P>
    extends SingleChildStatefulWidget {
  const BlocSideEffectListener({
    super.key,
    required this.listener,
    this.bloc,
    super.child,
  });

  final BlocPresentationWidgetListener<P> listener;

  final B? bloc;

  @override
  SingleChildState<BlocSideEffectListener<B, P>> createState() =>
      _BlocSideEffectListenerBaseState<B, P>();
}

class _BlocSideEffectListenerBaseState<B extends BlocSideEffect<dynamic, P>, P>
    extends SingleChildState<BlocSideEffectListener<B, P>> {
  StreamSubscription<P>? _streamSubscription;
  late B _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = widget.bloc ?? context.read<B>();

    _subscribe();
  }

  @override
  void didUpdateWidget(BlocSideEffectListener<B, P> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;

    if (oldBloc != currentBloc) {
      if (_streamSubscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
      }

      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = widget.bloc ?? context.read<B>();

    if (_bloc != bloc) {
      if (_streamSubscription != null) {
        _unsubscribe();
        _bloc = bloc;
      }

      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return child ?? const SizedBox();
  }

  @override
  void dispose() {
    _unsubscribe();

    super.dispose();
  }

  void _subscribe() {
    _streamSubscription = _bloc.presentation.listen(
      (event) => widget.listener(context, event),
    );
  }

  void _unsubscribe() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
