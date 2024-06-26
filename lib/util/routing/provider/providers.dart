
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';

final articleToBeDeleted = StateProvider<Article?>((ref) => null);

final articlesChanged= StateProvider<bool>((ref) => false);
