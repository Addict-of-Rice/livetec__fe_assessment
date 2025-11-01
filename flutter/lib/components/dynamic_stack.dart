import 'package:flutter/material.dart';


// TODO: fix
class DynamicStackController {
  void Function(List<String> keys)? bringToFront;
}

class DynamicStackChild {
  final String key;
  final Widget widget;

  DynamicStackChild(this.key, this.widget);
}

class DynamicStack extends StatefulWidget {
  final DynamicStackController controller;
  final List<DynamicStackChild> keyedChildren;

  const DynamicStack({
    super.key,
    required this.controller,
    required this.keyedChildren,
  });

  @override
  State<DynamicStack> createState() => _DynamicStackState();
}

class _DynamicStackState extends State<DynamicStack> {
  late List<Widget> _children;

  Widget getChildFromKey(String key) {
    for (DynamicStackChild keyedChild in widget.keyedChildren) {
      if (key == keyedChild.key) {
        return keyedChild.widget;
      }
    }
    return widget.keyedChildren.last.widget;
  }

  void bringToFront(List<String> keys) {
    setState(() {
      for (String key in keys) {
        Widget child = getChildFromKey(key);
        _children.remove(child);
        _children.add(child);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _children = widget.keyedChildren
        .map((keyedChild) => keyedChild.widget)
        .toList();
    widget.controller.bringToFront = bringToFront;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _children);
  }
}
