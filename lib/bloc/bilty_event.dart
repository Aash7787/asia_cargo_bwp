part of 'bilty_bloc.dart';

sealed class BiltyEvent extends Equatable {
  const BiltyEvent();

  @override
  List<Object> get props => [];
}

class LoadBilty extends BiltyEvent {}

class AddBilty extends BiltyEvent {
  final Bilty bilty;

  const AddBilty({required this.bilty});

  @override
  List<Object> get props => [bilty];
}

class RemoveBilty extends BiltyEvent {
  final Bilty bilty;

  const RemoveBilty({required this.bilty});

  @override
  List<Object> get props => [bilty];
}
