import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:paygofluttergpos700/cancelamento.dart';
import 'package:paygofluttergpos700/gpos700impressao.dart';
import 'package:paygofluttergpos700/paygo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GertecOne Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageTef(),
    );
  }
}

class PageTef extends StatefulWidget {
  @override
  _PageTefState createState() => _PageTefState();
}

class _PageTefState extends State<PageTef> {
  // TefService tefService = new TefService();

  Paygogpos700 paygogpos700 = new Paygogpos700();

  //Mascara que pegar o valor do input e transforma em um tipo Money
  final precoVenda = MoneyMaskedTextController(
      leftSymbol: "",
      decimalSeparator: '.',
      thousandSeparator: ',',
      initialValue: 20);

  final numParcelas =
      TextEditingController(text: "1"); //Text edit da quantidade de parcelas

  bool confirmacaoManual = false; //armazena se a impressao vai ser realizada
  bool viaCompleta = false; //armazena se a impressao vai ser realizada
  bool viaLojaCliente = false; //armazena se a impressao vai ser realizada
  bool interfaceAlternativa = false; //armazena se a impressao vai ser realizada

  String tipoPagamentoSelecionado =
      "Não Definido"; //armazena o tipo de pagamento escolhido

  String tipoParcelamentoSelecionado =
      "Não Definido"; //armazena o tipo de pagamento escolhido

  String adquirenteEscolhido = "DESCONHECIDO";

  String nsuRetornado = "";
  String codigoAutorizacaoRetornado = "";
  String dataOperacaoRetornado = "";
  String valorOperacaoRetornado = "0.00";

  @override
  void initState() {
    super.initState();
  }

  Future<void> imprimeCupom(String cupom) async {
    Gpos700impressao.setConfiguracaoImpressora(
        fonte: Gpos700impressao.FONTE_PADRAO_NORMAL,
        alinhamento: Gpos700impressao.IMPRESSORA_ALINHADO_CENTER,
        tamanho: 20,
        offSet: 0,
        iHeight: 700,
        iWidth: 100,
        lineSpace: 1,
        negrito: true,
        italico: false,
        sublinhado: false,
        avancaLinhas: 0);
    Gpos700impressao.getStatusImpressora();
    Gpos700impressao.setImprimeTexto(texto: cupom);
    Gpos700impressao.setAvancaLinha(linhas: 150);
    Gpos700impressao.setImpressoraOutput();
  }

