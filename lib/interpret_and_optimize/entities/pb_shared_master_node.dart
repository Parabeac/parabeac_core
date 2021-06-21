import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_mastersym_gen.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_master_params.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:quick_log/quick_log.dart';

class PBSharedMasterNode extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {

  ///SERVICE
  var log = Logger('PBSharedMasterNode');

  @override
  final originalRef;

  @override
  PrototypeNode prototypeNode;

  ///The unique symbol identifier of the [PBSharedMasterNode]
  final String SYMBOL_ID;

  List<PBSymbolMasterParameter> parametersDefinition;
  Map<String, PBSymbolMasterParameter> parametersDefsMap = {};

  ///The children that makes the UI of the [PBSharedMasterNode]. The children are going to be wrapped
  ///using a [TempGroupLayoutNode] as the root Node.
  set children(List<PBIntermediateNode> children) {
    child ??= TempGroupLayoutNode(originalRef, currentContext, name);
    if (child is PBLayoutIntermediateNode) {
      children.forEach((element) => child.addChild(element));
    } else {
      child = TempGroupLayoutNode(originalRef, currentContext, name)
        ..replaceChildren([child, ...children]);
    }
  }

  ///The properties that could be be overridable on a [PBSharedMasterNode]

  List<PBSharedParameterProp> overridableProperties;
  String friendlyName;

  PBSharedMasterNode(
    this.originalRef,
    this.SYMBOL_ID,
    String name,
    Point topLeftCorner,
    Point bottomRightCorner, {
    this.overridableProperties,
    PBContext currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: originalRef.UUID ?? '') {

    try {
      //Remove any special characters and leading numbers from the method name
      friendlyName = name
          .replaceAll(RegExp(r'[^\w]+'), '')
          .replaceAll(RegExp(r'/'), '')
          .replaceFirst(RegExp(r'^[\d]+'), '');
      //Make first letter of method name capitalized
      friendlyName = friendlyName[0].toUpperCase() + friendlyName.substring(1);
    } catch (e, stackTrace) {
      MainInfo().sentry.captureException(
        exception: e,
        stackTrace: stackTrace,
      );
      log.error(e.toString());
    }
    ;

    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBMasterSymbolGenerator();

    this.currentContext.screenBottomRightCorner = Point(
        originalRef.boundaryRectangle.x + originalRef.boundaryRectangle.width,
        originalRef.boundaryRectangle.y + originalRef.boundaryRectangle.height);
    this.currentContext.screenTopLeftCorner =
        Point(originalRef.boundaryRectangle.x, originalRef.boundaryRectangle.y);

    parametersDefinition = overridableProperties
        .map((p) {
            var PBSymMasterP = PBSymbolMasterParameter(
            p._friendlyName,
            p.type,
            p.UUID,
            p.canOverride,
            p.propertyName,
            /* Removed Parameter Definition as it was accepting JSON?*/
            null, // TODO: @Eddie
            currentContext.screenTopLeftCorner.x,
            currentContext.screenTopLeftCorner.y,
            currentContext.screenBottomRightCorner.x,
            currentContext.screenBottomRightCorner.y,
            context: currentContext);
            parametersDefsMap[p.propertyName] = PBSymMasterP;
            return PBSymMasterP; })
        .toList()
          ..removeWhere((p) => p == null || p.parameterDefinition == null);

  }

  @override
  void addChild(PBIntermediateNode node) =>
      child == null ? child = node : children = [node];

  @override
  void alignChild() {}
}

class PBSharedParameterProp {
  final Type _type;
  Type get type => _type;
  set type(Type type) => _type;

  PBIntermediateNode value;

  final bool _canOverride;
  bool get canOverride => _canOverride;

  final String _propertyName;
  String get propertyName => _propertyName;

  final String _UUID;
  String get UUID => _UUID;

  final dynamic _initialValue;
  dynamic get initialValue => _initialValue;

  final String _friendlyName;
  String get friendlyName => SN_UUIDtoVarName[propertyName] ?? 'noname';

  PBSharedParameterProp(this._friendlyName, this._type, this.value,
      this._canOverride, this._propertyName, this._UUID, this._initialValue);
}
