import 'package:tsty_app/constants/index.dart';
import 'package:tsty_app/utils/dio_utils.dart';
import 'package:tsty_app/viewmodels/learn.dart';

Future<UnitProgressResponse> getUnitProgressAPI(
  String unitId,
) async {
  final String url = HttpConstants.unitProgress.replaceFirst(
    "{unitId}",
    unitId,
  );
  final result = await dioUtils.get(
    url,
  );
  return UnitProgressResponse.fromJSON(result);
}