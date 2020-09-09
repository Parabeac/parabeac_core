import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_master.dart';
part 'foreign_symbol.g.dart';

@JsonSerializable(nullable: false)

// title: Document
// description: The document entry in a Sketch file.
class ForeignSymbol {
  static final String CLASS_NAME = 'MSImmutableForeignSymbol';
  final dynamic do_objectID;
  final dynamic libraryID;
  final String sourceLibraryName;
  final bool symbolPrivate;
  final SymbolMaster originalMaster;
  final SymbolMaster symbolMaster;

  ForeignSymbol(
      {this.do_objectID,
      this.libraryID,
      this.sourceLibraryName,
      this.symbolPrivate,
      this.originalMaster,
      this.symbolMaster});
  factory ForeignSymbol.fromJson(Map<String, dynamic> json) =>
      _$ForeignSymbolFromJson(json);
  Map<String, dynamic> toJson() => _$ForeignSymbolToJson(this);
}
