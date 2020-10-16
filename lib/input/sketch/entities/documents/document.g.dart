// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document(
    json['pages'] as List,
    json['UUID'],
    json['assets'],
    json['colorSpace'],
    json['currentPageIndex'],
    json['foreignLayerStyles'] as List,
    (json['foreignSymbols'] as List)
        ?.map((e) => e == null
            ? null
            : ForeignSymbol.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['foreignTextStyles'] as List,
    json['layerStyles'],
    json['layerTextStyles'],
    json['layerSymbols'],
    json['embeddedFontReferences'] as List,
    json['autoEmbedFonts'] as bool,
    json['agreedToFontEmbedding'] as bool,
  );
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'UUID': instance.UUID,
      'assets': instance.assets,
      'colorSpace': instance.colorSpace,
      'currentPageIndex': instance.currentPageIndex,
      'foreignLayerStyles': instance.foreignLayerStyles,
      'foreignSymbols': instance.foreignSymbols,
      'foreignTextStyles': instance.foreignTextStyles,
      'layerStyles': instance.layerStyles,
      'layerTextStyles': instance.layerTextStyles,
      'layerSymbols': instance.layerSymbols,
      'embeddedFontReferences': instance.embeddedFontReferences,
      'autoEmbedFonts': instance.autoEmbedFonts,
      'agreedToFontEmbedding': instance.agreedToFontEmbedding,
      'pages': instance.pages,
    };
