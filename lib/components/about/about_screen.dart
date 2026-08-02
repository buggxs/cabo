import 'dart:io';
import 'dart:math' as math;

import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/about/cubit/about_cubit.dart';
import 'package:cabo/components/about/widgets/debug_test_section.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/application/app_design.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
  static const int _maxFeedbackLength = 350;

  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Einfache E-Mail-Validierung (lokaler Teil @ Domain . TLD).
  static final RegExp _emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  bool _isLoading = false;

  int _copyrightTapCount = 0;

  void _handleCopyrightTap() {
    setState(() {
      _copyrightTapCount++;
    });
    if (_copyrightTapCount < 7) {
      return;
    }
    _copyrightTapCount = 0;
    context.read<ApplicationCubit>().toggleDeveloperMode();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.developerModeToggled),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
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
    // Validiert die Nachricht (Pflichtfeld) und die optionale E-Mail.
    if (!(_formKey.currentState?.validate() ?? false)) {
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

      final String email = _emailController.text.trim();

      // 2. Feedback in Firestore speichern (mit 'imagePath' statt 'imageUrl')
      await FirebaseFirestore.instance.collection('feedback').add({
        'text': _feedbackController.text,
        'email': email.isEmpty ? null : email,
        'imagePath':
            imagePath, // wird null sein, wenn kein Bild hochgeladen wurde
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. UI zurücksetzen und Erfolgsmeldung zeigen
      _feedbackController.clear();
      _emailController.clear();
      // Setzt den Validierungszustand zurück, damit die geleerten Felder wieder
      // als „unberührt" gelten und nicht sofort einen Fehler anzeigen.
      _formKey.currentState?.reset();
      setState(() {
        _imageFile = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.aboutScreenFeedbackSuccess),
          backgroundColor: CaboTheme.m3Secondary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.aboutScreenFeedbackError),
          backgroundColor: CaboTheme.m3Error,
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
      backgroundColor: CaboTheme.scaffoldBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CaboTheme.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.aboutScreenTitle,
          style: CaboTheme.headlineMediumStyle.copyWith(
            color: CaboTheme.m3Primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: <Widget>[
                _buildRatingHero(context),
                const SizedBox(height: 32),
                _buildDesignCard(context),
                const SizedBox(height: 32),
                _buildFeedbackCard(context),
                const SizedBox(height: 32),
                _buildFunFactCard(context),
                const SizedBox(height: 24),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleCopyrightTap,
                  child: Text(
                    '© Andre Salzmann ${DateTime.now().year}',
                    textAlign: TextAlign.center,
                    style: CaboTheme.labelSmallStyle.copyWith(
                      color: CaboTheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (kDebugMode) ...<Widget>[
                  const SizedBox(height: 24),
                  const DebugTestSection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingHero(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 128,
          height: 128,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: 6 * math.pi / 180,
                child: Container(
                  decoration: BoxDecoration(
                    color: CaboTheme.primaryFixedDim.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: CaboTheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: CaboTheme.outlineVariant),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x143D3A35),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(Icons.star, size: 64, color: CaboTheme.m3Primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutScreenRatingHeadline,
          textAlign: TextAlign.center,
          style: CaboTheme.headlineMediumStyle.copyWith(
            color: CaboTheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            context.l10n.aboutScreenRatingDescription,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 240,
          child: CaboPrimaryButton(
            label: context.l10n.aboutScreenRatingButton,
            onPressed: () => app<RatingService>().openStoreListing(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesignCard(BuildContext context) {
    final AppDesign design = context.watch<ApplicationCubit>().state.design;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            context.l10n.designSectionTitle,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.designSectionSubtitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          SegmentedButton<AppDesign>(
            segments: <ButtonSegment<AppDesign>>[
              ButtonSegment<AppDesign>(
                value: AppDesign.modern,
                label: Text(context.l10n.designModern),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment<AppDesign>(
                value: AppDesign.classic,
                label: Text(context.l10n.designClassic),
                icon: const Icon(Icons.forest_outlined),
              ),
            ],
            selected: <AppDesign>{design},
            showSelectedIcon: false,
            onSelectionChanged: (Set<AppDesign> selection) {
              context.read<ApplicationCubit>().saveDesign(selection.first);
            },
          ),
          const SizedBox(height: 12),
          Text(
            design == AppDesign.classic
                ? context.l10n.designClassicDescription
                : context.l10n.designModernDescription,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            context.l10n.aboutScreenFeedbackTitle,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.aboutScreenFeedbackSubtitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildFieldLabel(context.l10n.aboutScreenEmailLabel),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: CaboTheme.m3Primary,
                  style: CaboTheme.bodyMediumStyle.copyWith(
                    color: CaboTheme.onSurface,
                  ),
                  validator: (String? value) {
                    final String email = value?.trim() ?? '';
                    // Optional: nur validieren, wenn etwas eingegeben wurde.
                    if (email.isNotEmpty && !_emailRegExp.hasMatch(email)) {
                      return context.l10n.aboutScreenEmailInvalid;
                    }
                    return null;
                  },
                  decoration: _inputDecoration(
                    context.l10n.aboutScreenEmailHint,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFieldLabel(context.l10n.aboutScreenFeedbackLabel),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 5,
                  maxLength: _maxFeedbackLength,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: CaboTheme.m3Primary,
                  style: CaboTheme.bodyMediumStyle.copyWith(
                    color: CaboTheme.onSurface,
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.l10n.aboutScreenFeedbackRequired;
                    }
                    return null;
                  },
                  buildCounter:
                      (
                        BuildContext context, {
                        required int currentLength,
                        required int? maxLength,
                        required bool isFocused,
                      }) => null,
                  decoration: _inputDecoration(
                    context.l10n.aboutScreenFeedbackHint,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, right: 4),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _feedbackController,
                builder: (BuildContext context, TextEditingValue value, _) {
                  return Text(
                    '${value.text.characters.length} / $_maxFeedbackLength',
                    style: CaboTheme.labelSmallStyle.copyWith(
                      color: CaboTheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          if (_imageFile != null) ...<Widget>[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_imageFile!.path),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickImage,
            style: OutlinedButton.styleFrom(
              foregroundColor: CaboTheme.m3Primary,
              side: BorderSide(
                color: CaboTheme.primaryContainer.withValues(alpha: 0.3),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
              ),
            ),
            icon: Icon(Icons.attach_file, color: CaboTheme.m3Primary),
            label: Text(
              _imageFile == null
                  ? context.l10n.aboutScreenFeedbackAddImage
                  : context.l10n.aboutScreenFeedbackChangeImage,
              style: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.m3Primary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CaboPrimaryButton(
            label: context.l10n.aboutScreenFeedbackButton,
            leading: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: CaboTheme.onPrimaryContainer,
                      strokeWidth: 2.5,
                    ),
                  )
                : null,
            onPressed: _isLoading ? null : _submitFeedback,
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.isClassic
            ? CaboTheme.surfaceContainerHigh
            : const Color(0xFFFFFCEB),
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_outline, color: CaboTheme.m3Tertiary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              context.l10n.aboutScreenFunFact,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.m3Tertiary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: CaboTheme.labelSmallStyle.copyWith(
          color: CaboTheme.onSurfaceVariant,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: CaboTheme.surfaceContainer,
      hintText: hint,
      hintStyle: CaboTheme.bodyMediumStyle.copyWith(
        color: CaboTheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        borderSide: BorderSide(color: CaboTheme.primaryContainer, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        borderSide: BorderSide(color: CaboTheme.m3Error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        borderSide: BorderSide(color: CaboTheme.m3Error, width: 2),
      ),
      errorStyle: CaboTheme.labelSmallStyle.copyWith(color: CaboTheme.m3Error),
    );
  }
}
