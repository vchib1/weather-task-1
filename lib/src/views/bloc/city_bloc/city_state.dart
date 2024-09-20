part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object> get props => [];
}

final class CityInitialState extends CityState {}

final class CityLoadingState extends CityState {}

final class CityLoadedState extends CityState {
  final List<String> cities;
  final int selectedIndex;
  final TempUnit selectedUnit;

  const CityLoadedState({
    required this.cities,
    required this.selectedIndex,
    required this.selectedUnit,
  });

  @override
  List<Object> get props => [cities, selectedIndex, selectedUnit];

  CityLoadedState copyWith({
    List<String>? cities,
    int? selectedIndex,
    TempUnit? selectedUnit,
  }) {
    return CityLoadedState(
      cities: cities ?? this.cities,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedUnit: selectedUnit ?? this.selectedUnit,
    );
  }
}

final class CityErrorState extends CityState {
  final String message;

  const CityErrorState(this.message);

  @override
  List<Object> get props => [message];
}
