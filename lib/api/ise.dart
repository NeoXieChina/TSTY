import 'package:tsty_app/constants/index.dart';
import 'package:tsty_app/utils/dio_utils.dart';
import 'package:tsty_app/utils/user_prefs.dart';

Future<IseAuthCache> getIseAuthAPI({String? accessToken}) async {
  final token = (accessToken == null || accessToken.trim().isEmpty)
      ? await UserPrefs.getAccessToken()
      : accessToken.trim();

  if (token == null || token.isEmpty) {
    throw Exception('缺少登录token');
  }

  final result = await dioUtils.get(
    HttpConstants.iseAuth,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (result is! Map) {
    throw Exception('鉴权数据格式错误');
  }

  final authorization = result['authorization']?.toString() ?? '';
  final date = result['date']?.toString() ?? '';
  final host = result['host']?.toString() ?? '';
  final appId = (result['appId'] ?? result['app_id'] ?? result['appid'])
          ?.toString() ??
      '';

  if (authorization.isEmpty || date.isEmpty || host.isEmpty || appId.isEmpty) {
    throw Exception('鉴权数据缺失');
  }

  return IseAuthCache(
    authorization: authorization,
    date: date,
    host: host,
    appId: appId,
    timestamp: DateTime.now().millisecondsSinceEpoch,
  );
}
