import 'package:path/path.dart' as p;
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/commands/file_structure_command.dart';
import 'package:parabeac_core/generation/generators/value_objects/file_structure_strategy/pb_file_structure_strategy.dart';

import '../file_ownership_policy.dart';

class OrientationBuilderCommand extends FileStructureCommand {
  static final DIR_TO_ORIENTATION_BUILDER = 'lib/widgets/';
  static final NAME_TO_ORIENTAION_BUILDER =
      'responsive_orientation_builder.dart';

  OrientationBuilderCommand(String UUID) : super(UUID);

  @override
  Future write(FileStructureStrategy strategy) {
    var template = ''' 
      import 'package:flutter/material.dart';

      class ResponsiveOrientationBuilder extends StatelessWidget {
        final Widget verticalPage;
        final Widget horizontalPage;

        const ResponsiveOrientationBuilder({
          this.verticalPage,
          this.horizontalPage,
        });

        @override
        Widget build(BuildContext context) {
          return OrientationBuilder(builder: (context, orientation) {
            switch (orientation) {
              case Orientation.portrait:
                return verticalPage;
                break;
              case Orientation.landscape:
                return horizontalPage;
              default:
                return ErrorScreen();
            }
          });
        }
      }

      class ErrorScreen extends StatelessWidget {
        // TODO: Change this screen to match your project
        @override
        Widget build(BuildContext context) {
          return Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        }
      }

    ''';

    strategy.writeDataToFile(
      template,
      p.join(strategy.GENERATED_PROJECT_PATH, DIR_TO_ORIENTATION_BUILDER),
      NAME_TO_ORIENTAION_BUILDER,
      UUID: UUID,
      ownership: FileOwnership.DEV,
    );
  }
}
