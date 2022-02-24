// TMOD Installer (c) by tricked
//
// TMOD Installer is licensed under a
// Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc-nd/3.0/>.

/// DATA MODEL INSPIRED BY: https://github.com/nacrt/SkyblockClient-REPO/blob/main/files/mods.json
///
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class DownloadMod {
  final String mcversion;
  final String version;
  final String hash;
  final String url;
  final String filename;
  DownloadMod({
    required this.mcversion,
    required this.version,
    required this.hash,
    required this.url,
    required this.filename,
  });
  factory DownloadMod.fromJson(Map<String, dynamic> json) =>
      _$DownloadModFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadModToJson(this);
}

@JsonSerializable()
class Mod {
  final String repo;
  // ID - Mods are placed in the database using this id
  final String id;
  // Nicknames of this mod
  final List<String> nicknames;
  // ID OF THIS MOD
  final String forgeid;
  // Displayname
  final String display;
  final String description;
  // URL to the icon of this mod
  final String icon;
  final List<String> categories;
  // Array of mod-ids this "mod" conflicts with
  final List<String> conflicts;
  // Room for additional meta for this mod homepage github, discord, Creator...
  final Map<String, String> meta;

  final List<DownloadMod> downloads;

  Mod(
      {required this.repo,
      required this.id,
      required this.nicknames,
      required this.forgeid,
      required this.display,
      required this.description,
      required this.icon,
      required this.categories,
      required this.conflicts,
      required this.meta,
      required this.downloads});

  factory Mod.fromJson(Map<String, dynamic> json) => _$ModFromJson(json);
  Map<String, dynamic> toJson() => _$ModToJson(this);
}
