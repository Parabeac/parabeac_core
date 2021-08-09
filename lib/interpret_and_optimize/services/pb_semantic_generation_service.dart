// import 'package:parabeac_core/design_logic/design_node.dart';
// import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
// import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
// import 'package:parabeac_core/interpret_and_optimize/helpers/pb_deny_list_helper.dart';
// import 'package:parabeac_core/interpret_and_optimize/helpers/pb_plugin_list_helper.dart';
// import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';

// /// PBSemanticInterpretationService:
// /// Interprets certain SketchNodes and converts them into PBIntermediateNode based on certain Semantic Rules; indirect or direct semantics. Furthermore, it removes any SketchNode that are in the DenyList
// /// Input: SketchNode
// /// Output: PBIntermediateNode, null (No Semantics found that matches that SketchNode), or DenyListNode if the node is part of a DenyList set in the configuration.

// class PBSemanticGenerationService implements PBGenerationService {
//   PBSemanticGenerationService({this.currentContext});

//   /// Return DenyListNode if found in the deny List. Return null if there were no semantic node found. Return any other type of PBIntermediateNode if we can tell from direct or indirect semantics.
//   PBIntermediateNode checkForSemantics(DesignNode node) {
//     PBIntermediateNode convertedNode;
//     convertedNode = _checkDirectSemantics(node);
//     if (convertedNode != null) {
//       return convertedNode;
//     }
//     return convertedNode;
//   }

//   PBIntermediateNode _checkDirectSemantics(DesignNode node) {
//     PBIntermediateNode convertedNode;

//     convertedNode = PBDenyListHelper().returnDenyListNodeIfExist(node);
//     if (convertedNode != null) {
//       return convertedNode;
//     }

//     return PBPluginListHelper().returnAllowListNodeIfExists(node);
//   }

//   @override
//   PBContext currentContext;
// }
