// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:lottie/lottie.dart';

// class VoiceChatScreen extends StatefulWidget {
//   const VoiceChatScreen({super.key});

//   @override
//   State<VoiceChatScreen> createState() => _VoiceChatScreenState();
// }

// class _VoiceChatScreenState extends State<VoiceChatScreen>
//     with SingleTickerProviderStateMixin {
//   final RTCVideoRenderer _audioRenderer = RTCVideoRenderer();
//   bool isListening = false;
//   bool isProcessing = false;
//   RTCPeerConnection? _peerConnection;
//   RTCDataChannel? dataChannel;
//   MediaStream? _localStream;
//   MediaRecorder? _mediaRecorder;
//   Timer? _waveformTimer;
//   Timer? _usageTimer;
//   bool _isTimerActive = false;
//   Timer? _keyRefreshTimer;
//   int _elapsedSeconds = 0;
//   String? _ephemeralKey;
//   late AnimationController _animationController;
//   String recognizedText = '';
//   String? accessToken;
//   bool _showAnimation = false;
//   // late VoiceChatCubit _voiceChatCubit;

//   @override
//   void initState() {
//     // _voiceChatCubit = VoiceChatCubit()..getVoiceAsststantToken();
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     _initializeRenderer();
//     _initializeVoiceChat();
//   }

//   void _initializeRenderer() async {
//     await _audioRenderer.initialize();
//   }

//   _initializeVoiceChat() async {
//     String? token = await LocalStorage.retrieve(LSKey.token);
//     setState(() {
//       accessToken = token;
//     });
//   }

//   void _startKeyRefreshTimer() {
//     _keyRefreshTimer?.cancel();
//     _keyRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
//       // _voiceChatCubit.getVoiceAsststantToken();
//     });
//   }

// // Add this method to handle timer and API calls
//   void _handleUsageTracking() {
//     if (_isTimerActive) return;
//     _isTimerActive = true;
//     _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted || !_isTimerActive) {
//         timer.cancel();
//         return;
//       }

//       setState(() {
//         _elapsedSeconds++;
//       });
//       // When we hit 60 seconds (1 minute), call the API
//       if (_elapsedSeconds % 60 == 0) {
//         _updateUsageOnBackend();
//       }
//     });
//   }

//   Future<void> _updateUsageOnBackend() async {
//     try {
//       // final updated = await _voiceChatCubit.updateVoiceAsststantUsage();
//       // if (!updated) {
//       //   debugPrint('--------Failed to update usage');
//       // }
//     } catch (e) {
//       debugPrint('Failed to update usage: $e');
//     }
//   }

//   Future<void> _initWebRTC() async {
//     if (_ephemeralKey == null) return;

//     final configuration = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ]
//     };

//     try {
//       _peerConnection = await createPeerConnection(configuration);
//       _peerConnection!.onConnectionState = (state) {
//         switch (state) {
//           case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
//           case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
//           case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
//             _usageTimer?.cancel();
//             break;
//           default:
//             _handleUsageTracking();
//         }
//         debugPrint('Connection state: $state');
//       };
//     } catch (e) {
//       debugPrint('WebRTC initialization error: $e');
//     }
//   }

//   Future<void> _initLocalStream() async {
//     final mediaConstraints = <String, dynamic>{
//       'audio': true,
//       'video': false,
//       'mandatory': {
//         'googNoiseSuppression': true, // Noise suppression
//         'googEchoCancellation': true, // Echo cancellation
//         'googAutoGainControl': true, // Auto gain control
//         'minSampleRate': 16000, // Minimum sample rate (Hz)
//         'maxSampleRate': 48000, // Maximum sample rate (Hz)
//         'minBitrate': 32000, // Minimum bitrate (bps)
//         'maxBitrate': 128000, // Maximum bitrate (bps)
//       },
//       'optional': [
//         {
//           'googHighpassFilter': true
//         }, // High-pass filter, enhances voice quality
//       ],
//     };

//     try {
//       _localStream =
//           await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       _localStream!.getTracks().forEach((track) {
//         _peerConnection!.addTrack(track, _localStream!);
//       });

