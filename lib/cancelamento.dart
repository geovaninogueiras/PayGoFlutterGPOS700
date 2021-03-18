import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:paygofluttergpos700/widget_button.dart';

import 'package:intl/intl.dart';

class Cancelamento extends StatefulWidget {
  final String nsu;
  final String codigoAutorizacao;
  final String dataOperacao;
  final String valorOperacao;

  const Cancelamento(
      {Key key,
      @required this.nsu,
      @required this.codigoAutorizacao,
      @required this.dataOperacao,
      @required this.valorOperacao})
      : super(key: key);

  @override
  _CancelamentoState createState() => _CancelamentoState();
}

class _CancelamentoState extends State<Cancelamento> {
  var nsuController = TextEditingController();

  var codigoAutorizacaoController = TextEditingController();

  var dataOperacaoController = TextEditingController();

  // var valorOperacaoController = TextEditingController();

  var valorOperacaoController = MoneyMaskedTextController(
      leftSymbol: "",
      decimalSeparator: '.',
      thousandSeparator: ',',
      initialValue: 0);

  @override
  void initState() {
    super.initState();
    nsuController.text = widget.nsu;
    codigoAutorizacaoController.text = widget.codigoAutorizacao;
    dataOperacaoController.text = widget.dataOperacao;
    valorOperacaoController.text = widget.valorOperacao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    "Insira seus dados de cancelamento",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                obscureText: false,
                controller: nsuController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  //labelText: title ,  // you can change this with the top text  like you want
                  hintText: "Informe o NSU da transação",
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: false,
                controller: codigoAutorizacaoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    //labelText: title ,  // you can change this with the top text  like you want
                    hintText: "Código de autorização",
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: false,
                controller: dataOperacaoController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [MaskTextInputFormatter(mask: '####-##-##')],
                decoration: InputDecoration(
                    //labelText: title ,  // you can change this with the top text  like you want
                    hintText: "Data da transação",
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: false,
                controller: valorOperacaoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    //labelText: title ,  // you can change this with the top text  like you want
                    hintText: "Valor da transação",
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidGetButton(
                        text: "Cancelar",
                        callback: () {
                          // operacao(Paygogpos700.VENDA);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidGetButton(
                        text: "Confirmar",
                        callback: () {
                          if (nsuController.text != '') {
                            final Map<String, dynamic> data =
                                new Map<String, dynamic>();
                            data['nsu'] = nsuController.text;
                            data['codigoAutorizacao'] =
                                codigoAutorizacaoController.text;
                            data['dataOperacao'] = dataOperacaoController.text;
                            data['valorOperacao'] =
                                valorOperacaoController.text;
                            Navigator.pop(context, data);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
