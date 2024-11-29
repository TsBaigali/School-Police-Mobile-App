import 'package:equatable/equatable.dart';
import '../../models/ad.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Ad> ads;
  final bool isSearchResult;

  const HomeLoaded({required this.ads, this.isSearchResult = false});

  @override
  List<Object> get props => [ads, isSearchResult];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
