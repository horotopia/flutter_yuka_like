import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yuka_like/model/product.dart';
import 'package:flutter_yuka_like/res/app_colors.dart';
import 'package:flutter_yuka_like/res/app_icons.dart';
import 'package:flutter_yuka_like/res/app_images.dart';
import 'package:flutter_yuka_like/screens/details/product_bloc.dart';

class ProductSummary extends StatefulWidget {
  static const double kImageHeight = 300.0;

  const ProductSummary({Key? key}) : super(key: key);

  @override
  State<ProductSummary> createState() => _ProductSummaryState();
}

double _scrollProgress(BuildContext context) {
  ScrollController? controller = PrimaryScrollController.of(context);
  return !controller.hasClients
      ? 0
      : (controller.position.pixels / ProductSummary.kImageHeight).clamp(0, 1);
}

class _ProductSummaryState extends State<ProductSummary> {
  double _currentScrollProgress = 0.0;

  // Quand on scroll, on redraw pour changer la couleur de l'image
  void _onScroll() {
    if (_currentScrollProgress != _scrollProgress(context)) {
      setState(() {
        _currentScrollProgress = _scrollProgress(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController =
    PrimaryScrollController.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        _onScroll();
        return false;
      },
      child: Stack(children: [
        Image.network(
          (BlocProvider.of<ProductBloc>(context).state as LoadedProductState)
              .product
              .picture ??
              '',
          width: double.infinity,
          height: ProductSummary.kImageHeight,
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(_currentScrollProgress),
          colorBlendMode: BlendMode.srcATop,
        ),
        Positioned.fill(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Scrollbar(
              controller: scrollController,
              trackVisibility: true,
              child: Container(
                margin: const EdgeInsetsDirectional.only(
                  top: ProductSummary.kImageHeight - 30.0,
                ),
                child: const _Body(),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _HeaderIcon extends StatefulWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;

  const _HeaderIcon({
    required this.icon,
    this.tooltip,
    // ignore: unused_element
    this.onPressed,
  });

  @override
  State<_HeaderIcon> createState() => _HeaderIconState();
}

class _HeaderIconState extends State<_HeaderIcon> {
  double _opacity = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrimaryScrollController.of(context).addListener(_onScroll);
  }

  void _onScroll() {
    double newOpacity = _scrollProgress(context);

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: widget.tooltip,
            child: InkWell(
              onTap: widget.onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                  Theme.of(context).primaryColorLight.withOpacity(_opacity),
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  static const double _kHorizontalPadding = 20.0;
  static const double _kVerticalPadding = 30.0;

  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(16.0),
          topEnd: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
              vertical: _kVerticalPadding,
            ),
            child: _Header(),
          ),
          //_Scores(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
              vertical: _kVerticalPadding,
            ),
            child: _Info(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProductBloc, ProductState>(
        builder: (BuildContext context, ProductState state) {
          final Product product = (state as LoadedProductState).product;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.name != null)
                Text(
                  product.name!,
                  style: textTheme.displayLarge,
                ),
              const SizedBox(
                height: 3.0,
              ),
              if (product.brands != null) ...[
                Text(
                  product.brands!.join(", "),
                  style: textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ],
          );
        });
  }
}

class _Info extends StatelessWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
        builder: (BuildContext context, ProductState state) {
      final Product product = (state as LoadedProductState).product;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProductItemValue(
            label: '',
            percent: 'Pour 100g',
            value: 'Par part',
          ),
          if (product.nutritionFacts?.energy != null)
            _ProductItemValue(
              label: 'Energie',
              percent: '${product.nutritionFacts!.energy!.per100g} ${product.nutritionFacts!.energy!.unit}',
              value: '${product.nutritionFacts!.energy!.perServing} ${product.nutritionFacts!.energy!.unit}',
            ),
          if (product.nutritionFacts?.fat != null)
            _ProductItemValue(
              label: 'Matières grasses',
              percent: '${product.nutritionFacts!.fat!.per100g} ${product.nutritionFacts!.fat!.unit}',
              value: '${product.nutritionFacts!.fat!.perServing} ${product.nutritionFacts!.fat!.unit}',
            ),
          if (product.nutritionFacts?.saturatedFat != null)
            _ProductItemValue(
              label: 'dont Acides gras saturés',
              percent: '${product.nutritionFacts!.saturatedFat!.per100g} ${product.nutritionFacts!.saturatedFat!.unit}',
              value: '${product.nutritionFacts!.saturatedFat!.perServing} ${product.nutritionFacts!.saturatedFat!.unit}',
            ),
          if (product.nutritionFacts?.carbohydrate != null)
            _ProductItemValue(
              label: 'Glucides',
              percent: '${product.nutritionFacts!.carbohydrate!.per100g} ${product.nutritionFacts!.carbohydrate!.unit}',
              value: '${product.nutritionFacts!.carbohydrate!.perServing} ${product.nutritionFacts!.carbohydrate!.unit}',
            ),
          if (product.nutritionFacts?.sugar != null)
            _ProductItemValue(
              label: 'dont Sucres',
              percent: '${product.nutritionFacts!.sugar!.per100g} ${product.nutritionFacts!.sugar!.unit}',
              value: '${product.nutritionFacts!.sugar!.perServing} ${product.nutritionFacts!.sugar!.unit}',
            ),
          if (product.nutritionFacts?.fiber != null)
            _ProductItemValue(
              label: 'Fibres alimentaires',
              percent: '${product.nutritionFacts!.fiber!.per100g} ${product.nutritionFacts!.fiber!.unit}',
              value: '${product.nutritionFacts!.fiber!.perServing} ${product.nutritionFacts!.fiber!.unit}',
            ),
          if (product.nutritionFacts?.proteins != null)
            _ProductItemValue(
              label: 'Protéines',
              percent: '${product.nutritionFacts!.proteins!.per100g} ${product.nutritionFacts!.proteins!.unit}',
              value: '${product.nutritionFacts!.proteins!.perServing} ${product.nutritionFacts!.proteins!.unit}',
            ),
          if (product.nutritionFacts?.salt != null)
            _ProductItemValue(
              label: 'Sel',
              percent: '${product.nutritionFacts!.salt!.per100g} ${product.nutritionFacts!.salt!.unit}',
              value: '${product.nutritionFacts!.salt!.perServing} ${product.nutritionFacts!.salt!.unit}',
            ),
          if (product.nutritionFacts?.sodium != null)
            _ProductItemValue(
              label: 'Sodium',
              percent: '${product.nutritionFacts!.sodium!.per100g} ${product.nutritionFacts!.sodium!.unit}',
              value: '${product.nutritionFacts!.sodium!.perServing} ${product.nutritionFacts!.sodium!.unit}',
              includeDivider: false,
            ),
          SizedBox(
            height: 15.0,
          ),
        ],
      );
    });
  }
}

class _ProductItemValue extends StatelessWidget {
  final String label;
  final String percent;
  final String value;
  final bool includeDivider;

  const _ProductItemValue({
    required this.label,
    required this.percent,
    required this.value,
    this.includeDivider = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                width: 1.0,
                height: 40.0,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                child: Text(
                  percent,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 1.0,
                height: 40.0,
                color: Theme.of(context).dividerColor,
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        if (includeDivider) const Divider(height: 1.0)
      ],
    );
  }
}
