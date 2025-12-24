import 'package:equatable/equatable.dart';

import 'raw_import_model.dart';

enum PreviewNodeType { folder, request }

class ImportPreviewNode extends Equatable {
  final PreviewNodeType type;
  final String name;

  // Request-only
  final String? method;
    final PostmanRequest? postmanRequest;


  // Folder-only
  final List<ImportPreviewNode>? children;

  const ImportPreviewNode({
    required this.type,
    required this.name,
    this.method,
    this.postmanRequest,
    this.children,
  });

  @override
  List<Object?> get props => [type, name, method,postmanRequest, children];
}
