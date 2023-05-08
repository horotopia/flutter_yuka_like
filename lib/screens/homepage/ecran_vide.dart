import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_yuka_like/res/app_colors.dart';
import 'package:flutter_yuka_like/res/app_icons.dart';
import 'package:flutter_yuka_like/res/app_vectorial_images.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes scans',
        ),
        actions: const [
          _EmptyScreenAppBarBarcodeAction(),
        ],
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _EmptyScreenIllustration(),
              const SizedBox(height: 20.0),
              const _EmptyScreenMessage(),
              const SizedBox(height: 20.0),
              _EmptyScreenButton(
                onPressed: openNextScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openNextScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/details',
      arguments: '123456789',
    );
  }
}

class _EmptyScreenAppBarBarcodeAction extends StatelessWidget {
  const _EmptyScreenAppBarBarcodeAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8.0,
      ),
      child: IconButton(
        icon: const Icon(
          AppIcons.barcode,
        ),
        onPressed: () {},
        tooltip: 'Scanner un code-barres',
      ),
    );
  }
}

class _EmptyScreenIllustration extends StatelessWidget {
  const _EmptyScreenIllustration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppVectorialImages.illEmpty,
      height: 310.0,
    );
  }
}

class _EmptyScreenMessage extends StatelessWidget {
  const _EmptyScreenMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Vous n\'avez pas encore scanné de produit',
      textAlign: TextAlign.center,
    );
  }
}

class _EmptyScreenButton extends StatelessWidget {
  final ButtonCallback? onPressed;

  const _EmptyScreenButton({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed != null ? () => onPressed!(context) : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(22.0),
          ),
        ),
        backgroundColor: AppColors.yellow,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: 10.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Commencer'.toUpperCase(),
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(Icons.arrow_right_alt)
          ],
        ),
      ),
    );
  }
}

typedef ButtonCallback = void Function(BuildContext context);
