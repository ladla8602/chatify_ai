import 'dart:convert';
import 'dart:io';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class SpeechService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCDataChannel? _dataChannel;
  final RTCVideoRenderer audioRenderer = RTCVideoRenderer();

  Future<void> initialize() async {
    await audioRenderer.initialize();
    await _setupWebRTC();
  }

  Future<void> _setupWebRTC() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);
    _setupPeerConnectionListeners();
  }

  void _setupPeerConnectionListeners() {
    _peerConnection?.onConnectionState = (state) {
      print('Connection state: $state');
    };

    _peerConnection?.onAddStream = (stream) {
      audioRenderer.srcObject = stream;
    };
  }

  Future<void> startVoiceChat(String ephemeralKey) async {
    await _initLocalStream();
    await _createOffer(ephemeralKey);
  }

  Future<void> _initLocalStream() async {
    final mediaConstraints = {
      'audio': true,
      'video': false,
      'mandatory': {
        'googNoiseSuppression': true,
        'googEchoCancellation': true,
        'googAutoGainControl': true,
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _dataChannel = await _peerConnection?.createDataChannel(
      'oai-events',
      RTCDataChannelInit(),
    );
  }

  Future<void> _createOffer(String ephemeralKey) async {
    try {
      final description = await _peerConnection?.createOffer();
      await _peerConnection?.setLocalDescription(description!);

      await _sendSDPToServer(description?.sdp, ephemeralKey,
          onSuccess: (remoteSdp) async {
        final remoteDesc = RTCSessionDescription(remoteSdp, 'answer');
        await _peerConnection?.setRemoteDescription(remoteDesc);
      }, onError: (error) {
        print('Error setting remote description: $error');
      });
    } catch (e) {
      print('Error creating offer: $e');
    }
  }

  Future<void> _sendSDPToServer(
    String? sdp,
    String ephemeralKey, {
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final url = Uri.parse('https://api.openai.com/v1/realtime');
    final client = HttpClient();

    try {
      final request = await client.postUrl(url);
      request.headers.set('Authorization', 'Bearer $ephemeralKey');
      request.headers.set('Content-Type', 'application/sdp');

      if (sdp != null) {
        request.write(sdp);
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        onSuccess(responseBody);
      } else {
        onError('Server returned ${response.statusCode}');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> stopVoiceChat() async {
    await _localStream?.dispose();
    await _peerConnection?.close();
    await audioRenderer.dispose();
    _localStream = null;
    _peerConnection = null;
  }

  void dispose() {
    stopVoiceChat();
  }
}
