import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/file_ownership_policy.dart';
import 'package:test/test.dart';

void main() {
  group(
      '$FileOwnershipPolicy returning the proper extension given an existing file extension',
      () {
    String existingFileExtension;
    FileOwnershipPolicy ownershipPolicy;
    setUp(() {
      ownershipPolicy = DotGFileOwnershipPolicy();
    });

    test('Testing the .g extension modification', () {
      existingFileExtension = '.dart';
      var extDevFile = existingFileExtension;
      var pbcDevFile = '.g$existingFileExtension';

      var reasonMessage = (actualExt, ownership, correctExt) =>
          'Not returning the correct file extension ($correctExt) when its $ownership own by passing $actualExt';

      var actualDevExt = ownershipPolicy.getFileExtension(
          FileOwnership.DEV, existingFileExtension);
      expect(actualDevExt, extDevFile,
          reason: reasonMessage(actualDevExt, FileOwnership.DEV, extDevFile));

      var actualPBCExt = ownershipPolicy.getFileExtension(
          FileOwnership.PBC, existingFileExtension);
      expect(actualPBCExt, pbcDevFile,
          reason: reasonMessage(
              actualPBCExt, FileOwnership.PBC, existingFileExtension));
    });
  });
}
