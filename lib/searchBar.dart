import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class Search extends StatelessWidget {
  final List<String> searchableList;
  final List<String> itemDescriptions;

  const Search({
    @required this.searchableList,
    @required this.itemDescriptions,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar App',
      home: HomePage(searchableList, itemDescriptions),
    );
  }
}

class HomePage extends StatefulWidget {

  List<String> searchableList;
  List <String> itemDescriptions;

  HomePage(List<String> _searchableList, List<String> _itemDescriptions)
  {
    this.searchableList = _searchableList;
    this.itemDescriptions = _itemDescriptions;
  }

  @override
  _HomePageState createState() => _HomePageState(searchableList, itemDescriptions);
}

class _HomePageState extends State<HomePage> {
  static const historyLength = 5;
  List<String> _searchHistory = [
  ];
  List<String> filteredSearchHistory;
  String selectedTerm;
  List<String> searchableList;
  List<String> itemDescriptions;

  _HomePageState(List<String> _searchableList, List<String> _itemDescriptions) {
    this.searchableList = _searchableList;
    this.itemDescriptions = _itemDescriptions;
  }


  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: FloatingSearchBar(
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            searchableList: searchableList,
            itemDescriptions: itemDescriptions,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search for an exercise',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                          title: Text(
                            term,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.history),
                          trailing: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                deleteSearchTerm(term);
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              putSearchTermFirst(term);
                              selectedTerm = term;
                            });
                            controller.close();
                          },
                        ),
                      )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  String searchTerm;
  List<String> searchableList;
  List<String> itemDescriptions;

  SearchResultsListView({
    Key key,
    @required this.searchTerm,
    @required this.searchableList,
    @required this.itemDescriptions
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Widget constructFullResults( BuildContext context, int index ){
      return Card(
        child: ListTile(
            title: Text(searchableList[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: new AppBar(
                    title: Text(searchableList[index]),
                  ),
                  body: Text(itemDescriptions[index]),
                )),
              );
            }
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context);

    if (searchTerm == null) {
      return Scaffold(
          body: Container(
              padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
              child: ListView.builder(
                itemBuilder: constructFullResults,
                itemCount: searchableList.length,
              )
          )
      );

    }


    List<String> amendedSearchList = [];
    List<String> amendedDescriptions = [];

    for (int i = 0; i < searchableList.length; i++)
    {
      if (searchableList[i].contains(searchTerm))
      {
        amendedSearchList.add(searchableList[i]);
        amendedDescriptions.add(itemDescriptions[i]);
      }
    }


    for (int i = 0; i <searchableList.length; i++)
    {
      if (searchableList[i].toLowerCase().contains(searchTerm.toLowerCase()))
      {
        if (!(amendedSearchList.contains(searchableList[i])))
        {
          amendedSearchList.add(searchableList[i]);
          amendedDescriptions.add(itemDescriptions[i]);
        }
      }
    }


    Widget constructFilteredResults( BuildContext context, int index ){
      return Card(
        child: ListTile(
            title: Text(amendedSearchList[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: new AppBar(
                    title: Text(amendedSearchList[index]),
                  ),
                  body: Text(amendedDescriptions[index]),
                )),
              );
            }
        ),
      );
    }



    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
            child: ListView.builder(
              itemBuilder: constructFilteredResults,
              itemCount: amendedSearchList.length,
            )
        )
    );
  }
}