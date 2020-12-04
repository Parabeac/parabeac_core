class PBVariable {
  String variableName;
  String type;
  bool isRequired;
  String defaultValue;

  PBVariable(
    this.variableName,
    this.type,
    this.isRequired,
    this.defaultValue,
  );

  @override
  bool operator ==(Object other) =>
      (other as PBVariable).variableName == variableName &&
      (other as PBVariable).type == type;
}
