
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';

final articleToBeDeleted = StateProvider<Article?>((ref) => null);
final articleToBeEdited = StateProvider<Article?>((ref) => null);
final articleCreation = StateProvider<bool>((ref) => false);

final articlesChanged= StateProvider<bool>((ref) => false);
