import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PublicGameScreen extends StatefulWidget {
  const PublicGameScreen({
    super.key,
    required this.publishGame,
    this.gameId,
  });

  final Future<String?> Function() publishGame;
  final String? gameId;

  @override
  State<PublicGameScreen> createState() => _PublicGameScreenState();
}

class _PublicGameScreenState extends State<PublicGameScreen> {
  bool _showEmailForm = false;

  String? _publicGameId;
  bool _showCheck = false;
  bool _isPublishing = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.gameId != null) {
      _publicGameId = widget.gameId;
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
          icon: const Icon(
            Icons.close,
            size: 24,
            color: CaboTheme.primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: const Text(
          'Spiel veröffentlichen',
          style: CaboTheme.primaryTextStyle,
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
            child: BlocBuilder<ApplicationCubit, ApplicationState>(
              builder: (context, state) {
                if (state is ApplicationAuthenticated &&
                    !(FirebaseAuth.instance.currentUser?.isAnonymous ?? true)) {
                  return _buildAuthenticatedView(context);
                } else {
                  return _buildLoginOptions(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context) {
    Widget currentView;

    if (_publicGameId != null) {
      currentView = _buildQrCodeView(context, _publicGameId!);
    } else if (_showCheck) {
      currentView = _buildCheckmarkView();
    } else {
      currentView = _buildPublishButtonView(context);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: currentView,
    );
  }

  Widget _buildCheckmarkView() {
    return const Column(
      key: ValueKey<String>('check-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.greenAccent,
          size: 140,
        ),
      ],
    );
  }

  Widget _buildQrCodeView(BuildContext context, String gameId) {
    QrCode qrCode = QrCode.fromData(
      data: gameId,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    final QrImage qrImage = QrImage(qrCode);

    return Column(
      key: const ValueKey<String>('qr-code-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Andere können dem Spiel mit diesem QR Code beitreten:',
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 24),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: 200,
          height: 200,
          child: PrettyQrView(
            qrImage: qrImage,
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButtonView(BuildContext context) {
    return Column(
      key: const ValueKey<String>('publish-button-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Dein Spiel ist bereit, veröffentlicht zu werden.',
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 26),
          ),
        ),
        const SizedBox(height: 20),
        MenuButton(
          text: 'Spiel veröffentlichen',
          onTap: _isPublishing ? null : _handlePublishGame,
          textStyle: CaboTheme.primaryTextStyle.copyWith(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Future<void> _handlePublishGame() async {
    setState(() {
      _isPublishing = true;
    });

    final String? publicGameId = await widget.publishGame();

    if (publicGameId != null && mounted) {
      setState(() {
        _showCheck = true;
        _isPublishing = false;
      });

      await Future<void>.delayed(const Duration(milliseconds: 1200));

      setState(() {
        _publicGameId = publicGameId;
      });
    } else {
      setState(() {
        _isPublishing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Spiel konnte nicht veröffentlicht werden.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildLoginOptions(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
            child: Text(
              'Melde dich an, um dein Spiel zu veröffentlichen.',
              textAlign: TextAlign.center,
              style: CaboTheme.primaryTextStyle.copyWith(fontSize: 28),
            ),
          ),
          if (!_showEmailForm) ...[
            MenuButton(
              text: 'Mit Google anmelden',
              onTap: () {
                context.read<ApplicationCubit>().signInWithGoogle();
              },
              textStyle: CaboTheme.primaryTextStyle.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            MenuButton(
              text: 'Mit E-Mail anmelden/registrieren',
              onTap: () {
                setState(() {
                  _showEmailForm = true;
                });
              },
              textStyle: CaboTheme.primaryTextStyle.copyWith(
                fontSize: 18,
              ),
            ),
          ],
          if (_showEmailForm) _buildEmailForm(context),
        ],
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          hintText: 'E-Mail',
          icon: Icons.email,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _passwordController,
          hintText: 'Passwort',
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _confirmPasswordController,
          hintText: 'Passwort bestätigen',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        MenuButton(
          text: 'Anmelden / Registrieren',
          onTap: () {
            // Hier kommt die Logik für die E-Mail-Anmeldung hin
          },
          textStyle: CaboTheme.primaryTextStyle.copyWith(
            fontSize: 18,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showEmailForm = false;
            });
          },
          child: const Text(
            'Zurück',
            style: TextStyle(color: CaboTheme.primaryColor, fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required IconData icon,
      bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: CaboTheme.primaryColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: CaboTheme.primaryColor),
        hintText: hintText,
        hintStyle: TextStyle(color: CaboTheme.primaryColor.withOpacity(0.7)),
        filled: true,
        fillColor: CaboTheme.secondaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: CaboTheme.tertiaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: CaboTheme.primaryColor),
        ),
      ),
    );
  }
}
