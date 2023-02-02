import 'package:meta/meta.dart';

class TextFormFieldObject {
  final String name;
  String type;
  String initialValue;
  bool isDecoration = false;

  TextFormFieldObject({
    @required this.name,
    @required this.type,
    @required this.initialValue,
    this.isDecoration = false,
  });
}

// The list with [TextFormFieldObject]
List<TextFormFieldObject> textFormFieldList = [
  TextFormFieldObject(
    name: 'controller',
    type: 'TextEditingController?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'initialValue',
    type: 'String?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'keyboardType',
    type: 'TextInputType?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'textCapitalization',
    type: 'TextCapitalization',
    initialValue: 'TextCapitalization.none',
  ),
  TextFormFieldObject(
    name: 'autofocus',
    type: 'bool',
    initialValue: 'false',
  ),
  TextFormFieldObject(
    name: 'readOnly',
    type: 'bool',
    initialValue: 'false',
  ),
  TextFormFieldObject(
    name: 'obscureText',
    type: 'bool',
    initialValue: 'false',
  ),
  TextFormFieldObject(
    name: 'maxLengthEnforcement',
    type: 'MaxLengthEnforcement?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'minLines',
    type: 'int?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'maxLines',
    type: 'int?',
    initialValue: '1',
  ),
  TextFormFieldObject(
    name: 'expands',
    type: 'bool',
    initialValue: 'false',
  ),
  TextFormFieldObject(
    name: 'maxLength',
    type: 'int?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'onChanged',
    type: 'ValueChanged<String>?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'onTap',
    type: 'GestureTapCallback?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'onEditingComplete',
    type: 'VoidCallback?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'onFieldSubmitted',
    type: 'ValueChanged<String>?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'onSaved',
    type: 'FormFieldSetter<String>?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'validator',
    type: 'FormFieldValidator<String>?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'inputFormatters',
    type: 'List<TextInputFormatter>?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'enabled',
    type: 'bool?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'scrollPhysics',
    type: 'ScrollPhysics?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'autovalidateMode',
    type: 'AutovalidateMode?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'scrollController',
    type: 'ScrollController?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'textAlign',
    type: 'TextAlign',
    initialValue: 'TextAlign.start',
  ),
  TextFormFieldObject(
    name: 'textAlignVertical',
    type: 'TextAlignVertical?',
    initialValue: null,
  ),
  TextFormFieldObject(
    name: 'suffixIcon',
    type: 'Widget?',
    initialValue: null,
    isDecoration: true,
  ),
  TextFormFieldObject(
    name: 'focusedBorder',
    type: 'InputBorder?',
    initialValue: null,
    isDecoration: true,
  ),
  TextFormFieldObject(
    name: 'hintText',
    type: 'String',
    initialValue: '\'\'',
    isDecoration: true,
  ),
  TextFormFieldObject(
    name: 'label',
    type: 'Widget?',
    initialValue: null,
    isDecoration: true,
  ),
];
