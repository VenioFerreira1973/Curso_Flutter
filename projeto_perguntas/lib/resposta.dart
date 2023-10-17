import 'package:flutter/material.dart';

class Resposta extends StatelessWidget {
  final String texto;
  final void Function() quandoSelecionado;

  Resposta(this.texto, this.quandoSelecionado);

  Color corDaLetra(String texto) {
    if (texto == 'Verde') {
      return Colors.green;
    } else if (texto == 'Grena') {
      return Colors.red.shade900;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(Colors.orange.shade900),
        ),
        onPressed: quandoSelecionado,
        child: Text(texto, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
