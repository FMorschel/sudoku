import 'package:bloc/bloc.dart';

class SimpleCubit<T> extends Cubit<T> {
  SimpleCubit(T initialState) : super(initialState);

  void update(T newState) {
    emit(newState);
  }
}

class ListCubit<T> implements Cubit<List<T>> {
  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // TODO: implement addError
  }

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  void emit(List<T> state) {
    // TODO: implement emit
  }

  @override
  // TODO: implement isClosed
  bool get isClosed => throw UnimplementedError();

  @override
  void onChange(Change<List<T>> change) {
    // TODO: implement onChange
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
  }

  @override
  // TODO: implement state
  List<T> get state => throw UnimplementedError();

  @override
  // TODO: implement stream
  Stream<List<T>> get stream => throw UnimplementedError();
}
