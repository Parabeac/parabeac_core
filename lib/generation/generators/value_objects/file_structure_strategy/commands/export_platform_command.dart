import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';

/// Command to export `code` under a specific `platform`
class ExportPlatformCommand extends NodeFileStructureCommand {
  PLATFORM platform;
  String fileName;
  String folderName;

  ExportPlatformCommand(
    this.platform,
    this.folderName,
    this.fileName,
    String code,
  ) : super(code);

  @override
  Future write(FileStructureStrategy strategy) async {
    var path = '${strategy.GENERATED_PROJECT_PATH}';

    switch (platform) {
      case PLATFORM.DESKTOP:
        fileName = fileName.replaceAll('.dart', '_desktop.dart');
        path += 'lib/screens/$folderName/desktop/$fileName';
        break;
      case PLATFORM.MOBILE:
        fileName = fileName.replaceAll('.dart', '_mobile.dart');
        path += 'lib/screens/$folderName/mobile/$fileName';
        break;
      case PLATFORM.TABLET:
        fileName = fileName.replaceAll('.dart', '_tablet.dart');
        path += 'lib/screens/$folderName/tablet/$fileName';
        break;
    }
    super.writeDataToFile(code, path);
  }
}
