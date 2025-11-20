import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final String url;
  final String? listPathUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
    this.listPathUrl,
  });

  @override
  List<Object?> get props => [id, name, url, listPathUrl];
}
