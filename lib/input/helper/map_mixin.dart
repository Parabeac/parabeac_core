mixin MapMixin {
  void addToMap(String key, Map destinationMap, Map<String, Object> source) {
    if (destinationMap.containsKey(key)) {
      destinationMap[key].addAll(source);
    } else {
      destinationMap[key] = source;
    }
  }
}
