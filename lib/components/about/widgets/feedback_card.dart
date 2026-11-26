import 'dart:io';

import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Feedback form of the about screen: optional e-mail, required message and
/// an optional screenshot, stored in Firestore and Firebase Storage.
class FeedbackCard extends StatefulWidget {
  const FeedbackCard({super.key});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  static const int _maxFeedbackLength = 350;

  // Simple e-mail check: local part @ domain . TLD.
  static final RegExp _emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Compresses the image a bit for faster uploads.
    );

    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  Future<void> _submitFeedback() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String? imagePath = await _uploadImage();
      await _saveFeedback(imagePath);
      _resetForm();
      if (!mounted) return;
      _showSnackBar(
        context.l10n.aboutScreenFeedbackSuccess,
        CaboTheme.m3Secondary,
      );
    } on Exception {
      if (!mounted) return;
      _showSnackBar(context.l10n.aboutScreenFeedbackError, CaboTheme.m3Error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Stores the storage path instead of a download URL.
  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      return null;
    }
    final String fileName = '${DateTime.now().toIso8601String()}.jpg';
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('feedback_images')
        .child(fileName);

    await ref.putFile(File(_imageFile!.path));
    return ref.fullPath;
  }

  Future<void> _saveFeedback(String? imagePath) async {
    final String email = _emailController.text.trim();
    await FirebaseFirestore.instance
        .collection('feedback')
        .add(<String, dynamic>{
          'text': _feedbackController.text,
          'email': email.isEmpty ? null : email,
          'imagePath': imagePath,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  void _resetForm() {
    _feedbackController.clear();
    _emailController.clear();
    // Resets the validation state so the cleared fields count as untouched
    // again and do not immediately show an error.
    _formKey.currentState?.reset();
    setState(() {
      _imageFile = null;
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ..._buildHeader(context),
          const SizedBox(height: 20),
          _buildForm(context),
          _buildCharacterCounter(),
          if (_imageFile != null) ...<Widget>[
            const SizedBox(height: 12),
            _buildImagePreview(),
          ],
          const SizedBox(height: 16),
          _buildImageButton(context),
          const SizedBox(height: 20),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context) {
    return <Widget>[
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
    ];
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildFieldLabel(context.l10n.aboutScreenEmailLabel),
          const SizedBox(height: 4),
          _buildEmailField(context),
          const SizedBox(height: 16),
          _buildFieldLabel(context.l10n.aboutScreenFeedbackLabel),
          const SizedBox(height: 4),
          _buildFeedbackField(context),
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: CaboTheme.m3Primary,
      style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
      validator: (String? value) {
        final String email = value?.trim() ?? '';
        // The e-mail is optional, so only validate it when something was entered.
        if (email.isNotEmpty && !_emailRegExp.hasMatch(email)) {
          return context.l10n.aboutScreenEmailInvalid;
        }
        return null;
      },
      decoration: _inputDecoration(context.l10n.aboutScreenEmailHint),
    );
  }

  Widget _buildFeedbackField(BuildContext context) {
    return TextFormField(
      controller: _feedbackController,
      maxLines: 5,
      maxLength: _maxFeedbackLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: CaboTheme.m3Primary,
      style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
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
      decoration: _inputDecoration(context.l10n.aboutScreenFeedbackHint),
    );
  }

  Widget _buildCharacterCounter() {
    return Align(
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
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(_imageFile!.path),
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageButton(BuildContext context) {
    return OutlinedButton.icon(
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
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return CaboPrimaryButton(
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
