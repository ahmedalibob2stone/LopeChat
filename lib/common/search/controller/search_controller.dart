
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/search_repository.dart';
final  searchControllerProvider=Provider((ref) {
  final searchRepository=ref.watch(searchRepositoryProvider);
  return SearchController (searchRepository:searchRepository , ref: ref);
});
class SearchController{
  SearchRepository searchRepository;
  final Ref ref;

  SearchController({
    required this.searchRepository,
    required this.ref
});
  Stream<QuerySnapshot> search(String uid){

 return searchRepository.search(uid);


  }
}