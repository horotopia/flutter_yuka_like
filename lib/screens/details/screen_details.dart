import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yuka_like/res/app_icons.dart';
import 'package:flutter_yuka_like/screens/details/product_bloc.dart';
import 'package:flutter_yuka_like/screens/details/tabs/details_info.dart';
import 'package:flutter_yuka_like/screens/details/tabs/details_nutrition.dart';
import 'package:flutter_yuka_like/screens/details/tabs/details_nutritional_values.dart';
import 'package:flutter_yuka_like/screens/details/tabs/details_summary.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailsArgs {
  final String barcode;

  const ProductDetailsArgs({
    required this.barcode,
  }) : assert(barcode != '');
}

class ProductDetails extends StatefulWidget {
  final ProductDetailsArgs args;

  const ProductDetails({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ScrollController _controller = ScrollController();
  ProductDetailsTab _currentTab = ProductDetailsTab.info;

  @override
  Widget build(BuildContext context) {
    final Widget child;

    switch (_currentTab) {
      case ProductDetailsTab.info:
        child = const ProductInfo();
        break;
      case ProductDetailsTab.nutrition:
        child = const ProductNutrition();
        break;
      case ProductDetailsTab.nutritionalValues:
        child = const ProductNutritionalValues();
        break;
      case ProductDetailsTab.summary:
        child = const ProductSummary();
        break;
    }

    return PrimaryScrollController(
      controller: _controller,
      child: BlocProvider<ProductBloc>(
        create: (_) {
          ProductBloc bloc = ProductBloc();
          bloc.add(LoadProductEvent(widget.args.barcode));
          return bloc;
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (BuildContext context, ProductState state) {
            if (state is LoadingProductState) {
              // Loading
              return const _ProductDetailsLoading();
            } else if (state is LoadedProductState) {
              // OK
              return Scaffold(
                body: Stack(
                  children: [
                    Positioned.fill(child: child),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: _HeaderIcon(
                        icon: AppIcons.close,
                        tooltip: 'Fermer l\'écran',
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (BuildContext context, ProductState state) {
                        if (state is! LoadedProductState) {
                          return const SizedBox();
                        }

                        return _HeaderIcon(
                          icon: AppIcons.share,
                          tooltip: 'Partager',
                          onPressed: () {
                            Share.share(
                              'https://fr.openfoodfacts.org/produit/${(state as LoadedProductState).product.barcode})}',
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (int selectedPosition) {
                    ProductDetailsTab newTab =
                        ProductDetailsTab.values[selectedPosition];

                    if (newTab != _currentTab) {
                      if (_controller.hasClients) {
                        _controller.jumpTo(0.0);
                      }

                      setState(() {
                        _currentTab = newTab;
                      });
                    }
                  },
                  items: ProductDetailsTab.values.map((e) {
                    String? label;
                    IconData? icon;

                    switch (e) {
                      case ProductDetailsTab.info:
                        icon = AppIcons.tab_barcode;
                        label = "Fiche";
                        break;
                      case ProductDetailsTab.nutritionalValues:
                        icon = AppIcons.tab_fridge;
                        label = "Caractéristiques";
                        break;
                      case ProductDetailsTab.nutrition:
                        icon = AppIcons.tab_nutrition;
                        label = "Nutrition";
                        break;
                      case ProductDetailsTab.summary:
                        icon = AppIcons.tab_array;
                        label = "Tableau";
                    }

                    if (label == null || icon == null) {
                      throw Exception("Tab $e not implemented!");
                    }

                    return BottomNavigationBarItem(
                      icon: Icon(icon),
                      label: label,
                    );
                  }).toList(growable: false),
                  currentIndex: _currentTab.index,
                ),
              );
            } else {
              // Erreur
              return const ProductDetailsError();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ProductDetailsError extends StatelessWidget {
  const ProductDetailsError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Erreur !"),
      ),
    );
  }
}

class _ProductDetailsLoading extends StatelessWidget {
  const _ProductDetailsLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

enum ProductDetailsTab {
  info,
  nutrition,
  nutritionalValues,
  summary,
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

double _scrollProgress(BuildContext context) {
  ScrollController? controller = PrimaryScrollController.of(context);
  return !controller.hasClients
      ? 0
      : (controller.position.pixels / ProductInfo.kImageHeight).clamp(0, 1);
}
