import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/views/import_collection/import_file_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/import_collection_bloc/import_collection_bloc.dart';
import '../../config/theme/color/colors.dart';
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
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);
    return BlocConsumer<ImportCollectionBloc, ImportCollectionState>(
      bloc: bloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        Utility.showLog("build ImportCollectionView status: ${state.status}");

        return Scaffold(
          floatingActionButton: state.status != ImportCollectionScreenStatus.initial ? FloatingActionButton.extended(onPressed: (){

            bloc.add(ImportDataToLocalStorage());

          }, label: MyText.bodyLarge("Import Collection" , style: TextStyle(color:  Colors.white),),
          
          icon: Icon(Icons.cloud_download_outlined , color: Colors.white,),
          ) : null,
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
