/// Class that helps traversing a [Map] without running into null errors
class IndexWalker {
  dynamic value;
  IndexWalker(this.value);

  IndexWalker operator [](Object index) {
    if (value != null) {
      value = value[index];
    }
    return this;
  }
}
