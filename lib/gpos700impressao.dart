import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Gpos700impressao {
  // CONST TIPO PAGAMENTO = ModalidadesPagamento
  static const STATUS_IMPRESSORA_OK = '0';
  static const STATUS_IMPRESSORA_OVERHEAT = '1';
  static const STATUS_IMPRESSORA_OUT_OF_PAPER = '2';
  static const STATUS_IMPRESSORA_UNKNOWN_ERROR = '3';

  static const FONTE_PADRAO_NORMAL = 'NORMAL';
  static const FONTE_PADRAO_DEFAULT = 'DEFAULT';
  static const FONTE_PADRAO_DEFAULT_BOLD = 'DEFAULT BOLD';
  static const FONTE_PADRAO_MONOSPACE = 'MONOSPACE';
  static const FONTE_PADRAO_SANS_SERIF = 'SANS SERIF';
  static const FONTE_PADRAO_SERIF = 'SERIF';

  static const IMPRESSORA_ALINHADO_LEFT = 'LEFT';
  static const IMPRESSORA_ALINHADO_CENTER = 'CENTER';
  static const IMPRESSORA_ALINHADO_RIGHT = 'RIGHT';

  static const BAR_CODE_TYPE_AZTEC = '0';
  static const BAR_CODE_TYPE_CODABAR = '1';
  static const BAR_CODE_TYPE_CODE_39 = '2';
  static const BAR_CODE_TYPE_CODE_93 = '3';
  static const BAR_CODE_TYPE_CODE_128 = '4';
  static const BAR_CODE_TYPE_DATA_MATRIX = '5';
  static const BAR_CODE_TYPE_EAN_8 = '6';
  static const BAR_CODE_TYPE_EAN_13 = '7';
  static const BAR_CODE_TYPE_ITF = '8';
  static const BAR_CODE_TYPE_MAXICODE = '9';
  static const BAR_CODE_TYPE_PDF_417 = '10';
  static const BAR_CODE_TYPE_QR_CODE = '11';
  static const BAR_CODE_TYPE_RSS_14 = '12';
  static const BAR_CODE_TYPE_RSS_EXPANDED = '13';
  static const BAR_CODE_TYPE_UPC_A = '14';
  static const BAR_CODE_TYPE_UPC_E = '15';
  static const BAR_CODE_TYPE_UPC_EAN_EXTENSION = '16';

  static const MethodChannel _channel = const MethodChannel('gpos700impressao');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getStatusImpressora() async {
    final String status = await _channel.invokeMethod('getStatusImpressora');
    var traduzStatusImpressora = '';
    switch (status) {
      case STATUS_IMPRESSORA_OK:
        traduzStatusImpressora = 'IMPRESSORA OK';
        break;

      case STATUS_IMPRESSORA_OVERHEAT:
        traduzStatusImpressora = 'SUPER AQUECIMENTO';
        break;

      case STATUS_IMPRESSORA_OUT_OF_PAPER:
        traduzStatusImpressora = 'SEM PAPEL';
        break;

      case STATUS_IMPRESSORA_UNKNOWN_ERROR:
        traduzStatusImpressora = 'ERRO DESCONHECIDO';
        break;
    }

    return traduzStatusImpressora;
  }

  static Future<bool> getImpressoraOK() async {
    final bool impressora = await _channel.invokeMethod('getImpressoraOK');
    return impressora;
  }

  static Future<void> setConfiguracaoImpressora({
    @required String fonte,
    @required String alinhamento,
    @required int tamanho,
    @required int offSet,
    @required int iHeight,
    @required int iWidth,
    @required int lineSpace,
    @required bool negrito,
    @required bool italico,
    @required bool sublinhado,
    @required int avancaLinhas,
  }) async {
    Map<String, dynamic> mapConfiguraImpressao = Map();

    mapConfiguraImpressao['fonte'] = fonte;
    mapConfiguraImpressao['alinhamento'] = alinhamento;
    mapConfiguraImpressao['tamanho'] = tamanho;
    mapConfiguraImpressao['offSet'] = offSet;
    mapConfiguraImpressao['iHeight'] = iHeight;
    mapConfiguraImpressao['iWidth'] = iWidth;
    mapConfiguraImpressao['lineSpace'] = lineSpace;
    mapConfiguraImpressao['negrito'] = negrito;
    mapConfiguraImpressao['italico'] = italico;
    mapConfiguraImpressao['sublinhado'] = sublinhado;
    mapConfiguraImpressao['avancaLinhas'] = avancaLinhas;

    await _channel.invokeMethod(
        'setConfiguracaoImpressora', mapConfiguraImpressao);
  }

  static Future<void> setImprimeTexto({@required String texto}) async {
    Map<String, dynamic> mapImprimeTexto = Map();

    mapImprimeTexto['texto'] = texto;
    await _channel.invokeMethod('setImprimeTexto', mapImprimeTexto);
  }

  static Future<bool> setImprimeImagemDrawable(
      {@required String nomeImageDrawable}) async {
    Map<String, dynamic> mapImprimeImagemDrawable = Map();

    mapImprimeImagemDrawable['nomeImageDrawable'] = nomeImageDrawable;
    return await _channel.invokeMethod(
        'setImprimeImagemDrawable', mapImprimeImagemDrawable);
  }

  static Future<bool> setImprimeImagemBase64({
    @required String imageStringBase64,
  }) async {
    Map<String, dynamic> mapImageStringBase64 = Map();

    mapImageStringBase64['imageStringBase64'] = imageStringBase64;
    return await _channel.invokeMethod(
        'setImprimeImagemBase64', mapImageStringBase64);
  }

  static Future<bool> setImprimeBarCode({
    @required String texto,
    @required int height,
    @required int width,
    @required String barCodeType,
  }) async {
    Map<String, dynamic> mapImprimeBarCode = Map();

    mapImprimeBarCode['texto'] = texto;
    mapImprimeBarCode['height'] = height;
    mapImprimeBarCode['width'] = width;
    mapImprimeBarCode['barCodeType'] = barCodeType;
    return await _channel.invokeMethod('setImprimeBarCode', mapImprimeBarCode);
  }

  static Future<bool> setImprimeBarCodeIMG({
    @required String texto,
    @required int height,
    @required int width,
    @required String barCodeType,
  }) async {
    Map<String, dynamic> mapImprimeBarCodeIMG = Map();

    mapImprimeBarCodeIMG['texto'] = texto;
    mapImprimeBarCodeIMG['height'] = height;
    mapImprimeBarCodeIMG['width'] = width;
    mapImprimeBarCodeIMG['barCodeType'] = barCodeType;
    return await _channel.invokeMethod(
        'setImprimeBarCodeIMG', mapImprimeBarCodeIMG);
  }

  static Future<void> setImpressoraOutput() async {
    await _channel.invokeMethod('setImpressoraOutput');
  }

  static Future<void> setAvancaLinha({@required int linhas}) async {
    Map<String, dynamic> mapAvancaLinha = Map();

    mapAvancaLinha['linha'] = linhas;
    await _channel.invokeMethod('setAvancaLinha', mapAvancaLinha);
  }
}
