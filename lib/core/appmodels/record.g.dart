// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WinRateRecordsImpl _$$WinRateRecordsImplFromJson(Map<String, dynamic> json) =>
    _$WinRateRecordsImpl(
      id: (json['id'] as num?)?.toInt(),
      timeAdded: (json['timeAdded'] as num).toInt(),
      lastUpdated: (json['lastUpdated'] as num?)?.toInt(),
      backgroundImage: json['backgroundImage'] as String?,
      desiredWinRate: (json['desiredWinRate'] as num).toInt(),
      name: json['name'] as String?,
      currentNumberOfBattles: (json['currentNumberOfBattles'] as num).toInt(),
      currentWinRate: (json['currentWinRate'] as num).toInt(),
      progressiveWinRate: (json['progressiveWinRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WinRateRecordsImplToJson(
  _$WinRateRecordsImpl instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'timeAdded': instance.timeAdded,
      'lastUpdated': instance.lastUpdated,
      'backgroundImage': instance.backgroundImage,
      'desiredWinRate': instance.desiredWinRate,
      'name': instance.name,
      'currentNumberOfBattles': instance.currentNumberOfBattles,
      'currentWinRate': instance.currentWinRate,
      'progressiveWinRate': instance.progressiveWinRate,
    };
