import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/logs/bloc/log_bloc.dart';
import 'package:front/website/pages/backoffice/logs/bloc/log_state.dart';
import 'package:front/website/pages/backoffice/logs/components/log_list.dart';
import 'package:front/website/pages/backoffice/logs/components/title_and_breadcrumb.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchLogs();
  }

  void _fetchLogs() {
    context.read<LogBloc>().add(FetchLogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          const TitleAndBreadcrumb(),
          Expanded(
            child: BlocBuilder<LogBloc, LogState>(
              builder: (context, state) {
                if (state is LogLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LogLoaded) {
                  return LogList(logs: state.logs);
                } else if (state is LogError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No logs found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
