import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../models/ad.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Ad> _ads = [];

  HomeBloc() : super(HomeLoading()) {
    on<LoadAds>(_onLoadAds);
    on<AddNewAd>(_onAddNewAd);
    on<SearchAds>(_onSearchAds);
  }

  Future<void> _onLoadAds(LoadAds event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // Fetch fresh data from Firestore
      final querySnapshot = await _firestore.collection('ad').get();
      final ads = querySnapshot.docs.map((doc) {
        return Ad.fromMap(doc.data(), doc.id);
      }).toList();

      // Debug: Print each fetched ad
      for (var ad in ads) {
        print("Fetched ad: ${ad.toMap()}");
      }

      // Update local cache
      _ads = ads;

      emit(HomeLoaded(ads: _ads));
    } catch (e) {
      print("Error fetching ads: ${e.toString()}");
      emit(HomeError('Failed to load ads: ${e.toString()}'));
    }
  }


  void _onAddNewAd(AddNewAd event, Emitter<HomeState> emit) {
    // Add the new ad to the in-memory list and emit the updated list
    _ads.add(event.newAd);
    emit(HomeLoaded(ads: List.from(_ads))); // Ensure a new list reference
  }

  void _onSearchAds(SearchAds event, Emitter<HomeState> emit) {
    final query = event.query.toLowerCase();
    final filteredAds = _ads.where((ad) {
      return ad.school.toLowerCase().contains(query) ||
          ad.district.toLowerCase().contains(query) ||
          ad.additionalInfo.toLowerCase().contains(query);
    }).toList();

    emit(HomeLoaded(ads: filteredAds, isSearchResult: true));
  }
}
