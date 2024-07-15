import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/website/pages/backoffice/colocations/bloc/colocation_bloc.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalColocations;
  final int pageSize;
  final bool showPagination;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalColocations,
    this.pageSize = 5,
    this.showPagination = true,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalColocations / pageSize).ceil();

    if (!showPagination) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: currentPage > 1
                ? () {
                    context
                        .read<ColocationBloc>()
                        .add(LoadColocations(page: 1, pageSize: pageSize));
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: currentPage > 1
                ? () {
                    context.read<ColocationBloc>().add(LoadColocations(
                        page: currentPage - 1, pageSize: pageSize));
                  }
                : null,
          ),
          Text('$currentPage / $totalPages'),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: currentPage < totalPages
                ? () {
                    context.read<ColocationBloc>().add(LoadColocations(
                        page: currentPage + 1, pageSize: pageSize));
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: currentPage < totalPages
                ? () {
                    context.read<ColocationBloc>().add(
                        LoadColocations(page: totalPages, pageSize: pageSize));
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
