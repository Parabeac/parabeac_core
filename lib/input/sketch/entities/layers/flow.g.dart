// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flow _$FlowFromJson(Map<String, dynamic> json) {
  return Flow(
    classField: json['_class'] as String,
    destinationArtboardID: json['destinationArtboardID'] as String,
    maintainScrollPosition: json['maintainScrollPosition'] as bool,
    animationType: json['animationType'],
  );
}

Map<String, dynamic> _$FlowToJson(Flow instance) => <String, dynamic>{
      '_class': instance.classField,
      'destinationArtboardID': instance.destinationArtboardID,
      'maintainScrollPosition': instance.maintainScrollPosition,
      'animationType': instance.animationType,
    };
