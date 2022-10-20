import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit responsible for managing bottom navigation bar in Main Page.
class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit() : super(0);

  /// Changes stored index.
  void changeIndex(int newIndex) => emit(newIndex);
}
