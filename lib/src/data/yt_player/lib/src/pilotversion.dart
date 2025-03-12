import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// ignore: must_be_immutable
class YtPlayer extends StatefulWidget {
  bool isLive;
  String url;
  List<String>? qualities;
  List<String>? playbackspeed;
  Widget? placeholder;
  final Function(bool) fullScreen;

  YtPlayer({
    super.key,
    required this.url,
    required this.isLive,
    this.qualities,
    this.playbackspeed,
    required this.fullScreen,
    this.placeholder,
  });

  @override
  State<YtPlayer> createState() => YtPlayerState();
}

class YtPlayerState extends State<YtPlayer> with TickerProviderStateMixin {
  late AudioOnlyStreamInfo currentAudioStream;
  late VideoOnlyStreamInfo currentStream;
  List<VideoOnlyStreamInfo> videoOnlyStreams = [];
  late VlcPlayerController vlcPlayerCtrl;
  bool isvlcPlayerCtrlinitialized = false;
  bool isFullscreen = false;
  var VideoID;
  bool isLoading = true;
  double hidecontrols = 1;
  Duration currentPosition = Duration.zero;
  Duration backupPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  Duration live_backupPosition = Duration.zero;
  bool fetching = false;
  late AnimationController _controllerLeftseek;
  late AnimationController _controllerRightseek;
  // ignore: non_constant_identifier_names
  late Animation<double> _LeftAnimation;
  // ignore: non_constant_identifier_names
  late Animation<double> _RightAnimation;

  double scale = 1.0; // Initial scale
  double previousScale = 1.0;

  // updated variables
  ValueNotifier<bool?> isPlaying = ValueNotifier(false);
  String? error;

  @override
  void initState() {
    super.initState();

    _seekctrlinitialization();
    _init();
  }

