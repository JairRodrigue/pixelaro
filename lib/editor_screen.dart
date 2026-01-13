import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:path_provider/path_provider.dart'; 

class EditorScreen extends StatelessWidget {
  final String filePath;

  const EditorScreen({super.key, required this.filePath});

  Future<void> _saveToDownloads(BuildContext context, Uint8List bytes) async {
    try {
      final directory = await getDownloadsDirectory();
      final path = directory?.path ?? (await getTemporaryDirectory()).path;

      final fileName = 'pixelaro_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('$path/$fileName');

      await file.writeAsBytes(bytes);

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (ctx) => AlertDialog(
            title: const Text("Salvo com Sucesso!"),
            content: Text("Sua imagem está na pasta Downloads:\n\n$path/$fileName"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: ProImageEditor.file(
        File(filePath),
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (bytes) async {
            await _saveToDownloads(context, bytes);
          },
          onCloseEditor: () {
            Navigator.pop(context);
          },
        ),
        configs: ProImageEditorConfigs(
          imageGenerationConfigs: const ImageGenerationConfigs(
            outputFormat: OutputFormat.png,
            processorConfigs: ProcessorConfigs(
              processorMode: ProcessorMode.auto,
            ),
          ),
          
          paintEditorConfigs: const PaintEditorConfigs(
            enabled: true,
            hasOptionFreeStyle: true,
          ),

          textEditorConfigs: const TextEditorConfigs(
            enabled: true,
          ),

          cropRotateEditorConfigs: const CropRotateEditorConfigs(
            enabled: true,
          ),

          filterEditorConfigs: const FilterEditorConfigs(
            enabled: true,
          ),

          stickerEditorConfigs: StickerEditorConfigs(
            enabled: true,
            buildStickers: (setLayer, scrollController) {
              return Container();
            },
          ),
        ),
      ),
    );
  }
}