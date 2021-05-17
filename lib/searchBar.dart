import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class Search extends StatelessWidget {
  final List<List<String>> searchableList;

  const Search({
    @required this.searchableList,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar App',
      home: HomePage(searchableList),
    );
  }
}

class HomePage extends StatefulWidget {

  List<List<String>> searchableList;

  HomePage(List<List<String>> _searchableList)
  {
    this.searchableList = _searchableList;
  }

  @override
  _HomePageState createState() => _HomePageState(searchableList);
}

class _HomePageState extends State<HomePage> {
  static const historyLength = 5;
  List<String> _searchHistory = [
  ];
  List<String> filteredSearchHistory;
  String selectedTerm;
  List<List<String>> searchableList;

  _HomePageState(List<List<String>> _searchableList) {
    this.searchableList = _searchableList;
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
  List<List<String>> searchableList;
  List<String> itemDescriptions;

  SearchResultsListView({
    Key key,
    @required this.searchTerm,
    @required this.searchableList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget constructFullResults( BuildContext context, int index ){
      return Card(
        child: ListTile(
            title: Text(searchableList[0][index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: new AppBar(
                    title: Text(searchableList[0][index]),
                  ),
                  body: Text(searchableList[1][index]),
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
                itemCount: searchableList[0].length,
              )
          )
      );

    }


    List<List<String>> amendedSearchList = [];
    List<String> amendedTitles = [];
    List<String> amendedDescriptions = [];
    List<String> amendedCategories = [];

    for (int i = 0; i < searchableList[0].length; i++)
    {
      if (searchableList[0][i].toLowerCase().contains(searchTerm.toLowerCase())
      ||  searchableList[2][i].toLowerCase().contains(searchTerm.toLowerCase()))
      {
          amendedTitles.add(searchableList[0][i]);
          amendedDescriptions.add(searchableList[1][i]);
          amendedCategories.add(searchableList[2][i]);
      }
    }
    amendedSearchList.add(amendedTitles);
    amendedSearchList.add(amendedDescriptions);
    amendedSearchList.add(amendedCategories);


    Widget constructFilteredResults( BuildContext context, int index ){
      return Card(
        child: ListTile(
            title: Text(amendedSearchList[0][index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: new AppBar(
                    title: Text(amendedSearchList[0][index]),
                  ),
                  body: Text(amendedSearchList[1][index]),
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
              itemCount: amendedSearchList[0].length,
            )
        )
    );
  }
}