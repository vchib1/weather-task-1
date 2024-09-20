import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:weather_app_task/src/utils/unit_enum.dart';

import 'bloc/city_bloc/city_bloc.dart';

class AddCityPage extends StatefulWidget {
  final void Function(int) onTap;

  const AddCityPage({super.key, required this.onTap});

  @override
  State<AddCityPage> createState() => _AddCityPageState();
}

class _AddCityPageState extends State<AddCityPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addDialog(List<String> cities,
      {required void Function(String) onAdd}) async {
    controller.clear();

    String? error = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Eg: Delhi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Gap(16),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      if (cities.contains(controller.text.trim())) {
                        Navigator.pop(context, "City already exists");
                      }

                      onAdd(controller.text.trim());

                      Navigator.pop(context);
                      controller.clear();
                    } else {
                      Navigator.pop(context, "Please enter city name");
                    }
                  },
                  child: Text(
                    "Add",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                const Gap(16),
              ],
            ),
          ),
        );
      },
    );

    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void deleteDialog(BuildContext context, String city) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: const Text('Are you sure to delete?'),
          actions: [
            // The "Yes" button
            TextButton(
                onPressed: () {
                  context.read<CityBloc>().add(DeleteCityEvent(city));
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }

  void changeUnit(TempUnit unit) async {
    void update(TempUnit tempUnit) {
      if (context.read<CityBloc>().state is CityLoadedState) {
        final state = context.read<CityBloc>().state as CityLoadedState;
        context
            .read<CityBloc>()
            .add(UpdateStateEvent(state.copyWith(selectedUnit: tempUnit)));

        Navigator.pop(context);
      }
    }

    String? error = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Checkbox(
                  value: unit == TempUnit.celsius,
                  onChanged: (_) => update(TempUnit.celsius),
                ),
                title: const Text('Celsius'),
              ),
              ListTile(
                leading: Checkbox(
                  value: unit == TempUnit.fahrenheit,
                  onChanged: (_) => update(TempUnit.fahrenheit),
                ),
                title: const Text('Farenheit'),
              ),
            ],
          ),
        );
      },
    );

    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      floatingActionButton: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          if (state is CityLoadedState) {
            return FloatingActionButton(
              onPressed: () => addDialog(state.cities, onAdd: (city) {
                context.read<CityBloc>().add(AddCityEvent(controller.text));
              }),
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<CityBloc, CityState>(
        builder: (_, state) {
          if (state is CityLoadedState) {
            List<String> cities = state.cities;
            final selectedIndex = state.selectedIndex;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () => changeUnit(state.selectedUnit),
                    visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                    title: Text("Temperature Unit"),
                    subtitle: Text("Celsius or Fahrenheit"),
                  ),
                  ListTile(
                    title: const Text("Location"),
                    subtitle: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cities.length,
                      itemBuilder: (_, index) {
                        String city = cities[index];

                        return GestureDetector(
                          onTap: () => widget.onTap(index),
                          onLongPress: () =>
                              index == 0 ? null : deleteDialog(context, city),
                          child: ListTile(
                            leading: Icon(
                              index == 0
                                  ? Icons.location_on_outlined
                                  : Icons.location_city_sharp,
                            ),
                            title: Text(city),
                            trailing: selectedIndex == index
                                ? const Icon(Icons.check_outlined)
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
