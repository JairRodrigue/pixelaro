import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pixelaro/editor_screen.dart';
import 'package:url_launcher/url_launcher.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDragging = false;

  Future<void> _openGitHub() async {
    final Uri url = Uri.parse('https://github.com/JairRodrigue');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Erro ao abrir link: $e");
    }
  }

  Future<void> _openEditor(String path) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(filePath: path),
      ),
    );
    
    if (mounted) {
      setState(() {
        _isDragging = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        dialogTitle: "Selecione uma imagem para editar",
        lockParentWindow: false, 
      );

      if (result != null && result.files.single.path != null) {
        _openEditor(result.files.single.path!);
      }
    } catch (e) {
      debugPrint("Erro ao abrir arquivo: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Não foi possível abrir a imagem."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DropTarget(
              onDragDone: (detail) {
                if (detail.files.isNotEmpty) {
                  _openEditor(detail.files.first.path);
                }
              },
              onDragEntered: (detail) => setState(() => _isDragging = true),
              onDragExited: (detail) => setState(() => _isDragging = false),
              child: Container(
                color: _isDragging
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_fix_high,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Gap(20),
                Text(
                  "Pixelaro",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.5,
                        color: Colors.white,
                      ),
                ),
                Text(
                  "Pro Image Editor",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                        letterSpacing: 2.0,
                      ),
                ),
                const Gap(40),
                
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.folder_open, color: Colors.black),
                  label: const Text(
                    "Open Image",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                
                const Gap(20),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black45,
                  ),
                  child: const Text(
                    "or drag and drop your file here",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton.icon(
                onPressed: _openGitHub,
                icon: const Icon(Icons.code, size: 18, color: Colors.grey),
                label: Text(
                  "Developed by Jair Rodrigues",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                    letterSpacing: 1.0,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}