import 'package:equatable/equatable.dart';

abstract class SideEventBase {}

sealed class SideEvent extends Equatable implements SideEventBase {
  const SideEvent();

  @override
  List<Object?> get props => [];
}

final class SideEventNavigateTo extends SideEvent {}

final class SideEventOpenDialog<T> extends SideEvent {
  final T? data;

  const SideEventOpenDialog([this.data]);

  @override
  List<Object?> get props => [data];
}

final class SideEventShowToast extends SideEvent {
  final String message;

  const SideEventShowToast(this.message);

  @override
  List<Object?> get props => [message];
}

final class SideEventShowSnackbar extends SideEvent {}
