// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymbolInstance _$SymbolInstanceFromJson(Map<String, dynamic> json) {
  return SymbolInstance(
    do_objectID: json['do_objectID'] as String,
    booleanOperation: json['booleanOperation'],
    exportOptions: json['exportOptions'],
    frame: Frame.fromJson(json['frame'] as Map<String, dynamic>),
    flow: json['flow'],
    isFixedToViewport: json['isFixedToViewport'] as bool,
    isFlippedHorizontal: json['isFlippedHorizontal'] as bool,
    isFlippedVertical: json['isFlippedVertical'] as bool,
    isLocked: json['isLocked'] as bool,
    isVisible: json['isVisible'] as bool,
    layerListExpandedType: json['layerListExpandedType'],
    name: json['name'] as String,
    nameIsFixed: json['nameIsFixed'] as bool,
    resizingConstraint: json['resizingConstraint'],
    resizingType: json['resizingType'],
    rotation: json['rotation'] as int,
    sharedStyleID: json['sharedStyleID'],
    shouldBreakMaskChain: json['shouldBreakMaskChain'] as bool,
    hasClippingMask: json['hasClippingMask'] as bool,
    clippingMaskMode: json['clippingMaskMode'] as int,
    userInfo: json['userInfo'],
    style: Style.fromJson(json['style'] as Map<String, dynamic>),
    maintainScrollPosition: json['maintainScrollPosition'] as bool,
    overrideValues: (json['overrideValues'] as List)
        .map((e) => OverridableValue.fromJson(e as Map<String, dynamic>))
        .toList(),
    scale: (json['scale'] as num).toDouble(),
    symbolID: json['symbolID'],
    verticalSpacing: (json['verticalSpacing'] as num).toDouble(),
    horizontalSpacing: (json['horizontalSpacing'] as num).toDouble(),
  );
}

Map<String, dynamic> _$SymbolInstanceToJson(SymbolInstance instance) =>
    <String, dynamic>{
      'do_objectID': instance.do_objectID,
      'booleanOperation': instance.booleanOperation,
      'exportOptions': instance.exportOptions,
      'frame': instance.frame,
      'flow': instance.flow,
      'isFixedToViewport': instance.isFixedToViewport,
      'isFlippedHorizontal': instance.isFlippedHorizontal,
      'isFlippedVertical': instance.isFlippedVertical,
      'isLocked': instance.isLocked,
      'isVisible': instance.isVisible,
      'layerListExpandedType': instance.layerListExpandedType,
      'name': instance.name,
      'nameIsFixed': instance.nameIsFixed,
      'resizingConstraint': instance.resizingConstraint,
      'resizingType': instance.resizingType,
      'rotation': instance.rotation,
      'sharedStyleID': instance.sharedStyleID,
      'shouldBreakMaskChain': instance.shouldBreakMaskChain,
      'hasClippingMask': instance.hasClippingMask,
      'clippingMaskMode': instance.clippingMaskMode,
      'userInfo': instance.userInfo,
      'style': instance.style,
      'maintainScrollPosition': instance.maintainScrollPosition,
      'overrideValues': instance.overrideValues,
      'scale': instance.scale,
      'symbolID': instance.symbolID,
      'verticalSpacing': instance.verticalSpacing,
      'horizontalSpacing': instance.horizontalSpacing,
    };
