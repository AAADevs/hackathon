import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
//import 'package:video_trimmer/src/trim_editor.dart';

class Video_Player extends StatefulWidget {
  final Color borderColor;

  final double borderWidth;

  final EdgeInsets padding;

  final video;
  final String videotype;

  Video_Player({
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.video,
    this.videotype,
  });

  @override
  _Video_PlayerState createState() => _Video_PlayerState();
}

class _Video_PlayerState extends State<Video_Player> {
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  bool volume = true;

  @override
  void initState() {
    this.initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController2.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  Future<void> initializePlayer() async {
    if (widget.videotype == "video/mp4") {
      _videoPlayerController2 = new VideoPlayerController.network(widget.video);
    } else if (widget.videotype == null) {
      _videoPlayerController2 = new VideoPlayerController.file(widget.video);
    }

    await _videoPlayerController2.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
      allowMuting: true,
      showControls: true,
      allowFullScreen: true,
      showControlsOnInitialize: false,

      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.black,
        bufferedColor: Colors.lightGreen,
      ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      autoInitialize: true,
    );
    setState(() {
      //ChewieController.of(context).allowMutin
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          //_chewieController.toggleFullScreen();
          //_chewieController.enterFullScreen();
          // ChewieController(allowMuting: true);
          // _chewieController = _chewieController.videoPlayerController.;
        });
      },
      onLongPress: () {
        setState(() {
          _chewieController.toggleFullScreen();
        });
      },
      child: Center(
        child: Padding(
          padding: widget.padding,
          child: AspectRatio(
            aspectRatio: _videoPlayerController2.value.aspectRatio,
            child: Center(
              child: _chewieController != null &&
                      _chewieController.videoPlayerController.value.initialized
                  ? Chewie(
                      controller: _chewieController,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