  Future<void> operacao(String op) async {
    String valorOperacao = precoVenda.text;
    String modadelidaPagamento;
    String tipoCartao;
    String tipoFinanciamento = '';
    valorOperacao = valorOperacao.replaceAll('.', "");
    valorOperacao = valorOperacao.replaceAll(',', "");

    switch (tipoPagamentoSelecionado) {
      case 'Não Definido':
        modadelidaPagamento = Paygogpos700.PAGAMENTO_CARTAO;
        tipoCartao = Paygogpos700.CARTAO_DESCONHECIDO;
        break;
      case 'Crédito':
        modadelidaPagamento = Paygogpos700.PAGAMENTO_CARTAO;
        tipoCartao = Paygogpos700.CARTAO_CREDITO;
        break;

      case 'Débito':
        modadelidaPagamento = Paygogpos700.PAGAMENTO_CARTAO;
        tipoCartao = Paygogpos700.CARTAO_DEBITO;
        break;
      default:
        modadelidaPagamento = Paygogpos700.PAGAMENTO_CARTEIRA_VIRTUAL;
        tipoCartao = Paygogpos700.CARTAO_DESCONHECIDO;
        break;
    }

    switch (tipoParcelamentoSelecionado) {
      case 'Não Definido':
        tipoFinanciamento = Paygogpos700.FINANCIAMENTO_NAO_DEFINIDO;
        break;
      case 'A vista':
        tipoFinanciamento = Paygogpos700.A_VISTA;
        break;
      case 'Emissor':
        tipoFinanciamento = Paygogpos700.PARCELADO_EMISSOR;
        break;
      default:
        tipoFinanciamento = Paygogpos700.PARCELADO_ESTABELECIMENTO;
        break;
    }

    Paygogpos700.efetuaOperacao(
      numeroOperacao: new Random().nextInt(9999999).toString(),
      empresaAutomacao: 'Gertec do Brasil',
      nomeAutomacao: 'Automação Demo',
      versaoAutomacao: '1.0.0',
      operacao: op,
      modalidadePagamento: modadelidaPagamento,
      tipoCartao: tipoCartao,
      tipoFinanciamento: tipoFinanciamento,
      valorOperacao: valorOperacao,
      parcelas: numParcelas.text,
      adquirente: adquirenteEscolhido == 'DESCONHECIDO'
          ? 'PROVEDOR DESCONHECIDO'
          : adquirenteEscolhido,
      nsu: nsuRetornado,
      codigoAutorizacao: codigoAutorizacaoRetornado,
      dataOperacao: dataOperacaoRetornado,
      confirmacaoManual: confirmacaoManual,
      viaLojaCliente: viaLojaCliente,
      viaCompleta: viaCompleta,
      interfaceAlternativa: interfaceAlternativa,
      suportaTroco: true,
      suportaDesconto: true,
      // fileIconDestino: File('assets/cash_payment.png').path,
      // fileFonteDestino: File('assets/vectra.otf').path,
      informaCorFonte: '#000000',
      informaCorFonteTeclado: '#000000',
      informaCorFundoCaixaEdicao: '#FFFFFF',
      informaCorFundoTela: '#F4F4F4',
      informaCorFundoTeclado: '#F4F4F4',
      informaCorFundoToolbar: '#2F67F4',
      informaCorTextoCaixaEdicao: '#000000',
      informaCorTeclaPressionadaTeclado: '#e1e1e1',
      informaCorTeclaLiberadaTeclado: '#dedede',
      informaCorSeparadorMenu: '#2F67F4',
    ).then((value) async {
      print('Sucesso: ' + value);
      bool result = true;
      paygogpos700 = new Paygogpos700.fromJson(json.decode(value.toString()));

      if (paygogpos700.result == 0) {
        if (paygogpos700.informacaoConfirmacao) {
          // Apresentar Dialog para confirmar a operação
          if (confirmacaoManual) {
            result = await dialogConfirmaOperacao();
          } else {
            Paygogpos700.confirmaOperacaoAutomatico();
          }
        } else if (paygogpos700.existeTransacaoPendente) {
          valorOperacaoRetornado = precoVenda.text;
          nsuRetornado = paygogpos700.nsu;
          codigoAutorizacaoRetornado = paygogpos700.codigoAutorizacao;
          dataOperacaoRetornado = paygogpos700.dataOperacao;
        } else {
          // Faz a confirmação sem perguntar nada.
          print('Foi retornado um valor que não precisa validar.');
        }

        if (result) {
          valorOperacaoRetornado = precoVenda.text;
          nsuRetornado = paygogpos700.nsu;
          codigoAutorizacaoRetornado = paygogpos700.codigoAutorizacao;
          dataOperacaoRetornado = paygogpos700.dataOperacao;

          if (viaCompleta) {
            result = await dialogPrintComprovante(
                'Comprovante Full', paygogpos700.viaCupomFull);
          }
          if (viaLojaCliente) {
            result = await dialogPrintComprovante(
                'Via do Estabelecimento', paygogpos700.viaEstavelecimento);
            result = await dialogPrintComprovante(
                'Via do Cliente', paygogpos700.viaCliente);
          }

          if (op == Paygogpos700.VENDA || op == Paygogpos700.CANCELAMENTO) {
            dialogDadosOperacao();
          }
        }

        // Existe uma operação pendente de confirmação.
      } else if (paygogpos700.existeTransacaoPendente) {
        // Se chegar nesse ponto aconteceu um erro durante a operação
        print('Nesse ponto existe uma operação pendente.');
        await dialogExisteTransacoesPendente();
      } else {
        print('Nesse ponto que dizer que aconteceu um erro.');
        dialogErroOperacao();
        return;
      }
    }).onError((error, stackTrace) {
      print('Erro: ' + error.toString());
    });
  }

