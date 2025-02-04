import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player_plus/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import './../../types/types.dart' as types;
import 'audio_player/PlaySpeedSelector.dart';
import 'audio_player/PlayingControlsSmall.dart';
import 'audio_player/PositionSeekWidget.dart';

class AudioMessage extends StatefulWidget {
  const AudioMessage({
    super.key,
    required this.message,
  });

  /// [types.AudioMessage].
  final types.AudioMessage message;

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  late AssetsAudioPlayerPlus _assetsAudioPlayer;
  late Audio audio;

  double progress = 0.0;
  bool _isDownloading = false;

  @override
  void initState() {
    // printlog(widget.message.uri, stackTrace: 'current ');
    _assetsAudioPlayer = AssetsAudioPlayerPlus.newPlayer();
    audio = Audio.network(
      widget.message.uri,
      metas: Metas(
        id: widget.message.id,
        title: widget.message.name,
      ),
    );
    super.initState();
    _assetsAudioPlayer.current.listen((data) {
      // printlog('current : $data');
    });
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _assetsAudioPlayer.loopMode,
      builder: (context, AsyncSnapshot<LoopMode> snapshotLooping) {
        if (!snapshotLooping.hasData) return const SizedBox();
        final loopMode = snapshotLooping.data!;
        return StreamBuilder(
          stream: _assetsAudioPlayer.isPlaying,
          initialData: false,
          builder: (context, AsyncSnapshot<bool> snapshotPlaying) {
            if (!snapshotPlaying.hasData) return const SizedBox();
            final isPlaying = snapshotPlaying.data!;
            return NeumorphicTheme(
              theme: Theme.of(context).brightness == Brightness.dark ? neumorphicDefaultDarkTheme : neumorphicDefaultTheme,
              child: Neumorphic(
                margin: const EdgeInsets.all(8),
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      audio.metas.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Neumorphic(
                                  style: const NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.circle(),
                                    shape: NeumorphicShape.concave,
                                  ),
                                  child: _isDownloading
                                      ? getFilledTrackStyle()
                                      : IconButton(
                                          onPressed: () => _downloadAudioWithProgress(widget.message),
                                          icon: const Icon(Icons.download),
                                        ),
                                ),
                              ),
                              // Expanded(child: Container(),),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: PlayingControlsSmall(
                            loopMode: loopMode,
                            isPlaying: isPlaying,
                            toggleLoop: () {
                              _assetsAudioPlayer.toggleLoop();
                            },
                            onPlay: () {
                              if (!_assetsAudioPlayer.current.hasValue) {
                                _assetsAudioPlayer.open(audio, autoStart: true, showNotification: true);
                              } else {
                                _assetsAudioPlayer.playOrPause();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: _assetsAudioPlayer.realtimePlayingInfos,
                        builder: (context, AsyncSnapshot<RealtimePlayingInfos> snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          final infos = snapshot.data!;
                          return Column(
                            children: [
                              PositionSeekWidget(
                                seekTo: (to) {
                                  _assetsAudioPlayer.seek(to);
                                },
                                duration: infos.duration,
                                currentPosition: infos.currentPosition,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NeumorphicButton(
                                    onPressed: () {
                                      _assetsAudioPlayer.seekBy(const Duration(seconds: -10));
                                    },
                                    child: const Icon(Icons.replay_10),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  NeumorphicButton(
                                    onPressed: () {
                                      _assetsAudioPlayer.seekBy(const Duration(seconds: 10));
                                    },
                                    child: const Icon(Icons.forward_10),
                                  ),
                                ],
                              ),
                              PlayerBuilder.playSpeed(
                                  player: _assetsAudioPlayer,
                                  builder: (context, playSpeed) {
                                    return PlaySpeedSelector(
                                      playSpeed: playSpeed,
                                      onChange: (v) {
                                        _assetsAudioPlayer.setPlaySpeed(v);
                                      },
                                    );
                                  }),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget getFilledTrackStyle() {
    return SizedBox(
      height: 48,
      width: 48,
      child: LinearProgressIndicator(
        value: progress,
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

  Future<void> _downloadAudioWithProgress(types.AudioMessage message) async {
    Dio dio = Dio();
    Directory? directory;
    try {
      String extensionString = message.uri.split('.').last;
      // printlog(extensionString, stackTrace: 'audioDirPath');
      if (Platform.isAndroid) {
        setState(() {
          _isDownloading = true;
        });
        if (defaultTargetPlatform == TargetPlatform.android) {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }
          //downloads folder
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        bool hasExisted = await directory.exists();
        if (!hasExisted) {
          await directory.create();
        }
        String path = '${directory.path}/audio-${DateTime.now().millisecondsSinceEpoch}.$extensionString';

        final String imageUrl = message.uri;

        await dio.download(
          imageUrl,
          path,
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

        setState(() {
          _isDownloading = false;
          progress = 0.0;
        });
        unawaited(Fluttertoast.showToast(msg: "Audio downloaded", toastLength: Toast.LENGTH_SHORT));

        dio.close();
      }
    } catch (e) {
      // unawaited(FlutterPaperTrailPlus.logError(e.toString()));
      dio.close();
      setState(() {
        _isDownloading = false;
        progress = 0.0;
      });
      // printlog(e, stackTrace: '_downloadAudioWithProgress');
    }
  }
}
