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
  late final Future<_InitializedData> _initAll;

  @override
  void initState() {
    super.initState();
    _initAll = _initializeAll();
  }

  Future<_InitializedData> _initializeAll() async {
    final MatchManagerService matchManagerService = MatchManagerService();
    matchManagerService.initialSet(widget.fen, widget.playerSide);
    final chessBoardViewmodel = ChessBoardViewmodel(matchManagerService);
    final matchViewmodel = MatchViewmodel(matchManagerService);
    final timerViewmodel = TimerViewmodel(matchManagerService);

    await chessBoardViewmodel.initializeChessBoard();

    return _InitializedData(
      matchManagerService: matchManagerService,
      chessBoardViewmodel: chessBoardViewmodel,
      matchViewmodel: matchViewmodel,
      timerViewmodel: timerViewmodel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initAll,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasData) {
          final data = asyncSnapshot.data!;

          return MultiProvider(
            providers: [
              Provider<MatchManagerService>(
                create: (_) => data.matchManagerService,
                dispose: (_, service) => service.dispose(),
              ),
              ChangeNotifierProvider.value(value: data.chessBoardViewmodel),
              ChangeNotifierProvider.value(value: data.matchViewmodel),
              ChangeNotifierProvider.value(value: data.timerViewmodel),
            ],
            child: Match(enableBot: widget.enableBot),
          );
        }

        return Center(child: const Text('Something went wrong'));
      },
    );
  }
}

class _InitializedData {
  final MatchManagerService matchManagerService;
  final ChessBoardViewmodel chessBoardViewmodel;
  final MatchViewmodel matchViewmodel;
  final TimerViewmodel timerViewmodel;

  _InitializedData({
    required this.matchManagerService,
    required this.chessBoardViewmodel,
    required this.matchViewmodel,
    required this.timerViewmodel,
  });
}
