import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_post_bloc.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';
import '../home_screen/home_bloc.dart';
import '../home_screen/home_event.dart';
import '../../models/ad.dart';


class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  @override
  void dispose() {
    _schoolController.dispose();
    _salaryController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

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
              icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: BlocListener<AddPostBloc, AddPostState>(
          listener: (context, state) {
            if (state is AddPostSuccess) {
              final newAd = state.ad;
              context.read<HomeBloc>().add(AddNewAd(newAd));
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
                    _buildTextField(_schoolController, 'Сургууль', 'Сургуулийн нэр оруулна уу.', context),
                    _buildDropdownField(context, state),
                    _buildShiftToggle(context, state),
                    _buildTextField(_salaryController, 'Цалин', 'Цалин оруулна уу.', context),
                    _buildExpandableTextField(
                      _additionalInfoController,
                      'Нэмэлт мэдээлэл',
                      'Энд дарж нэмэлт мэдээллийг оруулна уу.',
                      context,
                    ),
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

  Widget _buildTextField(TextEditingController controller, String label, String hintText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, AddPostState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: state.selectedDistrict,
        hint: Text('Дүүрэг сонгох'),
        items: [
          'Баянгол',
          'Баянзүрх',
          'Чингэлтэй',
          'Сонгинохайрхан',
          'Сүхбаатар',
          'Хан-Уул'
        ].map((district) => DropdownMenuItem(value: district, child: Text(district))).toList(),
        onChanged: (value) {
          if (value != null) {
            BlocProvider.of<AddPostBloc>(context).add(DistrictChanged(value));
          }
        },
      ),
    );
  }

  Widget _buildShiftToggle(BuildContext context, AddPostState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<AddPostBloc>(context).add(ShiftChanged('Өглөө'));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: state.selectedShift == 'Өглөө'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
              ),
              child: Text('Өглөө'),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<AddPostBloc>(context).add(ShiftChanged('Өдөр'));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: state.selectedShift == 'Өдөр'
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
              ),
              child: Text('Өдөр'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableTextField(TextEditingController controller, String label, String hintText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
        ),
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
              district: BlocProvider.of<AddPostBloc>(context).state.selectedDistrict ?? '',
              shift: BlocProvider.of<AddPostBloc>(context).state.selectedShift ?? '',
              salary: _salaryController.text,
              additionalInfo: _additionalInfoController.text,
            ),
          );
        },
        child: Text('Нийтлэх'),
      ),
    );
  }
}
