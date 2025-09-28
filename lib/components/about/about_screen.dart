import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/common/presentation/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/about/cubit/about_cubit.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const route = 'about_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AboutCubit(),
      child: const AboutScreenContent(),
    );
  }
}

class AboutScreenContent extends StatefulWidget {
  const AboutScreenContent({super.key});

  @override
  State<AboutScreenContent> createState() => _AboutScreenContentState();
}

class _AboutScreenContentState extends State<AboutScreenContent> {
  final _feedbackController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  bool _isLoading = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Komprimiert das Bild etwas für schnellere Uploads
    );

    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib dein Feedback ein.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imagePath; // Wir speichern jetzt den Pfad, nicht die URL

      // 1. Bild hochladen, falls eines ausgewählt wurde
      if (_imageFile != null) {
        final fileName = '${DateTime.now().toIso8601String()}.jpg';
        final ref = FirebaseStorage.instance
            .ref()
            .child('feedback_images')
            .child(fileName);

        await ref.putFile(File(_imageFile!.path));

        // KORREKTUR: Wir holen nicht mehr die Download-URL, sondern den Pfad der Datei.
        imagePath = ref.fullPath;
      }

      // 2. Feedback in Firestore speichern (mit 'imagePath' statt 'imageUrl')
      await FirebaseFirestore.instance.collection('feedback').add({
        'text': _feedbackController.text,
        'imagePath':
            imagePath, // wird null sein, wenn kein Bild hochgeladen wurde
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. UI zurücksetzen und Erfolgsmeldung zeigen
      _feedbackController.clear();
      setState(() {
        _imageFile = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.aboutScreenFeedbackSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.aboutScreenFeedbackError),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.aboutScreenTitle,
          style: context.textTheme.headlineLarge,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: DarkScreenOverlay(
          darken: 0.70,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 6,
                    ),
                    child: Text(
                      context.l10n.aboutScreenTextAreaDescription,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: CaboTheme.primaryColor,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            // topRight
                            offset: const Offset(1.5, 1.5),
                            color: Colors.black.withAlpha(200),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: CaboTheme.primaryColor,
                      backgroundColor: CaboTheme.secondaryColor,
                      textStyle: CaboTheme.secondaryTextStyle.copyWith(
                        color: CaboTheme.primaryColor,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                          color: CaboTheme.primaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onPressed: () => app<RatingService>().openStoreListing(),
                    child: Text(context.l10n.aboutScreenRatingButton),
                  ),
                  const SizedBox(height: 50),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: CaboTheme.secondaryBackgroundColor.withAlpha(150),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AutoSizeText(
                            context.l10n.aboutScreenFeedbackTitle,
                            style: context.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _feedbackController,
                            decoration: InputDecoration(
                              labelText: context.l10n.aboutScreenFeedbackLabel,
                              labelStyle: context.textTheme.bodyMedium
                                  ?.copyWith(color: CaboTheme.primaryColor),
                              hintText: context.l10n.aboutScreenFeedbackHint,
                              hintStyle: context.textTheme.bodySmall?.copyWith(
                                color: CaboTheme.primaryColor.withAlpha(150),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CaboTheme.primaryColor,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CaboTheme.primaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: CaboTheme.primaryColor,
                            ),
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: 16),
                          if (_imageFile != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(_imageFile!.path),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          OutlinedButton.icon(
                            onPressed: _pickImage,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: CaboTheme.primaryColor,
                              side: const BorderSide(
                                color: CaboTheme.primaryColor,
                              ),
                            ),
                            icon: const Icon(
                              Icons.attach_file,
                              color: CaboTheme.primaryColor,
                            ),
                            label: Text(
                              _imageFile == null
                                  ? context.l10n.aboutScreenFeedbackAddImage
                                  : context.l10n.aboutScreenFeedbackChangeImage,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: CaboTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submitFeedback,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(context.l10n.aboutScreenFeedbackButton),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Text(
                    '© Andre Salzmann ${DateTime.now().year}',
                    style: CaboTheme.primaryTextStyle.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
