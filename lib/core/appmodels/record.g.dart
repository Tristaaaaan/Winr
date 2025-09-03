// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WinRateRecordsImpl _$$WinRateRecordsImplFromJson(Map<String, dynamic> json) =>
    _$WinRateRecordsImpl(
      id: (json['id'] as num?)?.toInt(),
      timestamp: (json['timestamp'] as num).toInt(),
      backgroundImage: json['backgroundImage'] as String?,
      desiredWinRate: (json['desiredWinRate'] as num).toInt(),
      currentNumberOfBattles: (json['currentNumberOfBattles'] as num).toInt(),
      currentWinRate: (json['currentWinRate'] as num).toInt(),
      progressiveWinRate: (json['progressiveWinRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WinRateRecordsImplToJson(
        _$WinRateRecordsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'backgroundImage': instance.backgroundImage,
      'desiredWinRate': instance.desiredWinRate,
      'currentNumberOfBattles': instance.currentNumberOfBattles,
      'currentWinRate': instance.currentWinRate,
      'progressiveWinRate': instance.progressiveWinRate,
    };