//       // Create data channel
//       dataChannel = await _peerConnection!
//           .createDataChannel('oai-events', RTCDataChannelInit());
//     } catch (e) {
//       debugPrint('----Error getting user media: $e');
//     }
//   }

//   Future<void> _createOffer() async {
//     try {
//       RTCSessionDescription description = await _peerConnection!.createOffer();
//       await _peerConnection!.setLocalDescription(description);

//       // Send SDP to server
//       await sendSDPToServer(description.sdp, (remoteSdp) {
//         debugPrint("----Sent SDP to server successfully: $remoteSdp");
//         // Set RemoteSdp
//         try {
//           RTCSessionDescription remoteDescription =
//               RTCSessionDescription(remoteSdp, 'answer');
//           debugPrint("---- remoteDescription: ${remoteDescription.sdp}");
//           _peerConnection!.setRemoteDescription(remoteDescription);
//         } catch (erroe1) {
//           debugPrint("---- Failed to set RemoteSdp: $erroe1");
//         }
//       }, () {
//         debugPrint("----Failed to send SDP to server");
//       });
//     } catch (e) {
//       debugPrint('----Error creating offer: $e');
//     }
//   }

//   Future<void> _restartWebRTC() async {
//     await _stopWebRTC();
//     await _initWebRTC();
//     if (isListening) {
//       await _initLocalStream();
//       await _createOffer();
//     }
//   }

//   Future<void> _stopWebRTC() async {
//     await _mediaRecorder?.stop();
//     _localStream?.getTracks().forEach((track) => track.stop());
//     await _peerConnection?.close();
//     _peerConnection = null;
//     _localStream = null;
//     _mediaRecorder = null;
//   }

//   void _startRecording() async {
//     if (_ephemeralKey == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Waiting for server connection...')),
//       );
//       return;
//     }
//     setState(() {
//       isListening = true;
//       _showAnimation = true;
//       recognizedText = '';
//     });
//     await _initWebRTC();
//     await _initLocalStream();
//     await _createOffer();

//     // Start the usage timer
//     _handleUsageTracking();

//     setState(() => isListening = true);

//     await _animationController.forward();

//     dataChannel?.onMessage = (RTCDataChannelMessage message) {
//       _animationController.repeat();
//       if (message.isBinary) {
//         debugPrint(
//             "----Callback method--Received binary message of length: ${message.binary.length}");
//       } else {
//         debugPrint(
//             "----Callback method--Received text message: ${message.text}");
//         // try {
//         //   final jsonMessage = jsonDecode(message.text);
//         //   if (jsonMessage['transcript'] != null) {
//         //     setState(() {
//         //       recognizedText = jsonMessage['transcript'];
//         //     });
//         //   }
//         // } catch (e) {
//         //   debugPrint(e.toString());
//         // }
//       }
//     };

//     _peerConnection?.onAddStream = (MediaStream stream) {
//       debugPrint("----Received remote media stream");
//       setState(() {
//         _audioRenderer.srcObject = stream;
//       });
//       // Get audio or video tracks
//       final audioTracks = stream.getAudioTracks();
//       // var videoTracks = stream.getVideoTracks();
//       if (audioTracks.isNotEmpty) {
//         debugPrint("----Audio track received");
//         Helper.setSpeakerphoneOn(true);
//         // Attach the audio stream to the renderer
//       }
//     };
//   }

//   void _stopRecording() async {
//     _isTimerActive = false;
//     // Stop the usage timer
//     _usageTimer?.cancel();
//     await _stopWebRTC();
//     _animationController.stop();
//     if (mounted) {
//       setState(() {
//         isListening = false;
//         _showAnimation = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _isTimerActive = false;
//     _audioRenderer.dispose();
//     _animationController.dispose();
//     _stopRecording();
//     _waveformTimer?.cancel();
//     _usageTimer?.cancel();
//     _keyRefreshTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> sendSDPToServer(
//       String? sdp, Function(String) onSuccess, Function() onFailure) async {
//     final url = Uri.parse("https://api.openai.com/v1/realtime");
//     try {
//       final client = HttpClient();
//       final request = await client.postUrl(url);
//       debugPrint('----$_ephemeralKey');
//       // Set request headers
//       request.headers.set("Authorization", "Bearer $_ephemeralKey");
//       request.headers.set("Content-Type", "application/sdp");

