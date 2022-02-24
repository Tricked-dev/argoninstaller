// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadMod _$DownloadModFromJson(Map<String, dynamic> json) => DownloadMod(
      mcversion: json['mcversion'] as String,
      version: json['version'] as String,
      hash: json['hash'] as String,
      url: json['url'] as String,
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$DownloadModToJson(DownloadMod instance) =>
    <String, dynamic>{
      'mcversion': instance.mcversion,
      'version': instance.version,
      'hash': instance.hash,
      'url': instance.url,
      'filename': instance.filename,
    };

Mod _$ModFromJson(Map<String, dynamic> json) => Mod(
      repo: json['repo'] as String,
      id: json['id'] as String,
      nicknames:
          (json['nicknames'] as List<dynamic>).map((e) => e as String).toList(),
      forgeid: json['forgeid'] as String,
      display: json['display'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      conflicts:
          (json['conflicts'] as List<dynamic>).map((e) => e as String).toList(),
      meta: Map<String, String>.from(json['meta'] as Map),
      downloads: (json['downloads'] as List<dynamic>)
          .map((e) => DownloadMod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModToJson(Mod instance) => <String, dynamic>{
      'repo': instance.repo,
      'id': instance.id,
      'nicknames': instance.nicknames,
      'forgeid': instance.forgeid,
      'display': instance.display,
      'description': instance.description,
      'icon': instance.icon,
      'categories': instance.categories,
      'conflicts': instance.conflicts,
      'meta': instance.meta,
      'downloads': instance.downloads,
    };
