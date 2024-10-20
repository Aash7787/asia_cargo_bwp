part of 'bilty_bloc.dart';

sealed class BiltyState extends Equatable {
  const BiltyState();

  @override
  List<Object> get props => [];
}

final class BiltyInitial extends BiltyState {}

final class BiltyLoaded extends BiltyState {
  final List<Bilty> biltys;

  const BiltyLoaded({required this.biltys});

  @override
  List<Object> get props => [biltys];
}
