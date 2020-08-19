import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/entities/documents/abstract_document.dart';
import 'package:parabeac_core/input/entities/objects/foreign_symbol.dart';
part 'document.g.dart';
// title: Document
// description: The document entry in a Sketch file.
@JsonSerializable(nullable: false)
class Document extends AbstractDocument {
  List pages;

  Document(
      this.pages,
      do_objectID,
      assets,
      colorSpace,
      currentPageIndex,
      List foreignLayerStyles,
      List<ForeignSymbol> foreignSymbols,
      List foreignTextStyles,
      layerStyles,
      layerTextStyles,
      layerSymbols,
      List embeddedFontReferences,
      bool autoEmbedFonts,
      bool agreedToFontEmbedding)
      : super(
            do_objectID,
            assets,
            colorSpace,
            currentPageIndex,
            foreignLayerStyles,
            foreignSymbols,
            foreignTextStyles,
            layerStyles,
            layerTextStyles,
            layerSymbols,
            embeddedFontReferences,
            autoEmbedFonts,
            agreedToFontEmbedding);
    factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentToJson(this);

}
