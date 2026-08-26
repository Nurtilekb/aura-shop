import 'package:aurashop/shared/models/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CartRepository repository;

  FavoritesBloc({required this.repository}) : super(FavoritesInitial()) {
    on<FavoritesLoadRequested>(_onLoad);
    on<FavoritesToggleRequested>(_onToggle);
    on<FavoritesRemoveRequested>(_onRemove);
    on<FavoritesClearRequested>(_onClear);
    add(FavoritesLoadRequested());
  }

  Future<void> _onLoad(
    FavoritesLoadRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    await emit.forEach<List<CartItem>>(
      repository.watchFavorites(),
      onData: FavoritesLoaded.new,
      onError: (error, _) => FavoritesError(error.toString()),
    );
  }

  Future<void> _onToggle(
    FavoritesToggleRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.toggleFavorite(event.item);
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onRemove(
    FavoritesRemoveRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.removeFromFavorites(event.productId);
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onClear(
    FavoritesClearRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await repository.clearFavorites();
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
