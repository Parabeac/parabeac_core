import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/node_file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_platform_orientation_linker_service.dart';

/// Command to export `code` under a specific `platform`
class ExportPlatformCommand extends NodeFileStructureCommand {
  PLATFORM platform;
  String fileName;
  String folderName;
  static final String WIDGET_PATH = 'lib/screens';

  ExportPlatformCommand(
    String UUID,
    this.platform,
    this.folderName,
    this.fileName,
    String code,
  ) : super(UUID, code);

  @override
  Future write(FileStructureStrategy strategy) async {
    var path = p.join(
      strategy.GENERATED_PROJECT_PATH,
      '$WIDGET_PATH/$folderName/',
      platform.toString().toLowerCase().replaceAll('platform.', ''),
    );
    strategy.writeDataToFile(code, path, fileName, UUID: UUID);
  }
}
