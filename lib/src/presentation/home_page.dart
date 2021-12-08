import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../actions/get_movies.dart';
import '../container/is_loading_container.dart';
import '../container/movie_container.dart';
import '../models/app_state.dart';
import '../models/movie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final Store<AppState> store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(GetMovies(onResult));

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final double currentPosition = _controller.offset;
    final double maxPosition = _controller.position.maxScrollExtent;

    final Store<AppState> store = StoreProvider.of<AppState>(context);

    if (!store.state.isLoading && currentPosition > maxPosition * 0.8) {
      store.dispatch(GetMovies(onResult));
    }
  }

  void onResult(dynamic action) {
    if (action is GetMoviesError) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error getting movies'),
            content: Text('${action.error}'),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IsLoadingContainer(
            builder: (BuildContext context, bool isLoading) {
              if (!isLoading) {
                return const SizedBox.shrink();
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      body: MoviesContainer(
        builder: (BuildContext context, List<Movie> movies) {
          return ListView.builder(
            controller: _controller,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];

              return ListTile(
                title: Text(movie.title),
              );
            },
          );
        },
      ),
    );
  }
}
