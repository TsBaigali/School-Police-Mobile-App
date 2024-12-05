import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_police/widgets/ad_card.dart';
import '../notification_screen/notification_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../add_post_screen/add_post_screen.dart';
import '../home_screen/home_bloc.dart';
import '../home_screen/home_event.dart';
import '../../models/ad.dart';
import '../home_screen/home_state.dart';
import '../school_police_home_screen/school_police_home_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadAds()), // Fetch ads on initialization
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF6F6F6),
            elevation: 0,
            title: Row(
              children: [
                IconButton(
                  icon: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSxSycPmZ67xN1lxHxyMYOUPxZObOxnkLf6w&s',
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                Expanded(
                  child: _buildSearchSection(context),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ), // Grey border for inactive tabs
                  ),
                ),
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Эцэг эх'),
                    Tab(text: 'School Police'),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: TabBarView(
            children: [
              _buildAdsTab(context),
              SchoolPoliceHomeScreen(parentSchool: '5-р сургууль'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddPostBottomSheet(context);
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Widget _buildAdsTab(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          // Wrap the ad list in a RefreshIndicator
          return RefreshIndicator(
            onRefresh: () async {
              // Trigger the LoadAds event to reload data
              context.read<HomeBloc>().add(LoadAds());
              // Wait for a short duration to show the refresh spinner
              await Future.delayed(const Duration(seconds: 1));
            },
            child: _buildAdList(context, state.ads),
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              'Failed to load ads. Please try again.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        } else {
          return Center(
            child: Text(
              'No ads available.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      },
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Хайх...',
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
        ),
        onChanged: (query) {
          context.read<HomeBloc>().add(SearchAds(query));
        },
      ),
    );
  }

  Widget _buildAdList(BuildContext context, List<Ad> ads) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(), // Allow pull-to-refresh even when the list is empty
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return AdCard(ad: ad);
      },
    );
  }

  void _showAddPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddPostScreen(),
    );
  }
}
