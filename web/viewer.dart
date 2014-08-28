// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library viewer;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_tab.dart';
import 'package:paper_elements/paper_ripple.dart';

import './format_versions/versions.dart';
import './polymer_lib/tree_table.dart';
import './polymer_lib/dependency_view.dart';
import './infohelper.dart';

part './dragdrop.dart';

final List<String> slides = const <String>['info', 'hier', 'dep', 'load'];
final Duration animationTime = const Duration(milliseconds: 100);

void _noSlide() {
  // Disable all of the slides and tabs
  for (String id in slides) {
    var slide = document.querySelector('#$id-slide');
    slide.style.opacity = '0';
    slide.style.left = '100px';
    slide.style.maxHeight = '0px';
    slide.style.zIndex = '0';

    var tab = document.querySelector('#$id-tab');
    if (tab != null) {
      tab.classes.remove('core-selected');
    }
  }
}

void _switchSlide(String id, {bool fromMouse: false}) {
  _noSlide();
  var slide = document.querySelector('#$id-slide');
  slide.style.maxHeight = '10000px';
  slide.style.zIndex = '1';

  new Timer(animationTime, () {
    slide.style.opacity = '1';
    slide.style.left = '0px';
    var tab = document.querySelector('#$id-tab');

    if (tab != null) {
      tab.classes.add('core-selected');
      var tabs = document.querySelector('paper-tabs');
      tabs.attributes['selected'] = tab.attributes['offset'];
      // Draw a ripple on the tab if we didn't already click on it.
      if (!fromMouse) {
        PaperRipple ripple = tab.shadowRoot.querySelector('paper-ripple');
        var pos = {'x': tabs.offsetLeft + tab.offsetLeft + tab.clientWidth / 2, 'y': 0};
        ripple.jsElement.callMethod('downAction', [new JsObject.jsify(pos)]);
        window.animationFrame.then((_) =>
            ripple.jsElement.callMethod('upAction', []));
      }
    }
  });
}

main() {
  initPolymer();

  _noSlide();
  _switchSlide('load');

  int hierarchyScrollPosition = 0;

  var dragDrop = new DragDropFile(
      querySelector('#drag-target'),
      querySelector('#file_upload'));

  var refreshButton = querySelector('#refresh');
  refreshButton.onClick.listen((e){
    e.preventDefault();
    e.stopPropagation();
    dragDrop.reload();
  });

  bool alreadyLoaded = false;

  // When a file is loaded
  dragDrop.onFile.listen((String jsonString) {
    document.querySelector('core-toolbar').style.top = "0";

    List<PaperTab> tabs = querySelectorAll('paper-tab');
    for (PaperTab tab in tabs) {
      tab.onClick.listen((_){
        String link = tab.attributes['slide'];
        if (link != null) {
          _switchSlide(link, fromMouse: true);
          if (link != 'hier') {
            hierarchyScrollPosition = document.body.scrollTop;
          } else {
            new Timer(animationTime * 2, () {
              document.body.scrollTop = hierarchyScrollPosition;
            });
          }
        }
      });
    }

    Map<String, dynamic> json = JSON.decode(jsonString);
    TreeTable treeTable = querySelector('tree-table');
    DependencyView dependencyView = querySelector('dependency-view');
    var info = new InfoHelper(
        json['elements'],
        json['holding'],
        json['program']);

    if (alreadyLoaded) {
      treeTable.clear(info.path);
    } else {
      _switchSlide('info');
    }

    if (!json.containsKey('dump_version')) {
      processData0(json, treeTable);
    } else {
      switch (json['dump_version'] as dynamic) {
        case 1:
        case 2:
        case 3:
          var view = new ViewVersion1(info, treeTable, dependencyView,
              () {
                _switchSlide('hier');
              }, () {
                hierarchyScrollPosition = document.body.scrollTop;
                _switchSlide('dep');
              });
          view.display();
          break;
        default:
          window.alert('Unknown dump-info version');
      }
    }

    // Sort by name as default
    treeTable.sort('name');

    // Sort by chosen sorting methods.
    var select = querySelector('#sort') as SelectElement;
    select.onChange.listen((e) {
      var sortby = select.options[select.selectedIndex].value;
      treeTable.sort(sortby);
    });

    alreadyLoaded = true;
  });
}
