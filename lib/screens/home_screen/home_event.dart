import 'package:equatable/equatable.dart';
import '../../models/ad.dart'; // Import the Ad model

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

// Load Ads Event
class LoadAds extends HomeEvent {
  @override
  List<Object> get props => [];
}

// Add New Ad Event
class AddNewAd extends HomeEvent {
  final Ad newAd;

  const AddNewAd(this.newAd);

  @override
  List<Object> get props => [newAd];
}

// Search Ads Event
class SearchAds extends HomeEvent {
  final String query;

  const SearchAds(this.query);

  @override
  List<Object> get props => [query];
}
