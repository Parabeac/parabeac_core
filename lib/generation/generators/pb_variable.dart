class PBVariable {
  String variableName;
  String type;
  bool isRequired;

  PBVariable(
    this.variableName,
    this.type,
    this.isRequired,
  );

  @override
  bool operator ==(Object other) =>
      (other as PBVariable).variableName == variableName &&
      (other as PBVariable).type == type;
}
