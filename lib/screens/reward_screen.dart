import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/scratch_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer/shimmer.dart';

class RewardScreen extends BaseRoute {
  const RewardScreen({super.key, super.a, super.o}) : super(r: 'RewardScreen');

  @override
  BaseRouteState<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends BaseRouteState<RewardScreen> {
  List<ScratchCard>? _scratchCardList = [];
  final scratchKey = GlobalKey<ScratcherState>();
  ScratchCard? _scratchCard;
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  _RewardScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_rewards),
          ),
          body: _isDataLoaded
              ? _scratchCardList!.isNotEmpty
                  ? SingleChildScrollView(
                      child: Center(
                      child: Wrap(spacing: 12, runSpacing: 12, children: _rewardList()),
                    ))
                  : Center(
                      child: Text(
                      AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ))
              : _shimmer()),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _getScratchCards() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getScratchCards().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _scratchCardList = result.recordList;

              setState(() {});
            } else if (result.status == "0") {
              _scratchCardList!.clear();
            }
            _isDataLoaded = true;
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - reward_screen.dart - _getScratchCards():$e");
    }
  }

  _init() async {
    await _getScratchCards();
  }

  _onScratch(int? scratchId) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.onScratch(scratchId, global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _scratchCard = result.recordList;
              setState(() {});
            } else if (result.status == "0") {
              _scratchCard = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - reward_screen.dart - _onScratch():$e");
    }
  }

  List<Widget> _rewardList() {
    List<Widget> list = [];
    for (int index = 0; index < _scratchCardList!.length; index++) {
      list.add(_scratchCardList![index].isScratch
          ? _scratchCardWidget(index)
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Scratcher(
                key: scratchKey,
                image: Image(image: NetworkImage(global.baseUrlForImage + _scratchCardList![index].scratchCardImage!)),
                brushSize: 30,
                threshold: 50,
                accuracy: ScratchAccuracy.low,
                enabled: _scratchCardList![index].isScratch ? false : true,
                onThreshold: () async {
                  await _onScratch(_scratchCardList![index].scratchId);
                  if (_scratchCard != null) {
                    _scratchCardList![index].isScratch = true;
                    scratchKey.currentState!.reveal(duration: const Duration(milliseconds: 2000));
                    setState(() {});
                  }
                },
                onScratchUpdate: () {},
                onScratchEnd: () {},
                onScratchStart: () {},
                child: _scratchCardWidget(index),
              ),
            ));
    }
    return list;
  }

  Widget _scratchCardWidget(int index) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () {},
      child: SizedBox(
        height: ((MediaQuery.of(context).size.width / 2) - 20) * 1.3,
        width: (MediaQuery.of(context).size.width / 2) - 20,
        child: Card(
            color: const Color(0xFFFA692C),
            margin: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.gift,
                    size: 38,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '${_scratchCardList![index].earnPoints}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.displayLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text('${_scratchCardList![index].earning}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _shimmer() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 6 / 8,
            children: List.generate(6, (index) {
              return SizedBox(
                  height: ((MediaQuery.of(context).size.width / 2) - 20) * 1.3,
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  child: const Card(
                    color: Color(0xFFFA692C),
                    margin: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
                  ));
            }),
          ),
        ));
  }
}
