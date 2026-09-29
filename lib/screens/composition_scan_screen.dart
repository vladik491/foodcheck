import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class CompositionScanScreen extends StatefulWidget {
  const CompositionScanScreen({super.key});

  @override
  State<CompositionScanScreen> createState() => _CompositionScanScreenState();
}

class _CompositionScanScreenState extends State<CompositionScanScreen> {
  final picker = ImagePicker();
  bool recognizing = false;

  Future<void> takeCompositionPhoto() async {
    if (recognizing) return;
    setState(() => recognizing = true);
    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognized = await recognizer.processImage(
        InputImage.fromFilePath(image.path),
      );
      await recognizer.close();
      if (!mounted) return;

      if (recognized.text.trim().isEmpty) {
        await enterCompositionManually();
      } else {
        Navigator.of(context).pop(recognized.text.trim());
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось распознать состав')),
        );
      }
    } finally {
      if (mounted) setState(() => recognizing = false);
    }
  }

  Future<void> enterCompositionManually() async {
    final field = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Введите состав'),
        content: TextField(
          controller: field,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Например: молоко, мука, E322',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, field.text),
            child: const Text('Проверить'),
          ),
        ],
      ),
    );
    field.dispose();
    if (text != null && text.trim().isNotEmpty && mounted) {
      Navigator.of(context).pop(text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканирование состава')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Если товар не найден по штрихкоду, сфотографируйте блок «Состав» на упаковке. Приложение распознает текст и сравнит его с медицинским реестром.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: recognizing ? null : takeCompositionPhoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(
                recognizing ? 'Распознавание...' : 'Сфотографировать состав',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: recognizing ? null : enterCompositionManually,
              icon: const Icon(Icons.keyboard_outlined),
              label: const Text('Ввести состав вручную'),
            ),
          ],
        ),
      ),
    );
  }
}
