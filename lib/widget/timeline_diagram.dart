
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/object/data.dart';
import 'package:tdv2_showcase_web/object/meta.dart';
import 'package:tdv2_showcase_web/util/color_picker.dart';

class TimelineDiagram extends StatefulWidget {
  const TimelineDiagram({super.key});

  @override
  TimelineDiagramState createState() => TimelineDiagramState();
}

class TimelineDiagramState extends State<TimelineDiagram> {

  static const sheetHeight = 120.0;

  static const _rowHeight = sheetHeight/4;
  static const _headers = ['Check', 'Enroll', 'Validate', 'Remove'];

  final _list = <Data>[];
  final _queueList = <EntryData>[];

  final _scrollController = ScrollController();
  final _listKey = GlobalKey<AnimatedListState>();
  AnimatedListState get _listState => _listKey.currentState!;

  Timer? _scrollTimer;
  Timer? _onChildAddedTimer;

  void clear() {
    _list.clear();
    _listState.removeAllItems((context, animation) => _itemRemovedBuilder(context, animation, null));
  }

  void insertInitialData(List<Data> data) {
    List<Data> cData = [...data];
    cData.removeWhere((element) => element is EntryData ? element.meta is OtpMeta : false);
    _list.addAll(cData);
    _listState.insertAllItems(0, _list.length);

    _doScrollToTheEnd();
  }

  void insert(EntryData data) {
    if (data.meta is OtpMeta) return;

    if (_queueList.isEmpty) {
      int index0 = _list.length-1;
      Data data0 = _list.removeAt(index0);
      _listState.removeItem(index0, (context, animation) => _itemRemovedBuilder(context, animation, data0));
    }
    _queueList.add(data);

    _onChildAddedTimer?.cancel();
    _onChildAddedTimer = Timer(const Duration(milliseconds: 300), () {
      for (var entryData in _queueList) {
        int index1 = _list.length;
        _list.insert(index1, entryData);
        _listState.insertItem(index1);
      }
      _queueList.clear();

      int index2 = _list.length;
      EntryData entryData = _list.last as EntryData;
      _list.insert(index2, ExpectedEntryData(entryData.type));
      _listState.insertItem(index2);

      _doScrollToTheEnd();
    });
  }

  void remove(EntryData data) {
    int index0 = _list.indexOf(data);
    if (index0 != -1) {
      Data data0 = _list.removeAt(index0);
      _listState.removeItem(index0, (context, animation) => _itemRemovedBuilder(context, animation, data0));

      int index1 = _list.length-1;
      Data data1 = _list.removeAt(index1);
      _listState.removeItem(index1, (context, animation) => _itemRemovedBuilder(context, animation, data1));

      Timer(const Duration(milliseconds: 300), () {
        int index2 = _list.length;
        EntryData entryData = _list.last as EntryData;
        _list.insert(index2, ExpectedEntryData(entryData.type));
        _listState.insertItem(index2);
      });
    }
  }

  _doScrollToTheEnd() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 100), () async {
      do {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } while (_scrollController.position.pixels != _scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var header in _headers) SizedBox(
              width: 80,
              height: _rowHeight,
              child: _borderWrap(
                child: Center(
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: AnimatedList(
          key: _listKey,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          initialItemCount: _list.length,
          itemBuilder: (context, i, animation) => _itemInsertedBuilder(context, animation, _list[i]),
        ),
      ),
    ],
  );

  Widget _borderWrap({required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        Container(
          height: 1,
          color: Colors.grey.shade400,
        ),
      ],
    );
  }

  Widget _itemInsertedBuilder(BuildContext context, Animation<double> animation, Data data) {
    Animation<Offset> anim = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(animation);
    return SlideTransition(
      position: anim,
      child: FadeTransition(
        opacity: animation,
        child: _pickWidgetByData(data),
      ),
    );
  }

  Widget _itemRemovedBuilder(BuildContext context, Animation<double> animation, Data? data) {
    Animation<Offset> anim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(animation);
    return SlideTransition(
      position: anim,
      child: FadeTransition(
        opacity: animation,
        child: _pickWidgetByData(data),
      ),
    );
  }

  Widget _pickWidgetByData(Data? data) {
    switch (data.runtimeType) {
      case EntryData:
        data as EntryData;
        return Column(
          children: [
            for (var header in _headers) SizedBox.square(
              dimension: _rowHeight,
              child: _borderWrap(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: header.toLowerCase() == data.type.toLowerCase()
                      ? CircleAvatar(
                          radius: _rowHeight/2,
                          backgroundColor: ColorPicker.pickColorByDataType(data.type),
                        )
                      : null,
                ),
              ),
            ),
          ],
        );
      case ExpectedEntryData:
        data as ExpectedEntryData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var header in _headers) SizedBox.square(
              dimension: _rowHeight,
              child: _borderWrap(
                child: Padding(
                  padding: const EdgeInsets.all(9.0).copyWith(bottom: 8),
                  child: header.toLowerCase() == data.expectedType.toLowerCase()
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorPicker.pickColorByDataType(data.expectedType),
                        )
                      : null,
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.square(dimension: _rowHeight);
    }
  }
}