//       // Write request body
//       request.write(sdp);

//       // Send request and get response
//       final response = await request.close();
//       final responseBody = await response.transform(utf8.decoder).join();
//       debugPrint(
//           "----Network request successful, response content: $responseBody");
//       if (responseBody.isNotEmpty) {
//         onSuccess(responseBody);
//       } else {
//         onFailure();
//       }
//     } catch (e) {
//       debugPrint("---catch-->${e.toString()}");
//       onFailure();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _voiceChatCubit,
//       child: BlocListener<VoiceChatCubit, VoiceChatState>(
//         listener: (context, state) {
//           if (state.status == BlocStatus.success) {
//             setState(() {
//               _ephemeralKey = state.token;
//             });
//             _startKeyRefreshTimer();
//           } else if (state.status == BlocStatus.limitExceeed) {
//             _isTimerActive = false;
//             _keyRefreshTimer?.cancel();
//             _stopRecording();
//           }
//         },
//         child: Scaffold(
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 50),
//             child: Column(
//               children: [
//                 _buildHeader(''),
//                 const SizedBox(height: 20),
//                 BlocBuilder<VoiceChatCubit, VoiceChatState>(
//                   builder: (context, state) {
//                     switch (state.status) {
//                       case BlocStatus.initial:
//                         return const Center(
//                           child: Text('Getting ready...'),
//                         );
//                       case BlocStatus.success:
//                         return Expanded(
//                           child: Column(
//                             children: [
//                               Text(_isTimerActive
//                                   ? 'Go ahead, I’m listening . . .'
//                                   : 'Click on mic button to start voice chatting.'),
//                               const SizedBox(height: 16),
//                               LottieBuilder.asset(
//                                 controller: _animationController,
//                                 width: 305,
//                                 'assets/dealpha_lottie/voiceassistant.json',
//                                 delegates: LottieDelegates(
//                                   values: [
//                                     ValueDelegate.color(
//                                       const [
//                                         'Untitled-1 Outlines',
//                                         'Group 1',
//                                         'Fill 1',
//                                         '**'
//                                       ],
//                                       value: Theme.of(context).primaryColor,
//                                     ),
//                                     ValueDelegate.color(
//                                       const [
//                                         'Untitled-1 Outlines',
//                                         'Group 2',
//                                         'Fill 1',
//                                         '**'
//                                       ],
//                                       value: Theme.of(context).primaryColor,
//                                     ),
//                                     ValueDelegate.color(
//                                       const [
//                                         'Shape Layer 1',
//                                         'Ellipse 1',
//                                         'Fill 1',
//                                         '**'
//                                       ],
//                                       value: const Color(0xff5B5B5B),
//                                     ),
//                                     ValueDelegate.color(
//                                       const [
//                                         'Shape Layer 2',
//                                         'Ellipse 1',
//                                         'Fill 1',
//                                         '**'
//                                       ],
//                                       value: const Color(0xff5B5B5B),
//                                     ),
//                                     ValueDelegate.color(
//                                       const [
//                                         'Shape Layer 3',
//                                         'Ellipse 1',
//                                         'Fill 1',
//                                         '**'
//                                       ],
//                                       value: const Color(0xff5B5B5B),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Spacer(),
//                               const SizedBox(height: 30),
//                             ],
//                           ),
//                         );
//                       case BlocStatus.limitExceeed:
//                         return Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const SizedBox(height: 20),
//                               Expanded(
//                                   child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 16),
//                                 child: Column(
//                                   children: [
//                                     LottieBuilder.asset(
//                                       'assets/images/error.json',
//                                       width: 180,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Text(
//                                       Trans.current.voice_limit_msg,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     ElevatedButton.icon(
//                                       onPressed: () => Navigator.of(context)
//                                           .push(MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const SubscriptionScreen())),
//                                       style: ButtonStyle(
//                                         backgroundColor:
//                                             WidgetStateProperty.all(
//                                                 const Color.fromARGB(
//                                                     255, 212, 175, 55)),
//                                         minimumSize: WidgetStateProperty.all(
//                                             Size(
//                                                 MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 52)),
//                                       ),
//                                       icon: const Icon(TablerIcons.sparkles,
//                                           color: Colors.white),
//                                       label: Text(
//                                         Trans.current.upgrade_now,
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                             ],
//                           ),
//                         );
//                       case BlocStatus.loading:
//                         return const Expanded(
//                           child: Column(
//                             children: [
//                               SizedBox(height: 150),
//                             ],
//                           ),
//                         );
//                       default:
//                         return Expanded(
//                           child: Column(
//                             children: [
//                               Text(Trans.current.something_went_wrong),
//                               const SizedBox(height: 130),
//                             ],
//                           ),
//                         );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: Container(
//             height: 200,
//             padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.tertiary,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               border: Border(
//                 top: BorderSide(
//                   color: Theme.of(context).colorScheme.outline,
//                 ),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       TablerIcons.info_circle,
//                       size: 12,
//                       color: Theme.of(context).colorScheme.outlineVariant,
//                     ),
//                     const SizedBox(width: 4),
//                     Flexible(
//                       child: Text.rich(
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             fontWeight: FontWeight.w400,
//                             color:
//                                 Theme.of(context).colorScheme.outlineVariant),
//                         TextSpan(
//                           text: Trans.current.go_to_premium,
//                           children: [
//                             const TextSpan(text: ' '),
//                             TextSpan(
//                               text: Trans.current.upgrade_now,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall
//                                   ?.copyWith(
//                                       fontWeight: FontWeight.w500,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .primary),
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) =>
//                                           const SubscriptionScreen()));
//                                 },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         height: 48,
//                         width: 48,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Theme.of(context).colorScheme.surfaceContainer,
//                         ),
//                         child: const IconifyIcon(
//                           icon: 'solar:keyboard-linear',
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: isListening ? _stopRecording : _startRecording,
//                       child: Container(
//                         height: 80,
//                         width: 80,
//                         padding: const EdgeInsets.all(22),
//                         decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color(0xff1A1A40),
//                                 Color(0xff1A1A40),
//                               ],
//                             ),
//                             border: Border(
//                               top: BorderSide(
//                                 width: 4,
//                                 color: Color(0xff262660),
//                               ),
//                               left: BorderSide(
//                                 width: 4,
//                                 color: Color(0xff262660),
//                               ),
//                               right: BorderSide(
//                                 width: 4,
//                                 color: Color(0xff262660),
//                               ),
//                             )),
//                         child: Icon(isListening
//                             ? TablerIcons.player_pause
//                             : TablerIcons.microphone),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: 48,
//                         width: 48,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Theme.of(context).colorScheme.surfaceContainer,
//                         ),
//                         child: const IconifyIcon(
//                           icon: 'uim:multiply',
//                           color: Colors.white,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(String? assistantName) {
//     return BlocConsumer<VoiceChatCubit, VoiceChatState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Container(
//                 height: 36,
//                 width: 36,
//                 alignment: Alignment.center,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0xff1C1C1C)),
//                 child: Icon(
//                   Icons.chevron_left,
//                   color: Theme.of(context).primaryColor,
//                   size: 20,
//                 ),
//               ),
//             ),
//             Text(
//               isListening
//                   ? "${state.assistant?.name ?? ''} ${Trans.current.listening}"
//                   : Trans.current.voice_assistant,
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             GestureDetector(
//               onTap: () {
//                 // Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //       builder: (context) => const RecognizerSetting(
//                 //             isDialog: false,
//                 //           )),
//                 // );
//               },
//               child: const IconifyIcon(
//                 icon: 'ci:more-horizontal',
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
