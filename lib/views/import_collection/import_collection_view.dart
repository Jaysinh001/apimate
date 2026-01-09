import 'package:apimate/bloc/collection_list_bloc/collection_list_bloc.dart';
import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/views/import_collection/import_file_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/import_collection_bloc/import_collection_bloc.dart';
import '../../config/utility/screen_config.dart';
import '../../config/utility/utility.dart';
import 'import_summary_widget.dart';

class ImportCollectionView extends StatefulWidget {
  const ImportCollectionView({super.key});

  @override
  State<ImportCollectionView> createState() => _ImportCollectionViewState();
}

class _ImportCollectionViewState extends State<ImportCollectionView> {
  ImportCollectionBloc bloc = ImportCollectionBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);
    return BlocConsumer<ImportCollectionBloc, ImportCollectionState>(
      bloc: bloc,
      listener: (context, state) async {
        if (state.status == ImportCollectionScreenStatus.loading) {
          Utility.showFullScreenLoader(context: context);
        }
        if (state.status == ImportCollectionScreenStatus.error) {
          Utility.hideFullScreenLoader(context: context);
          Utility.showToastMessage(state.message ?? '', context);
        }

        if (state.status == ImportCollectionScreenStatus.preview) {
          Utility.hideFullScreenLoader(context: context);
          Utility.showToastMessage(
            "The Postman collection is loaded!",
            context,
          );
        }

        if (state.status == ImportCollectionScreenStatus.imported) {
          context.read<CollectionListBloc>().add(GetCollectionsFromLocalDB());

          Utility.hideFullScreenLoader(context: context);
          Utility.showToastMessage(
            "The Postman collection is loaded!",
            context,
          );
          // poping the import screen and bottomsheet.
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        Utility.showLog("build ImportCollectionView status: ${state.status}");

        return Scaffold(
          floatingActionButton:
              state.status != ImportCollectionScreenStatus.initial
                  ? FloatingActionButton.extended(
                    onPressed: () {
                      bloc.add(ImportDataToLocalStorage());
                    },
                    label: MyText.bodyLarge(
                      "Import Collection",
                      // style: TextStyle(color: Colors.white),
                    ),

                    icon: Icon(Icons.cloud_download_outlined),
                  )
                  : null,
          body: SafeArea(
            child: Padding(
              padding: screenConfig.padding,
              child: Column(
                children: [
                  MyNavbar(title: "Import Collection", showBackBtn: true),

                  if (state.status == ImportCollectionScreenStatus.initial) ...[
                    Spacer(),

                    ImportFileContainerWidget(
                      onTap: () {
                        bloc.add(ImportCollectionFile());
                      },
                    ),

                    Spacer(),
                  ],

                  // PREVIEW STATE
                  if (state.status == ImportCollectionScreenStatus.preview) ...[
                    ImportSummary(
                      folderCount: state.importFolderCount,
                      requestCount: state.importRequestCount,
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView(
                        children:
                            state.previewTree
                                .map((node) => PreviewTreeNode(node: node))
                                .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
