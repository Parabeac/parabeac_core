import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:parabeac_core/controllers/main_info.dart';

class AmplitudeService {
  /// Constructor
  AmplitudeService();

  /// Map to go to amplitude
  Map<String, dynamic> _amplitudeMap = {};

  /// Map to hold all properties to go to amplitude
  Map<String, dynamic> _eventProperties = {};

  /// Adds current run to amplitude metrics
  void sendToAmplitude() async {
    var lambdaEndpt =
        'https://jsr2rwrw5m.execute-api.us-east-1.amazonaws.com/default/pb-lambda-microservice';

    // var eventProperties = amplitudeMap['eventProperties'];

    _eventProperties['Design specification'] =
        MainInfo().configuration.widgetStyle;

    _eventProperties['Percentage of Auto Layout as UI'] =
        _getPercentage('Number of auto layouts', ['Number of stacks']);

    _eventProperties['Percentage of design specification'] = _getPercentage(
        'Number of theme text styles', ['Number of theme colors']);

    _amplitudeMap.addAll({
      'id': MainInfo().deviceId,
      // 'id': 'Testing Analytics 35',
      'eventProperties': _eventProperties,
    });

    var body = json.encode(_amplitudeMap);

    await http.post(
      Uri.parse(lambdaEndpt),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: body,
    );
  }

  /// Add elements to analytics map
  /// creates element if key does not exists
  void addToAnalytics(String propertyName) {
    if (_eventProperties.containsKey(propertyName)) {
      _eventProperties[propertyName]++;
    } else {
      _eventProperties[propertyName] = 1;
    }
  }

  /// Add tag to analytics
  /// then also added as element
  void addToSpecified(String tagName, String subCategory) {
    if (!_eventProperties.containsKey(subCategory)) {
      _eventProperties[subCategory] = {};
    }
    if (_eventProperties[subCategory].containsKey(tagName)) {
      _eventProperties[subCategory][tagName]++;
    } else {
      _eventProperties[subCategory][tagName] = 1;
    }
    addToAnalytics('Number of $subCategory generated');
  }

  /// Calculate the percentage of property in the sum of properties
  String _getPercentage(String property, List<String> properties) {
    var quantityOfProperty = _eventProperties[property] ?? 0;

    var totalQuantity = quantityOfProperty;
    for (var name in properties) {
      totalQuantity += _eventProperties[name] ?? 0;
    }

    if (totalQuantity == 0) {
      return '0.00';
    }
    return ((quantityOfProperty / totalQuantity) * 100).toStringAsFixed(2);
  }
}
