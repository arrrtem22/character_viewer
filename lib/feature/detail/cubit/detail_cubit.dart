import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'detail_cubit.freezed.dart';
part 'detail_state.dart';

@injectable
class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState.initial());
}
