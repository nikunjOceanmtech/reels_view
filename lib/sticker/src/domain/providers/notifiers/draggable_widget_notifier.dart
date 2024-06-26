import 'package:flutter/material.dart';
import 'package:reels_view/sticker/src/domain/models/editable_items.dart';

class DraggableWidgetNotifier extends ChangeNotifier {
  List<EditableItem> _draggableWidget = [];
  List<EditableItem> get draggableWidget => _draggableWidget;
  set draggableWidget(List<EditableItem> item) {
    _draggableWidget = item;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  setDefaults() {
    _draggableWidget = [];
  }
}
