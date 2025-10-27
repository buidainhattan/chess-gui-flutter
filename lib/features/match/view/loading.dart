import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/helper/match_manager_service.dart';
import 'package:chess_app/features/chess_board/viewmodel/chess_board_viewmodel.dart';
import 'package:chess_app/features/match/view/match.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:chess_app/features/match/viewmodel/timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  final bool enableBot;
  final String fen;
  final Sides playerSide;

  const Loading({
    super.key,
    this.enableBot = false,
    this.fen = "",
    this.playerSide = Sides.white,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late final Future<MatchManagerService> _initServiceFuture;

  @override
  void initState() {
    super.initState();
    _initServiceFuture = _initializeService();
  }

  Future<MatchManagerService> _initializeService() async {
    final MatchManagerService service = MatchManagerService();
    service.initialSet(widget.fen, widget.playerSide);
    return service;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initServiceFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (asyncSnapshot.hasData) {
          final MatchManagerService initializedService = asyncSnapshot.data!;

          return MultiProvider(
            providers: [
              Provider<MatchManagerService>(
                create: (_) => initializedService,
                dispose: (_, service) => service.dispose(),
              ),
              ChangeNotifierProvider(
                create: (context) =>
                    ChessBoardViewmodel(context.read<MatchManagerService>()),
              ),
              ChangeNotifierProvider(
                create: (context) =>
                    MatchViewmodel(context.read<MatchManagerService>()),
              ),
              ChangeNotifierProvider(
                create: (context) =>
                    TimerViewmodel(context.read<MatchManagerService>()),
              ),
            ],
            child: Match(enableBot: widget.enableBot),
          );
        }

        return Center(child: const Text('Something went wrong'));
      },
    );
  }
}
