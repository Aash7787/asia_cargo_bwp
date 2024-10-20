import 'dart:async';

import 'package:asia_cargo_ashir_11_boss_office/model/bilty.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bilty_event.dart';
part 'bilty_state.dart';

class BiltyBloc extends Bloc<BiltyEvent, BiltyState> {
  BiltyBloc() : super(BiltyInitial()) {
    on<LoadBilty>(_loadBilty);

    on<AddBilty>(_addBilty);

    on<RemoveBilty>(_removeBilty);
  }

  FutureOr<void> _loadBilty(LoadBilty event, Emitter<BiltyState> emit) {
    // emit(BiltyInitial());
    emit(const BiltyLoaded(biltys: []));
  }

  FutureOr<void> _addBilty(AddBilty event, Emitter<BiltyState> emit) {
    if (state is BiltyLoaded) {
      final state = this.state as BiltyLoaded;
      emit(
        BiltyLoaded(
          biltys: List.from(state.biltys)..add(event.bilty),
        ),
      );
    }
  }

  FutureOr<void> _removeBilty(RemoveBilty event, Emitter<BiltyState> emit) {
    if (state is BiltyLoaded) {
      final state = this.state as BiltyLoaded;
      emit(
        BiltyLoaded(
          biltys: List.from(state.biltys)..remove(event.bilty),
        ),
      );
    }
  }
}
