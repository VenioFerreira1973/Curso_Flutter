import 'package:flutter/material.dart';
import './questao.dart';
import './resposta.dart';

class Questionario extends StatelessWidget {
  final int perguntaSelecionada;
  final void Function(int) quandoResponder;
  final List<Map<String, Object>> perguntas;

  Questionario({
    required this.perguntaSelecionada,
    required this.quandoResponder,
    required this.perguntas,
  });

  bool get temPerguntaSelecionada {
    return perguntaSelecionada < perguntas.length;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>>? respostas = (temPerguntaSelecionada
            ? perguntas[perguntaSelecionada]['respostas']
                as List<Map<String, Object>>
            : null)!
        .cast<Map<String, Object>>();

    return Column(
      children: <Widget>[
        Questao(perguntas[perguntaSelecionada]['texto'].toString()),
        ...respostas.map((resp) {
          return Resposta(
            resp['texto'].toString(),
            () => quandoResponder(int.parse(resp['pontuacao'].toString())),
          );
        }).toList(),
      ],
    );
  }
}