  Future<bool> dialogConfirmaOperacao() {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text("Confirmação manual"),
            actions: [
              FlatButton(
                child: Text("Confirme"),
                onPressed: () {
                  Paygogpos700.confirmaOperacaoManual();
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Paygogpos700.desfazOperacaoManual();
                  Navigator.of(context).pop(false);
                },
              ),
            ],
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Deseja confirmar a operação de forma manual?'),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Confirmado Operação $val');
      return val;
    });
  }

  Future<bool> dialogPrintComprovante(String titulo, String comprovante) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text(titulo),
            actions: [
              FlatButton(
                child: Text("Sim"),
                onPressed: () async {
                  print('Clicou na impressão do comprovante');
                  await imprimeCupom(comprovante);
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  print('Clicou na NÃO impressão do comprovante');
                  Navigator.of(context).pop(false);
                },
              ),
            ],
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Deseja imprimir $titulo?'),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Impressão do comprovante fecahdo');
      return val;
    });
  }

  Future<bool> dialogExisteTransacoesPendente() {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text("Transação Pendente"),
            actions: [
              FlatButton(
                child: Text("Confirme"),
                onPressed: () {
                  Paygogpos700.confirmaOperacaoPendenteManual();
                  // Navigator.pop(context);
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Paygogpos700.desfazOperacaoPendente();
                  Navigator.of(context).pop(false);
                },
              ),
            ],
            content: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Deseja confirmar a transação que esta PENDENTE?'),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Transação Pendente');
      return val;
    });
  }

  void dialogDadosOperacao() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 20,
          child: AlertDialog(
            title: Text(paygogpos700.mensagemRetorno),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Text('ID do Cartão: ${paygogpos700.idcartao}'),
                Text(
                    'Nome Portador Cartao: ${paygogpos700.nomePortadorCartao}'),
                Text('Nome Cartao Padrao: ${paygogpos700.nomeCartaoPadrao}'),
                Text(
                    'Nome Estabelecimento: ${paygogpos700.nomeEstabelecimento}'),
                Text('Pan Mascar Padrao: ${paygogpos700.panMascarPadrao}'),
                Text('Pan Mascarado: ${paygogpos700.panMascarado}'),
                Text(
                    'Identificador Confirmação Transação: ${paygogpos700.identificadorConfirmacaoTransacao}'),
                Text('Nsu Local Original: ${paygogpos700.nsuLocalOriginal}'),
                Text('Nsu Local: ${paygogpos700.nsuLocal}'),
                Text('Nsu Host: ${paygogpos700.nsuHost}'),
                Text('Nome Cartao: ${paygogpos700.nomeCartao}'),
                Text('Nome Provedor: ${paygogpos700.nomeProvedor}'),
                Text(
                    'Modo Verificação Senha: ${paygogpos700.modoVerificacaoSenha}'),
                Text('Codigo Autorização: ${paygogpos700.codigoAutorizacao}'),
                Text(
                    'Codigo Autorização Original: ${paygogpos700.codigoAutorizacaoOriginal}'),
                Text('Ponto Captura: ${paygogpos700.pontoCaptura}'),
                Text('Valor Operacao: ${paygogpos700.valorOperacao}'),
                Text('Saldo Voucher: ${paygogpos700.saldoVoucher}'),
              ],
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Dados da operação');
    });
  }

  void dialogErroOperacao() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: AlertDialog(
            title: Text("Erro na Operacao"),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  print('Clicou no DialogErro');
                  Navigator.pop(context);
                },
              ),
            ],
            content: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Erro: ' + paygogpos700.result.toString()),
                  Text('Mensagem: ' + paygogpos700.mensagemRetorno),
                ],
              ),
            ),
          ),
        );
      },
      //Your Dialog Code
    ).then((val) {
      print('Dialog Erro de Operação');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 30),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  "PayGo - GPOS 700 Flutter",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 70,
                        ),
                        child: Text(
                          "Valor em ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: SizedBox(
                          height: 30,
                          width: 150,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: precoVenda,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tipo Pagamento",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widgetTipoPagamento(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tipo Parcelamento",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widgetTipoParcelamento(),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Parcelas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numParcelas,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Adquirentes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: adquirenteEscolhido,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 18,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            adquirenteEscolhido = newValue;
                          });
                        },
                        items: <String>[
                          'DESCONHECIDO',
                          'LIBERCARD',
                          'ELAVON',
                          'CIELO',
                          'RV',
                          'BIN',
                          'FDCORBAN',
                          'REDE',
                          'INFOCARDS',
                          'CREDSYSTEM',
                          'NDDCARD',
                          'VERO',
                          'GLOBAL',
                          'GAX',
                          'STONE',
                          'DMCARD',
                          'CTF',
                          'TICKETLOG',
                          'GETNET',
                          'VCMAIS',
                          'SAFRA',
                          'PAGSEGURO',
                          'CONDUCTOR',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: confirmacaoManual,
                            onChanged: alterarValorConfirmacaoManual,
                          ),
                          Text(
                            "Confirmação Manual",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: viaCompleta,
                            onChanged: alterarValorViaCompleta,
                          ),
                          Text(
                            "Via Completa",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: viaLojaCliente,
                            onChanged: alterarValorViaLojaCliente,
                          ),
                          Text(
                            "Via Loja e Cliente",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: interfaceAlternativa,
                            onChanged: alterarValorInterfaceAlternativa,
                          ),
                          Text(
                            "Inter. Alternativa",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      button(
                        "Pagar",
                        () {
                          operacao(Paygogpos700.VENDA);
                        },
                      ),
                      button(
                        "Cancelamento",
                        () async {
                          // operacao(Paygogpos700.CANCELAMENTO);
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Cancelamento(
                                nsu: nsuRetornado,
                                codigoAutorizacao: codigoAutorizacaoRetornado,
                                dataOperacao: dataOperacaoRetornado,
                                valorOperacao: valorOperacaoRetornado,
                              ),
                            ),
                          );
                          print(result);
                          if (result != null) {
                            nsuRetornado = result['nsu'];
                            codigoAutorizacaoRetornado =
                                result['codigoAutorizacao'];
                            dataOperacaoRetornado = result['dataOperacao'];
                            valorOperacaoRetornado = result['valorOperacao'];
                            operacao(Paygogpos700.CANCELAMENTO);
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      button(
                        "Administrativo",
                        () {
                          operacao(Paygogpos700.ADMINISTRATIVA);
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

  Widget widgetTipoPagamento() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            radioCheck("Não Definido", tipoPagamentoSelecionado,
                radioButtonChangePagamento),
            AutoSizeText(
              'Não Definido',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            radioCheck("Crédito", tipoPagamentoSelecionado,
                radioButtonChangePagamento),
            AutoSizeText(
              'Crédito',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            radioCheck(
                "Débito", tipoPagamentoSelecionado, radioButtonChangePagamento),
            AutoSizeText(
              'Débito',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            radioCheck("Carteira Digital", tipoPagamentoSelecionado,
                radioButtonChangePagamento),
            AutoSizeText(
              'Carteira Digital',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget widgetTipoParcelamento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            radioCheck("Não Definido", tipoParcelamentoSelecionado,
                radioButtonChangeParcelamento),
            AutoSizeText(
              'Não Definido',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            radioCheck("A vista", tipoParcelamentoSelecionado,
                radioButtonChangeParcelamento),
            AutoSizeText(
              'A vista',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            radioCheck("Emissor", tipoParcelamentoSelecionado,
                radioButtonChangeParcelamento),
            AutoSizeText(
              'Emissor',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            radioCheck("Estabelecimento", tipoParcelamentoSelecionado,
                radioButtonChangeParcelamento),
            AutoSizeText(
              'Estabelecimento',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget radioCheck(String text, String controll, Function onChange) {
    return SizedBox(
      height: 30,
      child: Radio(
          value: text,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          groupValue: controll,
          onChanged: onChange),
    );
  }

  Widget button(String text, VoidCallback callback) {
    return Center(
      child: SizedBox(
        width: 150,
        child: RaisedButton(
          onPressed: callback,
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  // Altera o valor da opcao de habilitar impressao (true, false)
  void alterarValorConfirmacaoManual(bool newValue) => setState(
        () {
          confirmacaoManual = newValue;
        },
      );

  // Altera o valor da opcao de habilitar impressao (true, false)
  void alterarValorViaCompleta(bool newValue) => setState(
        () {
          viaCompleta = newValue;
        },
      );

  // Altera o valor da opcao de habilitar impressao (true, false)
  void alterarValorViaLojaCliente(bool newValue) => setState(
        () {
          viaLojaCliente = newValue;
        },
      );

  // Altera o valor da opcao de habilitar impressao (true, false)
  void alterarValorInterfaceAlternativa(bool newValue) => setState(
        () {
          interfaceAlternativa = newValue;
        },
      );

  //Marca o valor do tipo de pagamento escolhido
  void radioButtonChangePagamento(String value) {
    setState(
      () {
        tipoPagamentoSelecionado = value;
      },
    );
  }

  //Marca o valor do tipo de pagamento escolhido
  void radioButtonChangeParcelamento(String value) {
    setState(
      () {
        tipoParcelamentoSelecionado = value;
      },
    );
  }
}
