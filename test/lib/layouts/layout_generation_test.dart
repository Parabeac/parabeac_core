import 'package:mockito/mockito.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:test/test.dart';

class TempGroupMock extends Mock implements TempGroupLayoutNode {}

class PBIntermediateNodeMock extends Mock implements PBIntermediateNode {}

void main() {
  group('Testing the correct generation of the children in the layout service',
      () {
    var exploreText, lineContainer, categoriesText, groupLayout;
    setUp(() {
      exploreText = PBIntermediateNodeMock();
    });
  });
}
