import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/notification_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends BaseRoute {
  const NotificationScreen({super.key, super.a, super.o}) : super(r: 'NotificationScreen');
  @override
  BaseRouteState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends BaseRouteState<NotificationScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isDataLoaded = false;
  List<NotificationList>? _notificationList = [];
  _NotificationScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              _notificationList != null && _notificationList!.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _delConfirmationDialog();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    )
                  : const SizedBox()
            ],
            title: Text(
              AppLocalizations.of(context)!.lbl_notification,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: _isDataLoaded
              ? _notificationList != null && _notificationList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _notificationList!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Card(
                              elevation: 5,
                              child: ExpansionTile(
                                childrenPadding: const EdgeInsets.all(15),
                                leading: _notificationList![index].image != ''
                                    ? CachedNetworkImage(
                                        imageUrl: _notificationList![index].image!,
                                        imageBuilder: (context, imageProvider) => CircleAvatar(radius: 30, backgroundImage: imageProvider),
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      )
                                    : const CircleAvatar(
                                        radius: 30,
                                        child: Icon(Icons.notifications),
                                      ),
                                title: Text(
                                  '${_notificationList![index].notificationTitle}',
                                  style: Theme.of(context).primaryTextTheme.titleSmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                children: [
                                  Text(
                                    '${_notificationList![index].notificationMessage}',
                                    style: Theme.of(context).primaryTextTheme.titleMedium,
                                  ),
                                ],
                              )),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                )
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _delConfirmationDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.lbl_delete_notification,
                ),
                content: Text(AppLocalizations.of(context)!.txt_are_you_sure_you_want_to_delete_all_notification),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_no,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      // Dismiss the dialog but don't
                      // dismiss the swiped item
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context)!.lbl_yes),
                    onPressed: () async {
                      showOnlyLoaderDialog();
                      bool isSuccess = await _deleteAllNotifications();
                      if (isSuccess) {
                        _notificationList!.clear();
                      }
                      hideLoader();
                      if(!context.mounted) return;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      debugPrint('Exception - notification_screen.dart - _delConfirmationDialog(): $e');
    }
  }

  Future<bool> _deleteAllNotifications() async {
    bool isdeletedSuccessfully = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.deleteAllNotifications(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              isdeletedSuccessfully = true;
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
            } else if (result.status == "0") {
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isdeletedSuccessfully;
    } catch (e) {
      debugPrint("Exception - notification_screen.dart - _deleteAllNotifications():$e");
      return isdeletedSuccessfully;
    }
  }

  _getNotifications() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getNotifications(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _notificationList = result.recordList;
              _isDataLoaded = true;

              setState(() {});
            } else if (result.status == "0") {
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - notification_screen.dart - _getNotifications():$e");
    }
  }

  _init() async {
    await _getNotifications();
  }
}
