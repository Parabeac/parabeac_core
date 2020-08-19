class RootItemNotSetError extends Error {
  @override
  String toString() {
    return 'The root screen of the application must be set in the dashboard for a project conversion.';
  }
}