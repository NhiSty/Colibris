import 'package:flutter/foundation.dart';
import 'package:colibris/colocation/colocation.dart';

@immutable
sealed class ColocationState {}

class ColocationInitial extends ColocationState {}

class ColocationLoading extends ColocationState {}

class ColocationLoaded extends ColocationState {
  final List<Colocation> colocations;
  final int currentPage;
  final int totalColocations;
  final bool showPagination;

  ColocationLoaded({
    required this.colocations,
    required this.currentPage,
    required this.totalColocations,
    this.showPagination = true,
  });
}

class ColocationError extends ColocationState {
  final String message;

  ColocationError({required this.message});
}

class ColocationSearchEmpty extends ColocationState {}
