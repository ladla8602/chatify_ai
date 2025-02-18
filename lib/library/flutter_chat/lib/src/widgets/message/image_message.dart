import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './../../types/types.dart' as types;
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../../conditional/conditional.dart';
import '../../utils/util.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

/// A class that represents image message widget. Supports different
/// aspect ratios, renders blurred image as a background which is visible
/// if the image is narrow, renders image in form of a file if aspect
/// ratio is very small or very big.
class ImageMessage extends StatefulWidget {
  /// Creates an image message widget based on [types.ImageMessage].
  const ImageMessage({
    super.key,
    this.imageHeaders,
    this.imageProviderBuilder,
    required this.message,
    required this.messageWidth,
    this.onDownloadTap,
  });

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// See [Chat.imageProviderBuilder].
  final ImageProvider Function({
    required String uri,
    required Map<String, String>? imageHeaders,
    required Conditional conditional,
  })? imageProviderBuilder;

  /// [types.ImageMessage].
  final types.ImageMessage message;

  /// Maximum message width.
  final int messageWidth;

  final Function(types.ImageMessage)? onDownloadTap;

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

/// [ImageMessage] widget state.
class _ImageMessageState extends State<ImageMessage> {
  ImageProvider? _image;
  Size _size = Size.zero;
  ImageStream? _stream;

  double progress = 0.0;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _image = widget.imageProviderBuilder != null
        ? widget.imageProviderBuilder!(
            uri: widget.message.uri,
            imageHeaders: widget.imageHeaders,
            conditional: Conditional(),
          )
        : Conditional().getProvider(
            widget.message.uri,
            headers: widget.imageHeaders,
          );
    _size = Size(widget.message.width ?? 0, widget.message.height ?? 0);
  }

  void _getImage() {
    final oldImageStream = _stream;
    _stream = _image?.resolve(createLocalImageConfiguration(context));
    if (_stream?.key == oldImageStream?.key) {
      return;
    }
    final listener = ImageStreamListener(_updateImage);
    oldImageStream?.removeListener(listener);
    _stream?.addListener(listener);
  }

  void _updateImage(ImageInfo info, bool _) {
    setState(() {
      _size = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_size.isEmpty) {
      _getImage();
    }
  }

  @override
  void dispose() {
    _stream?.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = InheritedUser.of(context).user;

    if (_size.aspectRatio == 0) {
      return Container(
        color: InheritedChatTheme.of(context).theme.secondaryColor,
        height: _size.height,
        width: _size.width,
      );
    } else if (_size.aspectRatio < 0.1 || _size.aspectRatio > 10) {
      return Container(
        color: user.id == widget.message.author.id ? Theme.of(context).primaryColor : InheritedChatTheme.of(context).theme.secondaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              margin: EdgeInsetsDirectional.fromSTEB(
                InheritedChatTheme.of(context).theme.messageInsetsVertical,
                InheritedChatTheme.of(context).theme.messageInsetsVertical,
                16,
                InheritedChatTheme.of(context).theme.messageInsetsVertical,
              ),
              width: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  fit: BoxFit.cover,
                  image: _image!,
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(
                  0,
                  InheritedChatTheme.of(context).theme.messageInsetsVertical,
                  InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
                  InheritedChatTheme.of(context).theme.messageInsetsVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.name,
                      style: user.id == widget.message.author.id
                          ? InheritedChatTheme.of(context).theme.sentMessageBodyTextStyle
                          : InheritedChatTheme.of(context).theme.receivedMessageBodyTextStyle,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        formatBytes(widget.message.size.truncate()),
                        style: user.id == widget.message.author.id
                            ? InheritedChatTheme.of(context).theme.sentMessageCaptionTextStyle
                            : InheritedChatTheme.of(context).theme.receivedMessageCaptionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: widget.messageWidth.toDouble(),
              minWidth: 170,
            ),
            child: AspectRatio(
              aspectRatio: _size.aspectRatio > 0 ? _size.aspectRatio : 1,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.message.uri,
                placeholder: (context, url) => const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _isDownloading
                ? getFilledTrackStyle()
                : IconButton(
                    onPressed: () => _downloadImageWithProgress(widget.message),
                    color: Theme.of(context).primaryColor,
                    icon: const Icon(Icons.download),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor.withOpacity(0.2)), // Set the background color
                    ),
                  ),
          )
        ],
      );
    }
  }

  Widget getFilledTrackStyle() {
    return SizedBox(
      height: 48,
      width: 48,
      child: LinearProgressIndicator(
        value: progress, // Set the progress value
        color: Theme.of(context).primaryColor,
      ),
      // child: SfRadialGauge(axes: <RadialAxis>[
      //   RadialAxis(
      //     showLabels: false,
      //     showTicks: false,
      //     startAngle: 270,
      //     endAngle: 270,
      //     radiusFactor: 0.8,
      //     axisLineStyle: AxisLineStyle(
      //       thickness: 0.05,
      //       color: Theme.of(context).primaryColor,
      //       thicknessUnit: GaugeSizeUnit.factor,
      //     ),
      //     pointers: <GaugePointer>[
      //       RangePointer(
      //         value: progress,
      //         width: 0.95,
      //         pointerOffset: 0.05,
      //         sizeUnit: GaugeSizeUnit.factor,
      //         enableAnimation: true,
      //         animationType: AnimationType.linear,
      //         animationDuration: 75,
      //         color: Theme.of(context).primaryColor,
      //       )
      //     ],
      //   )
      // ]),
    );
  }

  Future<void> _downloadImageWithProgress(types.ImageMessage message) async {
    Dio dio = Dio();
    try {
      setState(() {
        _isDownloading = true;
      });
      final String imageUrl = message.uri;

      final response = await dio.get(
        imageUrl,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Calculate the progress percentage
            setState(() {
              progress = (received / total) * 100;
            });
          }
        },
        options: Options(responseType: ResponseType.bytes),
      );

      // Save the image to a temporary file
      final File tempFile = File('${(await getTemporaryDirectory()).path}/generated_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(Uint8List.fromList(response.data));
      await GallerySaver.saveImage(tempFile.path).then((bool? success) {
        setState(() {
          _isDownloading = false;
          progress = 0.0;
        });
        if (success != null && success) {
          Fluttertoast.showToast(msg: "Image downloaded", toastLength: Toast.LENGTH_SHORT);
        } else {}
      });
      dio.close();
    } catch (e) {
      dio.close();
      setState(() {
        _isDownloading = false;
        progress = 0.0;
      });
      // printlog(e, stackTrace: '_downloadImageWithProgress');
    }
  }
}
