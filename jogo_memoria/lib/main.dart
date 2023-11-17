import 'package:flutter/material.dart';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(home: JogoDesenho()));
}

class JogoDesenho extends StatefulWidget {
  @override
  _JogoDesenhoState createState() => _JogoDesenhoState();
}

class _JogoDesenhoState extends State<JogoDesenho> {
  AudioPlayer? _player;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> _playGanhou() async {
    try {
      _player?.dispose();
      final player = _player = AudioPlayer();
      await player.play(AssetSource('sons/ganhou.wav'));
    } catch (e) {
      null;
    }
  }

  Future<void> _playVitoria() async {
    try {
      _player?.dispose();
      final player = _player = AudioPlayer();
      await player.play(AssetSource('sons/vitoria.wav'));
    } catch (e) {
      null;
    }
  }

  List<Image?> gifs = [];

  List<Image?> fotos = [];

  List<String> numeros = List.generate(16, (index) => (index + 1).toString());
  List<bool> isClicado = List.generate(16, (index) => false);

  int aux1 = 0;
  int aux2 = 0;
  int contaBotao = 0;
  int contaTotal = 0;
  int primeiro = 0;
  int segundo = 0;
  int vitoria = 0;
  int resp = 0;

  @override
  void initState() {
    super.initState();
    int conta = 0;

    for (int i = 0; i < 16; i++) {
      fotos.add(null);
    }

    for (int i = 0; i < 8; i++) {
      gifs.add(null);
    }

    for (int i = 0; i < 8; i++) {
      gifs[i] = Image.asset('assets/images/gif$i.png');
    }

    while (conta < 16) {
      aux1 = Random().nextInt(16);
      aux2 = Random().nextInt(16);

      if (aux1 != aux2) {
        if (fotos[aux1] == null && fotos[aux2] == null) {
          fotos[aux1] = gifs[(conta ~/ 2).toInt()];
          fotos[aux2] = gifs[(conta ~/ 2).toInt()];
          isClicado[aux1] = false;
          isClicado[aux2] = false;
          conta = conta + 2;
        }
      }
    }
    setState(() {});
  }

  String _classificacao() {
    if (contaTotal < 30) {
      return 'Are you smart!';
    } else if (contaTotal >= 30 && contaTotal < 45) {
      return 'Are you medium!';
    } else {
      return 'Are you dumb!';
    }
  }

  void handleButtonClick(int index) {
    contaBotao++;
    contaTotal++;

    if (contaBotao == 1) {
      primeiro = index;
      isClicado[index] = true;
    } else if (contaBotao == 2) {
      isClicado[index] = true;
      segundo = index;

      if (fotos[segundo] == fotos[primeiro] && primeiro != segundo) {
        vitoria++;
        contaBotao = 0;
        _playGanhou();

        if (vitoria == 8) {
          _playVitoria();
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                backgroundColor: Colors.yellow,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'You win $contaTotal taps!!! \n ${_classificacao()}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Agbalumo',
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } else if (primeiro == index) {
        contaBotao--;
      }
    } else if (contaBotao == 3) {
      contaBotao = contaBotao - 2;
      isClicado[segundo] = false;
      isClicado[primeiro] = false;
      primeiro = index;
      isClicado[index] = true;
    }
    setState(() {});
  }

  _resetGame() {
    vitoria = 0;
    contaBotao = 0;
    contaTotal = 0;
    int contaReset = 0;

    for (int i = 0; i < 16; i++) {
      fotos[i] = null;
    }

    while (contaReset < 16) {
      aux1 = Random().nextInt(16);
      aux2 = Random().nextInt(16);

      if (aux1 != aux2) {
        if (fotos[aux1] == null && fotos[aux2] == null) {
          fotos[aux1] = gifs[(contaReset ~/ 2).toInt()];
          fotos[aux2] = gifs[(contaReset ~/ 2).toInt()];
          isClicado[aux1] = false;
          isClicado[aux2] = false;
          contaReset = contaReset + 2;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Memory Fruits®',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Agbalumo',
              color: Colors.yellowAccent,
            ),
          ),
        ),
        //Image.asset('assets/images/grape.png'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: numeros.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  !isClicado[index] ? handleButtonClick(index) : null;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: isClicado[index]
                        ? fotos[index]
                        : Text(
                            numeros[index],
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.add, size: 40, color: Colors.yellowAccent),
          onPressed: () => _resetGame()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
