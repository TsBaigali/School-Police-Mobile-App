import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'school_police_home_bloc.dart';
import 'school_police_home_event.dart';
import 'school_police_home_state.dart';

class SchoolPoliceHomeScreen extends StatelessWidget {
  final String parentSchool;

  SchoolPoliceHomeScreen({required this.parentSchool});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SchoolPoliceBloc()..add(LoadSchoolPolice(parentSchool)),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocBuilder<SchoolPoliceBloc, SchoolPoliceState>(
            builder: (context, state) {
              if (state is SchoolPoliceLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SchoolPoliceLoaded) {
                return ListView.builder(
                  itemCount: state.schoolPolice.length,
                  itemBuilder: (context, index) {
                    final police = state.schoolPolice[index];

                    // Sample rating and job completion count (ideally comes from model)
                    final double rating = 4.2;
                    final int completedJobs = 120;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500', // Replace with actual image URL
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name and Rating Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${police.firstName} ${police.lastName}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis, // Prevents overflow
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.min, // Prevents row expansion
                                      children: List.generate(
                                        5,
                                            (starIndex) => Icon(
                                          Icons.star,
                                          color: starIndex < rating.floor()
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '$rating',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Phone and School Info
                                Row(
                                  children: [
                                    Icon(Icons.phone, size: 16, color: Colors.grey),
                                    SizedBox(width: 6),
                                    Text(
                                      police.phoneNumber.toString(),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.school, size: 16, color: Colors.grey),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        "Schools: ${police.assignedSchools?.join(', ')}",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Completed Jobs
                                Text(
                                  'Completed Jobs: $completedJobs',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.phone, color: Colors.blueAccent),
                            constraints: BoxConstraints(maxWidth: 36), // Limits width
                            onPressed: () {
                              // Implement call action
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is SchoolPoliceError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text("Unknown state"));
              }
            },
          ),
        ),
      ),
    );
  }
}
