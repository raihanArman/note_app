import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/blocs/auth/auth_bloc.dart';
import 'package:note_app/blocs/note/note_bloc.dart';
import 'package:note_app/widgets/note_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      context.read<NoteBloc>().add(FetchNotes());
    }, builder: (context, authState) {
      return Scaffold(
        body: BlocBuilder<NoteBloc, NoteState>(builder: (context, notesState) {
          return _buildBody(authState, context, notesState);
        }),
      );
    });
  }

  Stack _buildBody(
      AuthState authState, BuildContext context, NoteState noteState) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                onPressed: () => authState is Authenticated
                    ? context.read<AuthBloc>().add(Logout())
                    : print('Go to login'),
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
              ),
              actions: [
                IconButton(
                    onPressed: () => print('Change theme'),
                    icon: Icon(Icons.brightness_4))
              ],
            ),
            noteState is NoteLoaded
                ? NoteGrid(
                    notes: noteState.notes,
                    onTap: (note) => print(note),
                  )
                : SliverPadding(padding: EdgeInsets.zero),
          ],
        ),
        noteState is NoteLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox.shrink(),
        noteState is NoteError
            ? Center(
                child: Text(
                  'Something error',
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
