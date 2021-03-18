package com.gertec.gpos700impressao;

import android.content.Context;

import androidx.annotation.NonNull;

import br.com.gertec.gedi.exceptions.GediException;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Gpos700impressaoPlugin
 */
public class Gpos700impressaoPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    private Context ctx;
    private GertecPrinter gertecPrinter;
    private ConfigPrint configPrint;

    private final String getPlatformVersion = "getPlatformVersion";
    private final String getStatusImpressora = "getStatusImpressora";
    private final String getImpressoraOK = "getImpressoraOK";

    private final String setConfiguracaoImpressora = "setConfiguracaoImpressora";

    private final String setImprimeTexto = "setImprimeTexto";

    private final String setImprimeImagemDrawable = "setImprimeImagemDrawable";

    private final String setImprimeImagemBase64 = "setImprimeImagemBase64";

    private final String setImprimeBarCode = "setImprimeBarCode";

    private final String setImprimeBarCodeIMG = "setImprimeBarCodeIMG";

    private final String setImpressoraOutput = "setImpressoraOutput";

    private final String setAvancaLinha = "setAvancaLinha";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gpos700impressao");
        channel.setMethodCallHandler(this);
        ctx = flutterPluginBinding.getApplicationContext();
        gertecPrinter = new GertecPrinter(ctx);
        configPrint = new ConfigPrint();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        switch (call.method) {

            case getPlatformVersion:
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;

            case getStatusImpressora:
                try {
                    result.success(gertecPrinter.getStatusImpressora());
                } catch (GediException e) {
                    e.printStackTrace();
                    result.error(String.valueOf(e.getErrorCode()), e.getMessage(), e.getCause());
                }
                break;

            case getImpressoraOK:
                try {
                    result.success(gertecPrinter.isImpressoraOK());
                } catch (Exception e) {
                    e.printStackTrace();
                    result.error("000", e.getMessage(), e.getCause());
                }
                break;

            case setConfiguracaoImpressora:
                // ID Operacao
                this.configPrint.setFonte(call.argument("fonte"));
                this.configPrint.setAlinhamento(call.argument("alinhamento"));
                this.configPrint.setTamanho(call.argument("tamanho"));
                this.configPrint.setOffSet(call.argument("offSet"));
                this.configPrint.setiHeight(call.argument("iHeight"));
                this.configPrint.setiWidth(call.argument("iWidth"));
                this.configPrint.setLineSpace(call.argument("lineSpace"));
                this.configPrint.setNegrito(call.argument("negrito"));
                this.configPrint.setItalico(call.argument("italico"));
                this.configPrint.setSublinhado(call.argument("sublinhado"));
                this.configPrint.setAvancaLinhas(call.argument("avancaLinhas"));
                gertecPrinter.setConfigImpressao(this.configPrint);
                break;

            case setImprimeTexto:
                try {
                    gertecPrinter.imprimeTexto(call.argument("texto"));
                } catch (Exception e) {
                    e.printStackTrace();
                    result.error("001", e.getMessage(), e.getCause());
                }
                break;

            case setImprimeImagemDrawable:
                try {
                    result.success(gertecPrinter.imprimeImagemDrawable(call.argument("nomeImageDrawable")));
                } catch (Exception e) {
                    e.printStackTrace();
                    result.error("002", e.getMessage(), e.getCause());
                }
                break;

            case setImprimeImagemBase64:
                try {
                    result.success(gertecPrinter.imprimeImagemBase64(call.argument("imageStringBase64")));
                } catch (Exception e) {
                    e.printStackTrace();
                    result.error("003", e.getMessage(), e.getCause());
                }
                break;

            case setImprimeBarCode:
                try {
                    result.success(gertecPrinter.imprimeBarCode(call.argument("texto"), call.argument("height"), call.argument("width"), call.argument("barCodeType")));
                } catch (Exception e) {
                    e.printStackTrace();
                    result.error("004", e.getMessage(), e.getCause());
                }
                break;

            case setImprimeBarCodeIMG:
                try {
                    result.success(gertecPrinter.imprimeBarCodeIMG(call.argument("texto"), call.argument("height"), call.argument("width"), call.argument("barCodeType")));
                } catch (Exception e) {
                    e.printStackTrace();
                    result.error("005", e.getMessage(), e.getCause());
                }
                break;

            case setImpressoraOutput:

                try {
                    gertecPrinter.ImpressoraOutput();
                } catch (GediException e) {
                    e.printStackTrace();
                    result.error(String.valueOf(e.getErrorCode()), e.getMessage(), e.getCause());
                }

                break;

            case setAvancaLinha:
                try {
                    gertecPrinter.avancaLinha(call.argument("linha"));
                } catch (GediException e) {
                    e.printStackTrace();
                    result.error(String.valueOf(e.getErrorCode()), e.getMessage(), e.getCause());
                }
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + call.method);
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
