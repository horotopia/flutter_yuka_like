// Event
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yuka_like/model/product.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  final String barcode;

  LoadProductEvent(this.barcode) : assert(barcode != '');
}

// State
abstract class ProductState {
  const ProductState();
}

class LoadingProductState extends ProductState {
  const LoadingProductState();
}

class LoadedProductState extends ProductState {
  final Product product;

  const LoadedProductState(this.product);
}

class ErrorProductState extends ProductState {
  final Exception error;

  const ErrorProductState(this.error);
}

// BloC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  // Valeur initiale
  ProductBloc() : super(const LoadingProductState()) {
    on<LoadProductEvent>(_onLoadProduct);
  }

  Future<void> _onLoadProduct(handler, emitter) async {
    emitter(const LoadingProductState());

    // TODO Faire de la requête
    await Future.delayed(const Duration(seconds: 5));

    emitter(
      LoadedProductState(
        Product(
          barcode: '123456789',
          name: 'Petits pois et carottes',
          brands: ['Cassegrain'],
          altName: 'Petits pois & carottes à l\'étuvée avec garniture',
          nutriScore: ProductNutriscore.A,
          novaScore: ProductNovaScore.Group1,
          ecoScore: ProductEcoScore.D,
          quantity: '200g (égoutté 130g)',
          manufacturingCountries: ['France'],
          picture:
              'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1610&q=80',
          nutritionFacts:
            NutritionFacts(
              servingSize: 'nc',
              calories: Nutriment(unit: 'kj',perServing: '?',per100g: 293),
              fat: Nutriment(unit: 'g',perServing: '?',per100g: 0.8),
              saturatedFat: Nutriment(unit: 'g',perServing: '?',per100g: 0.1),
              carbohydrate: Nutriment(unit: 'g',perServing: '?',per100g: 8.4),
              sugar: Nutriment(unit: 'g',perServing: '?',per100g: 5.2),
              fiber: Nutriment(unit: 'g',perServing: '?',per100g: 5.2),
              proteins: Nutriment(unit: 'g',perServing: '?',per100g: 4.2),
              sodium: Nutriment(unit: 'g',perServing: '?',per100g: 0.295),
              salt: Nutriment(unit: 'g',perServing: '?',per100g: 0.75),
              energy: Nutriment(unit: 'kj',perServing: '?',per100g: 293),
              ),
            ),
        ),
    );
  }
}
