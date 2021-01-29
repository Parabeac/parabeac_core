abstract class AssetProcessingService {
  dynamic processImage(String uuid);

  Future<void> processRootElements(List<String> uuids);
}
