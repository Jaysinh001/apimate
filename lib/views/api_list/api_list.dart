import 'package:apimate/bloc/api_list_bloc/api_list_bloc.dart';
import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/components/no_data_widget.dart';
import 'package:apimate/config/routes/routes_name.dart';
import 'package:apimate/views/api_list/api_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/utility/utility.dart';
import '../../domain/model/get_api_list_model.dart';

class ApiListScreen extends StatefulWidget {
  final int collectionID;

  const ApiListScreen({super.key, required this.collectionID});

  @override
  State<ApiListScreen> createState() => _ApiListScreenState();
}

class _ApiListScreenState extends State<ApiListScreen> {
  ApiListBloc apiListBloc = ApiListBloc();
  @override
  void initState() {
    super.initState();

    // apiListBloc = context.read<ApiListBloc>();
    apiListBloc.add(GetApiList(id: widget.collectionID));
  }

  Future<void> _onRefresh() async {
    apiListBloc.add(GetApiList(id: widget.collectionID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          apiListBloc.add(CreateNewApi(collectionID: widget.collectionID));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => apiListBloc,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Column(
              children: [
                MyNavbar(title: "API List"),
                Expanded(
                  child: BlocConsumer<ApiListBloc, ApiListState>(
                    listener: (context, state) async {
                      if (state.apiListStatus == ApiListStatus.created) {
                        await Navigator.pushNamed(
                          context,
                          RoutesName.apiRequestView,
                          arguments: state.newApiRequest,
                        );
                        // This will be executed once the user comes back to this screen by poping
                        // all above screens in stack
                        apiListBloc.add(GetApiList(id: widget.collectionID));
                      }
                      if (state.apiListStatus == ApiListStatus.error &&
                          state.message != null) {
                        Utility.showToastMessage(state.message ?? '', context);
                      }
                    },
                    builder: (context, state) {
                      return state.apiList.isEmpty
                          ? NoDataWidget()
                          : ListView.builder(
                            itemCount: state.apiList.length,
                            itemBuilder:
                                (context, index) => ApiListTile(
                                  name: state.apiList[index].name ?? '',
                                  url: state.apiList[index].url ?? '',
                                  method: state.apiList[index].method ?? '',
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RoutesName.apiRequestView,
                                      arguments: state.apiList[index],
                                    );

                                    Utility.showLog("After Navigator");

                                    // This will be executed once the user comes back to this screen by poping
                                    // all above screens in stack
                                    apiListBloc.add(
                                      GetApiList(id: widget.collectionID),
                                    );
                                  },
                                  onDeleteTap: () {
                                    apiListBloc.add(
                                      DeleteApi(
                                        id: state.apiList[index].id ?? 0,
                                      ),
                                    );
                                  },
                                ),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
