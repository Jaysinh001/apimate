import 'package:apimate/bloc/collection_bloc/collection_bloc.dart';
import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/routes/routes_name.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:apimate/views/api_collections/collection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../data/services/shared_preference_manager.dart';
import 'add_collection_bottomsheet.dart';

class ApiCollectionsScreen extends StatefulWidget {
  const ApiCollectionsScreen({super.key});

  @override
  State<ApiCollectionsScreen> createState() => _ApiCollectionsScreenState();
}

class _ApiCollectionsScreenState extends State<ApiCollectionsScreen> {
  late CollectionBloc collectionBloc;

  @override
  void initState() {
    super.initState();

    collectionBloc = context.read<CollectionBloc>();
    collectionBloc.add(const GetCollectionsFromLocalDB());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            builder: (context) {
              return AddCollectionBottomsheet();
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MyNavbar(
              showBackBtn: false,
              title: "API Collections",
              trailing: PopupMenuButton(
                icon: Icon(Icons.color_lens_rounded),
                onSelected: (value) async {
                  context.read<ThemeBloc>().add(ChangeTheme(theme: value));
                  final sharedPreferencesManager = SharedPreferencesManager();
                  await sharedPreferencesManager.init();

                  await sharedPreferencesManager.setThemeName(value);
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: ThemeNames.dracula,
                        child: MyText.bodyMedium(
                          ThemeNames.dracula.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.gruvbox,
                        child: MyText.bodyMedium(
                          ThemeNames.gruvbox.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.monokai,
                        child: MyText.bodyMedium(
                          ThemeNames.monokai.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.nord,
                        child: MyText.bodyMedium(
                          ThemeNames.nord.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.solarized,
                        child: MyText.bodyMedium(
                          ThemeNames.solarized.name.toString(),
                        ),
                      ),
                    ],
              ),
            ),

            Expanded(
              child: BlocConsumer<CollectionBloc, CollectionState>(
                listener: (context, state) {
                  if (state.collectionScreenStatus ==
                      CollectionScreenStatus.loading) {
                    Utility.showFullScreenLoader(context: context);
                  }

                  if (state.collectionScreenStatus ==
                      CollectionScreenStatus.success) {
                    Utility.hideFullScreenLoader(context: context);
                  }

                  if (state.collectionScreenStatus ==
                          CollectionScreenStatus.created &&
                      state.message != null) {
                    Utility.hideFullScreenLoader(context: context);
                    Navigator.pop(context);
                    Utility.showToastMessage(state.message ?? '', context);
                  }
                  if (state.collectionScreenStatus ==
                          CollectionScreenStatus.error &&
                      state.message != null) {
                    Utility.hideFullScreenLoader(context: context);
                    Navigator.pop(context);
                    Utility.showToastMessage(state.message ?? '', context);
                  }
                },
                builder: (context, state) {
                  return state.collectionList.isEmpty
                      ? Center(child: MyText.bodyLarge("Add New Collection"))
                      : ListView.builder(
                        itemCount: state.collectionList.length,
                        itemBuilder: (context, index) {
                          return CollectionTile(
                            name: state.collectionList[index].name ?? '',
                            onCollectionTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesName.apiList,
                                arguments: state.collectionList[index].id,
                              );
                            },
                            onDeleteTap: () {
                              collectionBloc.add(
                                DeleteCollection(
                                  id: state.collectionList[index].id ?? 0,
                                ),
                              );
                            },
                          );
                        },
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
