class PBParam {
  String variableName;
  String type;
  bool isRequired;

  PBParam(
    this.variableName,
    this.type,
    this.isRequired,
  );

  @override
  bool operator ==(Object other) =>
      (other as PBParam).variableName == variableName &&
      (other as PBParam).type == type;
}