  Future<void> _init() async {
    try {
      if (widget.isLive) {
        _fetchLiveStreamUrl(videoUrl: widget.url);
      } else {
        videoOnlyStreams = await _fetchStreams();
        if (videoOnlyStreams.isNotEmpty) {
          currentStream = await setStream();
          await _initPlayer(
              streamUrl: currentStream.url.toString(), live: false);
        }
      }
    } catch (e) {
      log("Error in _init():$e");
      if (mounted) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }

  Future<String?> _fetchLiveStreamUrl({required String videoUrl}) async {
    log("Initializing _fetchLiveStreamUrl()");
    final yt = YoutubeExplode();

    try {
      var videoId = _extractVideoId(videoUrl);

      if (videoId == null) {
        throw Exception("Invalid video URL");
      }

      log("videoId__Live():$videoId");

      var liveURL =
          await yt.videos.streams.getHttpLiveStreamUrl(VideoId(videoId));

      log("liveURL:$liveURL");

      if (mounted) {
        setState(() {
          VideoID = videoId;
        });
      }

      await _initPlayer(streamUrl: liveURL, live: true);

      _liveStreamStatusChecking(videoId);
    } catch (e) {
      log("Error in _fetchLiveStreamUrl(): $e");
      return null;
    } finally {
      yt.close();
    }
    return null;
  }

  void _liveStreamStatusChecking(String videoId) {
    log("_liveStreamStatusChecking() in $videoId");
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      final yt = YoutubeExplode();
      try {
        var video = await yt.videos.get(VideoId(videoId));
        if (video.isLive) {
        } else {
          log("Live stream has ended.");
          timer.cancel();
          // Handle live stream end (e.g., stop player, show message, etc.)
          _handleLiveStreamEnd();
        }
        _fetchDuration(videoId);
      } catch (e) {
        log("Error in  _liveStreamStatusChecking(): $e");
        timer.cancel();
      } finally {
        yt.close();
      }
    });
  }

  void _handleLiveStreamEnd() {
    // Implement your logic to handle the end of the live stream
    // For example, stop the player, show a message, etc.
    log("Handling live stream end.");
  }

  String? _extractVideoId(String url) {
    try {
      // Regular expression for live stream URL
      final RegExp livePattern = RegExp(r'youtube\.com/live/([a-zA-Z0-9_-]+)');

      // Regular expression for standard watch URL
      final RegExp watchPattern =
          RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)');

      // Regular expression for embed URL
      final RegExp embedPattern =
          RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)');

      // Check for live stream URL
      var match = livePattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }

      // Check for standard watch URL
      match = watchPattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }

      // Check for embed URL
      match = embedPattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }

      // If no match is found, return null
      return null;
    } catch (e) {
      log("Error in _extractVideoId(): $e");
    }
    return null;
  }

  void _fetchDuration(String videoId) async {
    // Calculate the current duration of the live stream
    final yt = YoutubeExplode();
    try {
      var currentTime = DateTime.now();
      var video = await yt.videos.get(VideoId(videoId));
      var liveStreamStartTime = video.uploadDate!.toUtc();
      var currentDuration = currentTime.difference(liveStreamStartTime);

      log("Current live stream duration: $currentDuration");
    } catch (e) {
      log("error in _fetchDuration():$e");
    } finally {
      yt.close();
    }
  }

  Future<VideoOnlyStreamInfo> setStream() async {
    VideoOnlyStreamInfo tempstream;
    tempstream = videoOnlyStreams.firstWhere(
        (stream) => stream.qualityLabel == '480p',
        orElse: () => videoOnlyStreams.last); // by default 360p
    return tempstream;
  }

  Future<List<VideoOnlyStreamInfo>> _fetchStreams() async {
    List<VideoOnlyStreamInfo> videoOnlyStreamstemp = [];
    final yt = YoutubeExplode();
    try {
      var videoId = VideoId(widget.url.toString());
      log("videoId:$videoId");

      log("vdo:${videoId.value}");

      var video = await yt.videos.streamsClient.getManifest(videoId);
      log("video:$video");

      currentAudioStream = video.audioOnly.withHighestBitrate();

      final seenResolutions = <int>{};

      videoOnlyStreamstemp = video.videoOnly.where((streamInfo) {
        final resolution = streamInfo.videoResolution;
        final mimeType = streamInfo.codec.mimeType;

        if (mimeType == 'video/mp4' &&
            (resolution.height == 1080 ||
                resolution.height == 720 ||
                resolution.height == 480 ||
                resolution.height ==
                    360) && // Add any additional relevant heights
            !seenResolutions.contains(resolution.height) &&
            !streamInfo.qualityLabel.contains('HDR')) {
          seenResolutions.add(resolution.height);
          return true;
        } else {
          return false;
        }
      }).toList();
      return videoOnlyStreamstemp;
    } catch (e) {
      log("Error extracting stream: $e");
      return videoOnlyStreamstemp;
    } finally {
      yt.close();
    }
  }

  Future<void> _initPlayer(
      {required String streamUrl, required bool live}) async {
    try {
      vlcPlayerCtrl = VlcPlayerController.network(
        streamUrl,
        autoPlay: true,
        autoInitialize: true,
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (!live) {
        vlcPlayerCtrl.addOnInitListener(() {
          if (mounted) {
            setState(() {
              vlcPlayerCtrl
                  .addAudioFromNetwork(currentAudioStream.url.toString());
            });
          }
        });
      }

      vlcPlayerCtrl.addListener(() {
        if (!widget.isLive) {
          _listenPlayingduration();
        } else {
          log("playing state:${vlcPlayerCtrl.value.playingState}");
          // log('player pos:${vlcPlayerCtrl.value.position}');
        }
        if (mounted) {
          setState(() {
            if (vlcPlayerCtrl.value.position != Duration.zero ||
                vlcPlayerCtrl.value.position > const Duration(seconds: 0)) {
              currentPosition = vlcPlayerCtrl.value.position;
              backupPosition = currentPosition;
            }
            if (vlcPlayerCtrl.value.position != Duration.zero &&
                totalDuration == Duration.zero) {
              totalDuration = vlcPlayerCtrl.value.duration;
            }
            if (vlcPlayerCtrl.value.playingState == PlayingState.playing) {
              isPlaying.value = true;
            }
            if (vlcPlayerCtrl.value.playingState == PlayingState.stopped) {
              isPlaying.value = null;
            }
          });
        }
        if (vlcPlayerCtrl.value.playingState == PlayingState.error) {
          log("Error: ${PlayingState.error}");
        }
      });

      if (mounted) {
        setState(() {
          isvlcPlayerCtrlinitialized = true;
        });
      }
    } catch (e) {
      log("Error :$e");
      if (mounted) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }

  void _seekctrlinitialization() {
    //handle seeking animations ctrl initialization;

    _controllerLeftseek = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    );
    _controllerRightseek = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    );
    _LeftAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controllerLeftseek,
        curve: Curves.easeInOut,
      ),
    );
    _RightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controllerRightseek,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future _changeQuality({required VideoOnlyStreamInfo stream}) async {
    Navigator.of(context).pop();
    try {
      currentStream = stream;
      if (mounted) {
        setState(() {
          fetching = true;
        });
      }

      await vlcPlayerCtrl
          .setMediaFromNetwork(currentStream.url.toString(),
              hwAcc: HwAcc.full, autoPlay: true)
          .then((_) async {
        await vlcPlayerCtrl.seekTo(backupPosition).then((_) {
          vlcPlayerCtrl.addAudioFromNetwork(currentAudioStream.url.toString());
        });
      });

      if (mounted) {
        setState(() {
          fetching = false;
        });
      }
    } catch (e) {
      log('Error in quality change function:$e');
    }
  }

  void _listenPlayingduration() {
    log('backup pos:$backupPosition');
    log('player pos:${vlcPlayerCtrl.value.position}');
    Duration diff = vlcPlayerCtrl.value.position - backupPosition;
    log("difference :$diff");
    if ((diff >= const Duration(seconds: 1) || diff <= Duration.zero) &&
        vlcPlayerCtrl.value.playingState == PlayingState.playing) {
      if (mounted) {
        setState(() {
          fetching = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          fetching = false;
        });
      }
    }
  }

  void _handleLeftTap() {
    if (!widget.isLive) {
      // Start the animation
      _controllerLeftseek.forward().then((_) {
        // Reverse the animation after it completes
        _controllerLeftseek.reverse();
      });
      final currentPosition = vlcPlayerCtrl.value.position;
      final totalDuration = vlcPlayerCtrl.value.duration;
      final newPosition = currentPosition - const Duration(seconds: 10);
      vlcPlayerCtrl
          .seekTo(newPosition < totalDuration ? newPosition : totalDuration);
    }
  }

  void _handleRightTap() {
    if (!widget.isLive) {
      // Start the animation
      _controllerRightseek.forward().then((_) {
        // Reverse the animation after it completes
        _controllerRightseek.reverse();
      });
      final currentPosition = vlcPlayerCtrl.value.position;
      final totalDuration = vlcPlayerCtrl.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 10);
      vlcPlayerCtrl
          .seekTo(newPosition < totalDuration ? newPosition : totalDuration);
    }
  }

  void _hidecontrols() {
    if (mounted) {
      setState(
        () {
          if (hidecontrols == 0) {
            hidecontrols = 1;
          } else {
            hidecontrols = 0;
          }
        },
      );
    }
  }

  Future _onExitFullScreen() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    if (mounted) {
      setState(() {
        isFullscreen = false;
      });
    }
    widget.fullScreen(false);
  }

  Future _onEnterFullScreen() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    if (mounted) {
      setState(() {
        isFullscreen = true;
      });
    }
    widget.fullScreen(true);
  }

  void _toggleFullScreen() {
    if (isFullscreen == false) {
      log("onEnter fullscreen");
      _onEnterFullScreen();
    } else {
      log("onExit fullscreen");
      _onExitFullScreen();
      if (mounted) {
        setState(() {
          scale = 1;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (hidecontrols > 0) {
      if (!vlcPlayerCtrl.value.isInitialized) {
        log("Player is not initialized yet");
        return;
      }

      log("Current Player State: ${vlcPlayerCtrl.value.playingState}");

      switch (vlcPlayerCtrl.value.playingState) {
        case PlayingState.playing:
          log("Pausing the player...");
          if (widget.isLive) {
          } else {
            await vlcPlayerCtrl.pause().then((val) {
              log("paused successfully");
              isPlaying.value = false;
            }).catchError((e) {
              log("Error: $e");
            });
          }
          break;

        case PlayingState.paused:
          log("Resuming play...");
          if (widget.isLive) {
          } else {
            vlcPlayerCtrl.play().whenComplete(() {
              log("playing started");
              isPlaying.value = true;
            });
          }
          break;

        case PlayingState.stopped:
          isPlaying.value = null;
          log("Player is stopped, attempting to play...");
          try {
            vlcPlayerCtrl.stop(); // Ensure it's fully stopped
            await vlcPlayerCtrl
                .setMediaFromNetwork(
              vlcPlayerCtrl.dataSource,
            )
                .then((_) async {
              await vlcPlayerCtrl.addAudioFromNetwork(
                currentAudioStream.url.toString(),
                isSelected: true,
              );
            }); // Reload the media from the URL
          } catch (e) {
            log("Error seeking or playing: $e");
          }
          break;

        case PlayingState.buffering:
          isPlaying.value = null;
          log("Buffering... Please wait.");
          break;

        case PlayingState.error:
          isPlaying.value = null;
          log("Error in playback. Checking if we can retry...");
          break;

        default:
          log("Unknown player state: ${vlcPlayerCtrl.value.playingState}");
      }
    }
  }

  @override
  void dispose() {
    log("disposed......vlcplayerCtrl=>$isvlcPlayerCtrlinitialized");
    if (isvlcPlayerCtrlinitialized) {
      vlcPlayerCtrl.removeListener(() {});
      vlcPlayerCtrl.dispose();
      _controllerLeftseek.dispose();
      _controllerRightseek.dispose();
      isPlaying.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          if (isFullscreen == true) {
            _toggleFullScreen();
            return false;
          }

          return true;
        },
        child: Container(
          child: error == null
              ? isLoading == true
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: widget.placeholder ??
                          Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                    )
                  : GestureDetector(
                      onTap: _hidecontrols,
                      child: AspectRatio(
                        aspectRatio: isFullscreen
                            ? MediaQuery.of(context).size.aspectRatio
                            : 16 / 9,
                        child: GestureDetector(
                          onScaleStart: (ScaleStartDetails details) {
                            if (isFullscreen) {
                              previousScale = scale;
                            }
                          },
                          onScaleUpdate: (ScaleUpdateDetails details) {
                            if (isFullscreen && mounted) {
                              setState(() {
                                scale = (previousScale * details.scale)
                                    .clamp(1.0, 1.3); // Set zoom limits
                                log("scale:$scale");
                              });
                            }
                          },
                          onScaleEnd: (ScaleEndDetails details) {
                            if (isFullscreen) {
                              previousScale = 1.0;
                            }
                          },
                          child: Container(
                            color: Colors.black,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform(
                                  transform: Matrix4.identity()
                                    ..scale(scale, 1.0),
                                  alignment: Alignment.center,
                                  child: VlcPlayer(
                                    controller: vlcPlayerCtrl,
                                    aspectRatio: 16 / 9,
                                  ),
                                ),
                                if (hidecontrols > 0)
                                  AnimatedOpacity(
                                    opacity: 0.7,
                                    duration: const Duration(milliseconds: 700),
                                    child: Container(
                                      color: const Color.fromARGB(144, 0, 0,
                                          0), // Semi-transparent grey
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:
                                          1, // The first container on the left
                                      child: GestureDetector(
                                        onDoubleTap: _handleLeftTap,
                                        child: Container(
                                          color: Colors.transparent,
                                          height: double.infinity,
                                          width: double.infinity / 2,
                                          child: AnimatedBuilder(
                                            animation: _LeftAnimation,
                                            builder: (context, child) {
                                              return Opacity(
                                                opacity: _LeftAnimation.value,
                                                child: CustomPaint(
                                                  painter: _LeftCurve(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: hidecontrols,
                                      child: VLCPlayerControls(
                                        vlcPlayerCtrl: vlcPlayerCtrl,
                                        isPlaying: isPlaying,
                                        fetching: fetching,
                                        hidecontrols: hidecontrols,
                                        togglePlayPause: _togglePlayPause,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onDoubleTap: _handleRightTap,
                                        child: Container(
                                          color: Colors.transparent,
                                          height: double.infinity,
                                          width: double.infinity / 2,
                                          child: AnimatedBuilder(
                                            animation: _RightAnimation,
                                            builder: (context, child) {
                                              return Opacity(
                                                opacity: _RightAnimation.value,
                                                child: CustomPaint(
                                                  painter: _RightCurve(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Opacity(
                                    opacity: hidecontrols,
                                    child: _buildControls(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        '$error',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildControls() {
    if (hidecontrols > 0) {
      String formatDuration(Duration duration) {
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final hours = duration.inHours;
        final minutes = twoDigits(duration.inMinutes.remainder(60));
        final seconds = twoDigits(duration.inSeconds.remainder(60));
        return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
      }

      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isFullscreen == true
                ? const SizedBox(
                    width: 30,
                    height: 20,
                  )
                : const SizedBox(),
            !widget.isLive
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, right: 5, bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const Text(
                          "Live",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
            widget.isLive
                ? Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 3),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8),
                        ),
                        child: Slider(
                          min: 0,
                          max: backupPosition.inMilliseconds.toDouble(),
                          value: backupPosition.inMilliseconds.toDouble(),
                          onChanged: (values) {
                            if (mounted) {
                              setState(() {
                                backupPosition =
                                    Duration(milliseconds: values.toInt());
                                log("backupPosition: $backupPosition");
                              });
                            }
                          },
                          activeColor: Colors.red,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(trackHeight: 2),
                      child: Slider(
                        value: totalDuration.inSeconds > 0
                            ? backupPosition.inMilliseconds
                                .toDouble() // Current position
                            : 0.0,
                        min: 0.0,
                        max: totalDuration.inMilliseconds > 0
                            ? totalDuration.inMilliseconds
                                .toDouble() // Total duration
                            : 1.0,
                        onChanged: (newValue) async {
                          if (mounted) {
                            setState(() {
                              backupPosition =
                                  Duration(milliseconds: newValue.toInt());
                              log("backupPosition: $backupPosition");
                            });
                          }

                          if (vlcPlayerCtrl.value.playingState ==
                              PlayingState.stopped) {
                            try {
                              await vlcPlayerCtrl
                                  .setMediaFromNetwork(
                                      currentStream.url.toString(),
                                      hwAcc: HwAcc.full,
                                      autoPlay: true)
                                  .then((_) async {
                                await vlcPlayerCtrl
                                    .seekTo(backupPosition)
                                    .then((_) {
                                  vlcPlayerCtrl.addAudioFromNetwork(
                                      currentAudioStream.url.toString());
                                });
                              });
                            } catch (e) {
                              log("Error while loading media and seeking: $e");
                            }
                          } else {
                            // If the player is not stopped, just seek to the position if totalDuration is greater than 0
                            if (totalDuration.inMilliseconds > 0) {
                              await vlcPlayerCtrl.seekTo(backupPosition);
                            }
                          }
                        },
                        onChangeEnd: (value) async {},
                        activeColor: Colors.purple,
                      ),
                    ),
                  ),
            if (!widget.isLive)
              IconButton(
                onPressed: _showmenu,
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            IconButton(
              onPressed: _toggleFullScreen,
              icon: isFullscreen
                  ? const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _showmenu() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(119, 72, 70, 70),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      width: 60,
                      height: 7,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: _showQuality,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.tune,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Quality',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                currentStream.qualityLabel,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: _playBackspeedsheet,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Playback speed',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${vlcPlayerCtrl.value.playbackSpeed}x",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _playBackspeedsheet() {
    List<String> speed = ['0.5', '1', '1.5', '2'];
    Navigator.of(context).pop();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(119, 72, 70, 70),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 60,
                  height: 7,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current speed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${vlcPlayerCtrl.value.playbackSpeed}x',
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onTap: () => playbackspeed(double.parse(speed[index])),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${speed[index]}x",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (vlcPlayerCtrl.value.playbackSpeed ==
                                double.parse(speed[index]))
                              Container(
                                height: 8,
                                width: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext ctx, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: speed.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void playbackspeed(double value) {
    vlcPlayerCtrl.setPlaybackSpeed(value);
    Navigator.of(context).pop();
  }

  void _showQuality() {
    Navigator.of(context).pop();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(119, 72, 70, 70),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 60,
                  height: 7,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quality of current video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentStream.qualityLabel,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onTap: () {
                        _changeQuality(stream: videoOnlyStreams[index]);
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              videoOnlyStreams[index].qualityLabel,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (currentStream.qualityLabel ==
                                videoOnlyStreams[index].qualityLabel)
                              Container(
                                height: 8,
                                width: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext ctx, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: videoOnlyStreams.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PlayPause extends StatelessWidget {
  final ValueNotifier<bool?> isPlaying;
  final Function() togglePlay;

  const PlayPause({
    super.key,
    required this.isPlaying,
    required this.togglePlay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1, milliseconds: 500),
      child: IconButton(
        icon: ValueListenableBuilder(
          valueListenable: isPlaying,
          builder: (context, value, child) => Icon(
            value == null
                ? Icons.replay
                : value == false
                    ? Icons.play_arrow
                    : Icons.pause,
            color: Colors.white,
            size: 50,
          ),
        ),
        onPressed: togglePlay,
      ),
    );
  }
}

class VLCPlayerControls extends StatelessWidget {
  final VlcPlayerController vlcPlayerCtrl;
  final ValueNotifier<bool?> isPlaying;
  final bool fetching;
  final double hidecontrols;
  final VoidCallback togglePlayPause;

  const VLCPlayerControls({
    super.key,
    required this.vlcPlayerCtrl,
    required this.isPlaying,
    required this.fetching,
    required this.hidecontrols,
    required this.togglePlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return vlcPlayerCtrl.value.playingState == PlayingState.ended
        ? IconButton(
            onPressed: togglePlayPause,
            icon: const Icon(
              Icons.replay,
              size: 50,
              color: Colors.white,
            ),
          )
        : vlcPlayerCtrl.value.playingState == PlayingState.buffering || fetching
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : PlayPause(
                isPlaying: isPlaying,
                togglePlay: () {
                  if (hidecontrols > 0) {
                    togglePlayPause();
                  } else {
                    // Add logic for invalid state if needed
                    debugPrint("invalid");
                  }
                },
              );
  }
}

class _LeftCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(99, 86, 84, 84) // Path color
      ..style = PaintingStyle.fill; // Fills the path

    final path = Path();

    // Set xOffset within the width of the box (200 in this case)
    double xOffset = (size.width) / 1.5;

    // Start at the top, slightly offset from (0, 0)
    path.moveTo(xOffset, 0);

    // Draw a curve to the corresponding point at the bottom (same xOffset)
    path.quadraticBezierTo(
      size.width * 0.99, // Control point x (adjust this for bulge)
      size.height / 2, // Control point y (middle of the container)
      xOffset, // End point x (same xOffset at bottom)
      size.height, // End point y (bottom of the container)
    );

    // Close the path by drawing lines to the edges
    path.lineTo(0, size.height); // Connect to bottom-left corner
    path.lineTo(0, 0); // Connect back to top-left corner
    path.close(); // Close the path to form a shape

    // Draw the path on the canvas
    canvas.drawPath(path, paint);

    // Text to be displayed
    const textSpan = TextSpan(
      text: '-10 sec',
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
    );

    // Configure the text painter
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();

    // Calculate the position to center the text inside the path
    final offset = Offset(
      xOffset / 2 - textPainter.width / 2, // Center horizontally
      size.height / 2 - textPainter.height / 2, // Center vertically
    );

    // Paint the text on the canvas
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint if nothing changes
  }
}

class _RightCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(99, 86, 84, 84) // Path color
      ..style = PaintingStyle.fill; // Fills the path

    final path = Path();

    // Set xOffset within the width of the box (200 in this case)
    double xOffset = size.width / 2.9;

    // Start at the top right corner
    path.moveTo(xOffset, 0);

    // Draw a curve to the corresponding point at the bottom-left
    path.quadraticBezierTo(
      size.width * 0.1, // Control point x (adjust this for bulge)
      size.height / 2, // Control point y (middle of the container)
      xOffset, // End point x (slightly offset from left)
      size.height, // End point y (bottom of the container)
    );

    // Close the path by drawing lines to the edges
    path.lineTo(size.width, size.height); // Connect to bottom-right corner
    path.lineTo(size.width, 0); // Connect back to top-right corner
    path.close(); // Close the path to form a shape

    // Draw the path on the canvas
    canvas.drawPath(path, paint);

    // Text to be displayed
    const textSpan = TextSpan(
      text: '+10 sec',
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
    );

    // Configure the text painter
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();

    // Calculate the position to center the text inside the path
    final offset = Offset(
      (size.width / 2 - textPainter.width / 2) + 20, // Center horizontally
      size.height / 2 - textPainter.height / 2, // Center vertically
    );

    // Paint the text on the canvas
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint if nothing changes
  }
}
