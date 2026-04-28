import 'package:chess_app/core/constants/all_enum.dart';
import 'package:dart_mappable/dart_mappable.dart';
part 'match_end_result_model.mapper.dart';

@MappableClass()
class MatchEndResult with MatchEndResultMappable {
  final POVResult resultPOV;
  final MatchResult result;

  MatchEndResult(this.resultPOV, this.result);
}
