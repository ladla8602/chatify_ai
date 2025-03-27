import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as WRTC;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '../services/firebase_functions_service.dart';
import '../services/firestore_service.dart';

class VoiceAssistantController extends GetxController {
  final AnimationController animationController;
  final FirebaseFunctionsService _firebaseFunctionsService;

  VoiceAssistantController({
    required this.animationController,
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  }) : _firebaseFunctionsService = firebaseFunctionsService ?? FirebaseFunctionsService();

  final RTCVideoRenderer _audioRenderer = RTCVideoRenderer();
  var isListening = false.obs;
  var isProcessing = false.obs;
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? dataChannel;
  MediaStream? _localStream;
  MediaRecorder? _mediaRecorder;
  Timer? _waveformTimer;
  Timer? _usageTimer;
  final _isTimerActive = false.obs;
  Timer? _keyRefreshTimer;
  final _elapsedSeconds = 0.obs;
  final _ephemeralKey = ''.obs;
  final recognizedText = ''.obs;
  final accessToken = ''.obs;
  final _showAnimation = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRenderer();
  }

  void _initializeRenderer() async {
    _ephemeralKey.value = await _firebaseFunctionsService.getVoiceChatToken();
    await _audioRenderer.initialize();
    _startKeyRefreshTimer();
  }

  void _startKeyRefreshTimer() {
    _keyRefreshTimer?.cancel();
    _keyRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      _ephemeralKey.value = await _firebaseFunctionsService.getVoiceChatToken();
    });
  }

  void _handleUsageTracking() {
    if (_isTimerActive.value) return;
    _isTimerActive.value = true;
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isTimerActive.value) {
        timer.cancel();
        return;
      }

      _elapsedSeconds.value++;
      if (_elapsedSeconds.value % 60 == 0) {
        _updateUsageOnBackend();
      }
    });
  }

  Future<void> _updateUsageOnBackend() async {
    try {
      // final updated = await _voiceChatCubit.updateVoiceAsststantUsage();
      // if (!updated) {
      //   debugPrint('--------Failed to update usage');
      // }
    } catch (e) {
      debugPrint('Failed to update usage: $e');
    }
  }

  Future<void> _initWebRTC() async {
    if (_ephemeralKey.value.isEmpty) return;

    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    try {
      _peerConnection = await createPeerConnection(configuration);
      _peerConnection!.onConnectionState = (state) {
        switch (state) {
          case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
            _usageTimer?.cancel();
            break;
          default:
            _handleUsageTracking();
        }
        debugPrint('Connection state: $state');
      };
    } catch (e) {
      debugPrint('WebRTC initialization error: $e');
    }
  }

  Future<void> _initLocalStream() async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': false,
      'mandatory': {
        'googNoiseSuppression': true,
        'googEchoCancellation': true,
        'googAutoGainControl': true,
        'minSampleRate': 16000,
        'maxSampleRate': 48000,
        'minBitrate': 32000,
        'maxBitrate': 128000,
      },
      'optional': [
        {'googHighpassFilter': true},
      ],
    };

    try {
      _localStream = await WRTC.navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      dataChannel = await _peerConnection!.createDataChannel('oai-events', RTCDataChannelInit());
    } catch (e) {
      debugPrint('----Error getting user media: $e');
    }
  }

  Future<void> _createOffer() async {
    try {
      RTCSessionDescription description = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(description);

      await sendSDPToServer(description.sdp, (remoteSdp) {
        debugPrint("----Sent SDP to server successfully: $remoteSdp");
        try {
          RTCSessionDescription remoteDescription = RTCSessionDescription(remoteSdp, 'answer');
          debugPrint("---- remoteDescription: ${remoteDescription.sdp}");
          _peerConnection!.setRemoteDescription(remoteDescription);
        } catch (erroe1) {
          debugPrint("---- Failed to set RemoteSdp: $erroe1");
        }
      }, () {
        debugPrint("----Failed to send SDP to server");
      });
    } catch (e) {
      debugPrint('----Error creating offer: $e');
    }
  }

  // Future<void> _restartWebRTC() async {
  //   await _stopWebRTC();
  //   await _initWebRTC();
  //   if (isListening.value) {
  //     await _initLocalStream();
  //     await _createOffer();
  //   }
  // }

  Future<void> _stopWebRTC() async {
    await _mediaRecorder?.stop();
    _localStream?.getTracks().forEach((track) => track.stop());
    await _peerConnection?.close();
    _peerConnection = null;
    _localStream = null;
    _mediaRecorder = null;
  }

  void startRecording() async {
    if (_ephemeralKey.value.isEmpty) {
      Get.snackbar('Error', 'Waiting for server connection...');
      return;
    }
    isListening.value = true;
    _showAnimation.value = true;
    recognizedText.value = '';
    await _initWebRTC();
    await _initLocalStream();
    await _createOffer();

    _handleUsageTracking();

    await animationController.forward();

    dataChannel?.onMessage = (RTCDataChannelMessage message) {
      animationController.repeat();
      if (message.isBinary) {
        debugPrint("----Callback method--Received binary message of length: ${message.binary.length}");
      } else {
        debugPrint("----Callback method--Received text message: ${message.text}");
      }
    };

    _peerConnection?.onAddStream = (MediaStream stream) {
      debugPrint("----Received remote media stream");
      _audioRenderer.srcObject = stream;
      final audioTracks = stream.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        debugPrint("----Audio track received");
        Helper.setSpeakerphoneOn(true);
      }
    };
  }

  void stopRecording() async {
    _isTimerActive.value = false;
    _usageTimer?.cancel();
    await _stopWebRTC();
    animationController.stop();
    isListening.value = false;
    _showAnimation.value = false;
  }

  @override
  void onClose() {
    _isTimerActive.value = false;
    _audioRenderer.dispose();
    animationController.dispose();
    stopRecording();
    _waveformTimer?.cancel();
    _usageTimer?.cancel();
    _keyRefreshTimer?.cancel();
    super.onClose();
  }

  Future<void> sendSDPToServer(String? sdp, Function(String) onSuccess, Function() onFailure) async {
    final url = Uri.parse("https://api.openai.com/v1/realtime");
    try {
      final client = HttpClient();
      final request = await client.postUrl(url);
      debugPrint('----${_ephemeralKey.value}');
      request.headers.set("Authorization", "Bearer ${_ephemeralKey.value}");
      request.headers.set("Content-Type", "application/sdp");
      request.write(sdp);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      debugPrint("----Network request successful, response content: $responseBody");
      if (responseBody.isNotEmpty) {
        onSuccess(responseBody);
      } else {
        onFailure();
      }
    } catch (e) {
      debugPrint("---catch-->${e.toString()}");
      onFailure();
    }
  }
}
