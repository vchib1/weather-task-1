import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_task/src/repository/weather_repo.dart';
import 'package:weather_app_task/src/utils/unit_enum.dart';

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final WeatherRepository _repo;

  CityBloc({required WeatherRepository repo})
      : _repo = repo,
        super(CityInitialState()) {
    on<AddCityEvent>((event, emit) async {
      await _repo.addCity(event.city);
      add(GetCitiesEvent());
    });

    on<DeleteCityEvent>((event, emit) async {
      await _repo.deleteCity(event.city);
      // on delete reset to index 0
      await repo.setSelectedIndex(0);
      add(GetCitiesEvent());
    });

    on<GetCitiesEvent>((event, emit) async {
      try {
        final index = await repo.getSelectedIndex();
        final unit = await repo.getTempUnit();

        await emit.forEach(_repo.getCitiesList(), onData: (cities) {
          return CityLoadedState(
            cities: cities,
            selectedIndex: index,
            selectedUnit: unit,
          );
        }).onError(
          (error, stackTrace) {
            emit(CityErrorState(error.toString()));
          },
        );
      } catch (e) {
        emit(CityErrorState(e.toString()));
      }
    });

    on<UpdateStateEvent>(
      (event, emit) async {
        await _repo.setSelectedIndex(event.state.selectedIndex);
        await _repo.setTempUnit(event.state.selectedUnit);
        if (state is CityLoadedState) {
          emit(event.state);
        } else {
          add(GetCitiesEvent());
        }
      },
    );
  }
}
