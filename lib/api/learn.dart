import 'package:tsty_app/constants/index.dart';
import 'package:tsty_app/utils/dio_utils.dart';
import 'package:tsty_app/viewmodels/learn.dart';

// 获取单元进度 API
Future<UnitProgressResponse> getUnitProgressAPI(String unitId) async {
  final String url = HttpConstants.unitProgress.replaceFirst(
    "{unitId}",
    unitId,
  );
  final result = await dioUtils.get(url);
  return UnitProgressResponse.fromJSON(result);
}

// 获取关卡详情 API
Future<LevelContent> getLevelDetailsAPI(String levelId) async {
  final String url = HttpConstants.levelDetails.replaceFirst(
    "{levelId}",
    levelId,
  );
  final result = await dioUtils.get(url);
  return LevelContent.fromJSON(result);
}
