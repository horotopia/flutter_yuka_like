// Event
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yuka_like/model/product.dart';
import 'package:flutter_yuka_like/screens/details/request.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

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

    Request request = Request();
    Product product = await request.apiRequest();
    await Future.delayed(const Duration(seconds: 5));

    emitter(
      LoadedProductState(
        Product(
          barcode: product.barcode,
          name: product.name,
          brands: product.brands,
          altName: product.altName,
          nutriScore: product.nutriScore,
          novaScore: product.novaScore,
          ecoScore: product.ecoScore,
          quantity: product.quantity,
          manufacturingCountries: product.manufacturingCountries,
          picture: product.picture,
          ingredients: product.ingredients,
          nutrientLevels:NutrientLevels(
              fat: product.nutrientLevels?.fat,
              saturatedFat: product.nutrientLevels?.saturatedFat,
              sugars: product.nutrientLevels?.sugars,
              salt: product.nutrientLevels?.salt),
          nutritionFacts:
            NutritionFacts(
              servingSize: product.nutritionFacts!.servingSize,
              calories: product.nutritionFacts?.calories,
              fat:Nutriment(unit:product.nutritionFacts!.fat!.unit,perServing:product.nutritionFacts!.fat!.perServing,per100g:product.nutritionFacts!.fat!.per100g),
              saturatedFat:Nutriment(unit:product.nutritionFacts!.saturatedFat!.unit,perServing:product.nutritionFacts!.saturatedFat!.perServing,per100g:product.nutritionFacts!.saturatedFat!.per100g),
              carbohydrate:Nutriment(unit:product.nutritionFacts!.carbohydrate!.unit,perServing:product.nutritionFacts!.carbohydrate!.perServing,per100g:product.nutritionFacts!.carbohydrate!.per100g),
              sugar:Nutriment(unit:product.nutritionFacts!.sugar!.unit,perServing:product.nutritionFacts!.sugar!.perServing,per100g:product.nutritionFacts!.sugar!.per100g),
              fiber:Nutriment(unit:product.nutritionFacts!.fiber!.unit,perServing:product.nutritionFacts!.fiber!.perServing,per100g:product.nutritionFacts!.fiber!.per100g),
              proteins:Nutriment(unit:product.nutritionFacts!.proteins!.unit,perServing:product.nutritionFacts!.proteins!.perServing,per100g:product.nutritionFacts!.proteins!.per100g),
              sodium:Nutriment(unit:product.nutritionFacts!.sodium!.unit,perServing:product.nutritionFacts!.sodium!.perServing,per100g:product.nutritionFacts!.sodium!.per100g),
              salt:Nutriment(unit:product.nutritionFacts!.salt!.unit,perServing:product.nutritionFacts!.salt!.perServing,per100g:product.nutritionFacts!.salt!.per100g),
              energy:Nutriment(unit:product.nutritionFacts!.energy!.unit,perServing:product.nutritionFacts!.energy!.perServing,per100g:product.nutritionFacts!.energy!.per100g)
              ),
            ),
        ),
    );
  }
}
