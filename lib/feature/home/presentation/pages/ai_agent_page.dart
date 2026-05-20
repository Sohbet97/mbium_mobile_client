import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';

class AiAgetntPage extends StatefulWidget {
  const AiAgetntPage({super.key});

  @override
  State<AiAgetntPage> createState() => _AiAgetntPageState();
}

class _AiAgetntPageState extends State<AiAgetntPage> {
  late AiBloc _aiBloc;
  @override
  void initState() {
    super.initState();
    _aiBloc = context.read<AiBloc>();
    _aiBloc.add(GetRecomendasionListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiBloc, AiState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
              
            ],
          ),
        );
      },
    );
  }
}
