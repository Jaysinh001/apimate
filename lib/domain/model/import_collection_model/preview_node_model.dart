import 'package:equatable/equatable.dart';

enum PreviewNodeType { folder, request }

class ImportPreviewNode extends Equatable {
  final PreviewNodeType type;
  final String name;

  // Request-only
  final String? method;

  // Folder-only
  final List<ImportPreviewNode>? children;

  const ImportPreviewNode({
    required this.type,
    required this.name,
    this.method,
    this.children,
  });

  @override
  List<Object?> get props => [type, name, method, children];
}
