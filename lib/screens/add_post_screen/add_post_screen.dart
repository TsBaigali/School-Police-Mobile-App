import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_post_bloc.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';

class AddPostScreen extends StatelessWidget {
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPostBloc(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Зар оруулах',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close,
                  color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: BlocListener<AddPostBloc, AddPostState>(
          listener: (context, state) {
            if (state is AddPostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post submitted successfully!')),
              );
              Navigator.pop(context);
            } else if (state is AddPostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<AddPostBloc, AddPostState>(
            builder: (context, state) {
              if (state is AddPostLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(_schoolController, 'Сургууль',
                        'Сургуулийн нэр оруулна уу.', context),
                    _buildDropdownField(context, state),
                    _buildShiftToggle(context, state),
                    _buildTextField(_salaryController, 'Цалин',
                        'Цалин оруулна уу.', context),
                    _buildExpandableTextField(
                        _additionalInfoController,
                        'Нэмэлт мэдээлэл',
                        'Энд дарж нэмэлт мэдээллийг оруулна уу.',
                        context),
                    Spacer(),
                    _buildSubmitButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hintText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: false,
          fillColor: null,
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.surface),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, AddPostState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Дүүрэг',
          border: OutlineInputBorder(),
          filled: false,
          fillColor: null,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: state.selectedDistrict,
            hint: Text('Дүүрэг сонгох',
                style: Theme.of(context).textTheme.bodyMedium),
            items: <String>[
              'Багануур',
              'Багахангай',
              'Баянгол',
              'Баянзүрх',
              'Налайх',
              'Сонгинохайрхан',
              'Сүхбаатар',
              'Хан-Уул',
              'Чингэлтэй'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child:
                    Text(value, style: Theme.of(context).textTheme.bodyMedium),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                BlocProvider.of<AddPostBloc>(context)
                    .add(DistrictChanged(value));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShiftToggle(BuildContext context, AddPostState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ээлж', style: Theme.of(context).textTheme.bodyMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: state.selectedShift == 'Өглөө'
                        ? Colors.white
                        : Colors.black,
                    backgroundColor: state.selectedShift == 'Өглөө'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).inputDecorationTheme.fillColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    BlocProvider.of<AddPostBloc>(context)
                        .add(ShiftChanged('Өглөө'));
                  },
                  child: Column(
                    children: [
                      Text(
                        'Өглөө',
                        style: (state.selectedShift == 'Өглөө'
                                ? Theme.of(context).textTheme.bodyLarge
                                : Theme.of(context).textTheme.headlineMedium)
                            ?.copyWith(fontSize: 16),
                      ),
                      Text('07:30-12:30',
                          style: (state.selectedShift == 'Өглөө'
                                  ? Theme.of(context).textTheme.bodyLarge
                                  : Theme.of(context).textTheme.headlineMedium)
                              ?.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: state.selectedShift == 'Өдөр'
                        ? Colors.white
                        : Colors.black,
                    backgroundColor: state.selectedShift == 'Өдөр'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).inputDecorationTheme.fillColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    BlocProvider.of<AddPostBloc>(context)
                        .add(ShiftChanged('Өдөр'));
                  },
                  child: Column(
                    children: [
                      Text(
                        'Өдөр',
                        style: (state.selectedShift == 'Өдөр'
                                ? Theme.of(context).textTheme.bodyLarge
                                : Theme.of(context).textTheme.headlineMedium)
                            ?.copyWith(fontSize: 16),
                      ),
                      Text('12:30-18:30',
                          style: (state.selectedShift == 'Өдөр'
                                  ? Theme.of(context).textTheme.bodyLarge
                                  : Theme.of(context).textTheme.headlineMedium)
                              ?.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTextField(TextEditingController controller,
      String label, String hintText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: TextFormField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: false,
          fillColor: null,
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.surface),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<AddPostBloc>(context).add(
            SubmitPostEvent(
              school: _schoolController.text,
              district: _districtController.text,
              shift:
                  BlocProvider.of<AddPostBloc>(context).state.selectedShift ??
                      '',
              salary: _salaryController.text,
              additionalInfo: _additionalInfoController.text,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
        ),
        child: Text('Нийтлэх', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
