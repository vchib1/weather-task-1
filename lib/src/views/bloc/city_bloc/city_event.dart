part of 'city_bloc.dart';

sealed class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class GetCitiesEvent extends CityEvent {}

class AddCityEvent extends CityEvent {
  final String city;

  const AddCityEvent(this.city);

  @override
  List<Object> get props => [city];
}

class DeleteCityEvent extends CityEvent {
  final String city;

  const DeleteCityEvent(this.city);

  @override
  List<Object> get props => [city];
}

class UpdateStateEvent extends CityEvent {
  final CityLoadedState state;

  const UpdateStateEvent(this.state);

  @override
  List<Object> get props => [state];
}
