import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:async';


void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChessClock(),
    );
  }
}

class ChessClock extends StatefulWidget {
   @override
  _ChessClockState createState() => _ChessClockState();
}

class _ChessClockState extends State<ChessClock> {
  static AudioCache player = AudioCache();
  List<int> _counter = [0, 0];
  List<int> _time = [0, 0];
  bool _firstPlayer = true;
  bool _play = false;

  Widget _w(bool firstPlayer, int _player){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.black54,
                blurRadius: 5
              )],
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              color: firstPlayer & _play ? Color.fromRGBO(231, 143, 53, 1) : Color.fromRGBO(81, 78, 73, 1)
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 40.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Player $_player',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Spacer(),
                      Text(
                        'Moves: ${_counter[_player-1]}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      CustomDuration(_time[_player-1]).toString(),
                      style: TextStyle(color: firstPlayer & _play ? Colors.white : Colors.black, fontSize: 70.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                if(!_play) return;
                if(firstPlayer) {
                  player.play('click.wav');
                  _counter[_player-1]++;
                  _firstPlayer = !_firstPlayer;
                }
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(50, 46, 43, 1),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: RotatedBox(
                quarterTurns: 2,
                child: _w(_firstPlayer, 1),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    _play = !_play;
                    if(_play) Timer.periodic(Duration(seconds: 1), (Timer timer){
                      _time[(_firstPlayer ? 0 : 1)]++;
                      setState(() {});
                      if(!_play) timer.cancel();
                    });
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(_play ? Icons.pause : Icons.play_arrow, size: 50.0, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _time = [0, 0];
                    _counter = [0, 0];
                    _firstPlayer = true;
                    _play = false;
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.replay, size: 44.0, color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _w(!_firstPlayer, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDuration{
  Duration _duration;
  int _seconds;
  CustomDuration(this._seconds){_duration = Duration(seconds: _seconds);}
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
  String toString() {
    String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
    return "${_duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
