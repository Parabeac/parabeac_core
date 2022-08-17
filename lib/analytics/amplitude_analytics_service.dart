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
  Map<String, dynamic> _eventProperties = {
    'Total of material design': 0,
    'Number of design pages': 0,
    'Number of positional frames': 0,
    'Number of screens generated': 0,
    'Number of theme text styles': 0,
    'Number of theme colors': 0,
    'Number of auto layouts': 0,
    'Number of custom generated': 0,
  };

  /// Adds current run to amplitude metrics
  void sendToAmplitude() async {
    var lambdaEndpt =
        'https://jsr2rwrw5m.execute-api.us-east-1.amazonaws.com/default/pb-lambda-microservice';

    // var eventProperties = amplitudeMap['eventProperties'];

    _eventProperties['Design specification'] =
        MainInfo().configuration.widgetStyle;

    _eventProperties['Percentage of Auto Layout as UI'] = _calculatePercentage(
        _eventProperties['Number of auto layouts'],
        _eventProperties['Number of positional frames'] +
            _eventProperties['Number of auto layouts']);

    _eventProperties['Percentage of design specification'] =
        _calculatePercentage(
            _eventProperties['Number of theme colors'] +
                _eventProperties['Number of theme text styles'],
            _eventProperties['Total of material design']);

    _amplitudeMap.addAll({
      'id': MainInfo().deviceId,
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
  void addToSpecified(String tagName, String subCategory, String key) {
    if (!_eventProperties.containsKey(subCategory)) {
      _eventProperties[subCategory] = {};
    }
    if (_eventProperties[subCategory].containsKey(tagName)) {
      _eventProperties[subCategory][tagName]++;
    } else {
      _eventProperties[subCategory][tagName] = 1;
    }
    addToAnalytics(key);
  }

  /// Add elements to analytics map
  /// creates element if key does not exists
  void directAdd(String propertyName, dynamic value) {
    _eventProperties[propertyName] = value;
  }

  /// Calculate the percentes of [piece] on [pie]
  // TODO: add a zero check
  String _calculatePercentage(num piece, num pie) =>
      ((piece / pie) * 100).toStringAsFixed(2);
}
