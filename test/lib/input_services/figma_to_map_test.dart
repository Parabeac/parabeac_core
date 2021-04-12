import 'dart:io';
import 'package:parabeac_core/input/figma/helper/api_call_service.dart';
import 'package:test/test.dart';

void main() async {
  var figmaFileID = 'https://api.figma.com/v1/files/cmaAGe2hwCp7A5pmEQ2C80';
  var figmaAPIKey = Platform.environment['FIG_API_KEY'];
  group(
    'Checking that Figma is getting interpreted as a Map',
    () {
      setUp(() {});
      test('Figma to Map', () async {
        var result = await APICallService.makeAPICall(figmaFileID, figmaAPIKey);
        expect(result is Map, true);
        expect(result.isNotEmpty, true);
        expect(result.containsKey('document'), true);
        expect(result['document'].isNotEmpty, true);
        expect(result.containsKey('components'), true);
        expect(result['document']['type'], 'DOCUMENT');
        expect(result['document']['children'].isNotEmpty, true);
      });
    },
    skip: !Platform.environment.containsKey('FIG_API_KEY'),
  );
}
