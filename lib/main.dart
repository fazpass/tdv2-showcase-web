import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_web/firebase_options.dart';
import 'package:tdv2_showcase_web/object/data.dart';
import 'package:tdv2_showcase_web/object/meta.dart';
import 'package:tdv2_showcase_web/widget/entry_otp_view.dart';
import 'package:tdv2_showcase_web/widget/entry_view.dart';
import 'package:tdv2_showcase_web/widget/phone_field.dart';
import 'package:tdv2_showcase_web/widget/timeline_diagram_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDV2 Showcase Web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromRGBO(232, 232, 232, 1.0),
        cardColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final scrollController = ScrollController();
  bool scrollToTheEnd = true;

  BuildContext? scaffoldContext;

  final listKey = GlobalKey<SliverAnimatedListState>();
  SliverAnimatedListState get listState => listKey.currentState!;

  final timelineKey = GlobalKey<TimelineDiagramViewState>();
  TimelineDiagramViewState get timelineState => timelineKey.currentState!;

  StreamSubscription<DatabaseEvent>? onChildChanged;

  final list = <Data>[];
  final queueList = <EntryData>[];

  Timer? scrollTimer;
  Timer? onChildAddedTimer;

  doScrollToTheEnd() {
    scrollTimer?.cancel();
    if (scrollToTheEnd) {
      scrollTimer = Timer(const Duration(milliseconds: 100), () async {
        do {
          await scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } while (scrollToTheEnd && scrollController.position.pixels != scrollController.position.maxScrollExtent);
      });
    }
  }

  onChangePhone(String? newPhone) async {
    // if phone input unlocked
    if (newPhone == null) {
      await onChildChanged?.cancel();
      list.clear();
      listState.removeAllItems((context, animation) => _itemRemovedBuilder(context, animation, null));
      timelineState.clear();
      return;
    }

    // get all data before listening to changes
    final initialSnapshot = await FirebaseDatabase.instance.ref('logs/$newPhone').orderByKey().get();
    for (var child in initialSnapshot.children) {
      try {
        EntryData data = EntryData.fromSnapshot(child);
        list.add(data);
      } catch (_) {}
    }

    // insert all items to list widget and timeline widget
    listState.insertAllItems(0, list.length);
    timelineState.insertInitialData(list);

    doScrollToTheEnd();

    // listen when child is added
    onChildChanged = FirebaseDatabase.instance.ref('logs/$newPhone').orderByKey().onChildChanged.listen((event) {
      EntryData data = EntryData.fromSnapshot(event.snapshot)
        ..shouldAnimate=true;

      /*if (list.isNotEmpty && list.last is ExpectedEntryData) {
        int index0 = list.length-1;
        Data data0 = list.removeAt(index0);
        listState.removeItem(index0, (context, animation) => _itemRemovedBuilder(context, animation, data0));
      }*/

      queueList.add(data);
      timelineState.insert(data);

      if (queueList.length == 1) {
        Timer(const Duration(milliseconds: 300), () {
          int index1 = list.length;
          list.insert(index1, data);
          listState.insertItem(index1);

          doScrollToTheEnd();
        });
      }
    }, onError: (e, StackTrace trace) {
      print(e);
    });
  }

  onFinishEntryAnimation() {
    queueList.first.shouldAnimate = false;
    queueList.removeAt(0);

    if (queueList.isNotEmpty) {
      Timer(const Duration(milliseconds: 300), () {
        int index = list.length;
        list.insert(index, queueList.first);
        listState.insertItem(index);
      });
    }

    /*if (queueList.isEmpty && list.last is EntryData) {
      int index = list.length;
      EntryData entryData = list.last as EntryData;
      list.insert(index, ExpectedEntryData(entryData.type));
      listState.insertItem(index);
    }*/
  }

  showTimelineDiagram() {
    showBottomSheet(
      context: scaffoldContext!,
      enableDrag: false,
      constraints: const BoxConstraints(maxHeight: TimelineDiagramViewState.sheetHeight),
      builder: (context) => TimelineDiagramView(key: timelineKey),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      showTimelineDiagram();
    });
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          scaffoldContext ??= context;
          return Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    forceMaterialTransparency: true,
                    floating: true,
                    title: PhoneField(onChangePhone: onChangePhone),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0).copyWith(bottom: 200),
                    sliver: SliverAnimatedList(
                      key: listKey,
                      initialItemCount: list.length,
                      itemBuilder: (context, index, animation) => _itemInsertedBuilder(context, animation, list[index]),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 140,
                right: 30,
                child: FloatingActionButton.extended(
                  icon: const Icon(Icons.vertical_align_bottom),
                  label: Text(scrollToTheEnd ? 'Auto Scroll to bottom' : 'Don\'t Auto Scroll to bottom'),
                  onPressed: () {
                    setState(() {
                      scrollToTheEnd = !scrollToTheEnd;
                    });
                    if (scrollToTheEnd) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
      ),
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
        if (data.meta is OtpMeta) {
          if (data.shouldAnimate) onFinishEntryAnimation();
          return EntryOtpView(data: data);
        } else if (data.meta is FazpassMeta || data.meta is FazpassRemoveMeta) {
          return EntryView(data: data, onFinished: onFinishEntryAnimation);
        }
        return const SizedBox();
      /*case ExpectedEntryData:
        data as ExpectedEntryData;
        return ExpectedEntryView(action: data.expectedType);*/
      default:
        return const Card(
          child: SizedBox(height: 120),
        );
    }
  }
}