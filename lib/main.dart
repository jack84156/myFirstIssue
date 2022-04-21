import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyAudio());
}

class MyAudio extends StatefulWidget {
  const MyAudio({Key? key}) : super(key: key);

  @override
  State<MyAudio> createState() => _MyAudioState();
}

class _MyAudioState extends State<MyAudio> {

  AudioPlayer? audioPlayer;



  @override
  void dispose() {
    audioPlayer!.dispose();
    streamScriptionForAudioPosition!.cancel();
    streamScriptionForAudioTotalDuration!.cancel();
    super.dispose();
  }


  @override
  void initState() {
    intiz();
    super.initState();
  }


  Future intiz()async{
    audioPlayer = AudioPlayer();
    position();
    totall();
  }


  StreamSubscription? streamScriptionForAudioPosition ;
  Duration? audioPosition;
  position(){
    streamScriptionForAudioPosition=  audioPlayer!.positionStream.listen((position) {
      audioPosition = position;
      setState(() {});
    });
  }

  StreamSubscription? streamScriptionForAudioTotalDuration ;
  Duration? totalAudioDuration;
  totall(){
    streamScriptionForAudioTotalDuration=  audioPlayer!.durationStream.listen((totalDuration) {
      totalAudioDuration = totalDuration;
      setState(() {});
    });
  }



  Widget handleStateIcon(){


    if (audioPlayer!.playerState.processingState == ProcessingState.loading) {

      return const CircularProgressIndicator(color: Colors.black,);

    }
    else
    if (!audioPlayer!.playerState.playing ) {
      return const Icon(Icons.play_arrow,color: Colors.black,);
    }

    else if (audioPlayer!.playerState.playing ) {
      return const Icon(Icons.pause,color: Colors.black,);
    }

    return  Container();

  }


  Future myOnpressedFunction()async{

    // this is one of my acc url list from Firsbase Storage that not seek normally
// await audioPlayer!.setUrl('https://firebasestorage.googleapis.com/v0/b/whosaround-68ccf.appspot.com/o/Audio%20users%20records%20chat%2F13891781-d8b1-4fec-9426-25bd6ca02d16?alt=media&token=57efc212-fec9-47b2-8623-ab60776d2a08');

    // this is seek normally
    await audioPlayer!.setUrl('https://archive.org/download/IGM-V7/IGM%20-%20Vol.%207/25%20Diablo%20-%20Tristram%20%28Blizzard%29.mp3');


    if (!audioPlayer!.playerState.playing ) {
      await audioPlayer!.play();
      setState(() {});
    }
    if (audioPlayer!.playerState.playing) {
      await audioPlayer!.pause();
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                ProgressBar(
                  progressBarColor: Colors.yellowAccent,
                  progress:  audioPosition?? Duration.zero,
                  total: totalAudioDuration??Duration.zero,
                  onSeek: (u){
                    audioPlayer!.seek(u);
                  },
                  timeLabelLocation: TimeLabelLocation.above ,
                  timeLabelTextStyle: const TextStyle(color: Colors.white,fontSize: 10),
                  timeLabelPadding: 5,
                ),

                StreamBuilder(
                    stream: audioPlayer!.playerStateStream,
                    builder: (context, snapshot) {
                      return IconButton(
                        onPressed: (){
                          myOnpressedFunction();
                        },
                        icon: handleStateIcon(),
                      );
                    }
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



