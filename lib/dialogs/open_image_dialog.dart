import 'dart:typed_data';

import 'package:app/models/barber_shop_desc_model.dart';
import 'package:app/models/businessLayer/base.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OpenImageDialog extends Base {
  final Uint8List? image;
  final BarberShopDesc? barberShopDesc;
  final int? index;
  final String? name;

  const OpenImageDialog({super.key, a, o, this.image, this.barberShopDesc, this.index, this.name}) : super(analytics: a, observer: o);
  @override
  BaseState<OpenImageDialog> createState() => OpenImageDialogState();
}

class OpenImageDialogState extends BaseState<OpenImageDialog> {
  OpenImageDialogState() : super();

  int? currentIndex = 0;
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      pageController = PageController(initialPage: widget.index!);
      currentIndex = widget.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.lbl_gallery ),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
          child: widget.barberShopDesc != null && widget.index != null
              ? PhotoViewGallery.builder(
                  customSize: const Size(300, 300),
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider(global.baseUrlForImage +
                      widget.barberShopDesc!.gallery[index].image!),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                    );
                  },
                  itemCount: widget.barberShopDesc!.gallery.length,
                  loadingBuilder: (context, event) => Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                        value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  pageController: pageController,
                 
                )
              : PhotoView(
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  imageProvider: MemoryImage(widget.image!),
                )),
    );
  }


}