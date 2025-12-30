import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBanners extends BannerEvent {}
