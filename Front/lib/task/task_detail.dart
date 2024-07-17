import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/main.dart';
import 'package:front/task/task.dart';
import 'package:front/vote/bloc/vote_bloc.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});
  static const routeName = "/task-detail";

  @override
  Widget build(BuildContext context) {
    context.read<VoteBloc>().add(FetchVotesByTaskId(task.id));
    Uint8List? bytes = task.picture != "" ? base64Decode(task.picture) : null;

    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.task, color: Colors.white),
                const SizedBox(width: 10),
                Text('task_detail'.tr(),
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Card(
                        color: Colors.blueGrey.withOpacity(0.05),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  task.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                        )
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.blueGrey.withOpacity(0.05),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'task_detail_date_realization'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            task.date,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey.withOpacity(0.05),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'task_detail_duration'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${(task.duration / 60).toStringAsPrecision(2)} h",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey.withOpacity(0.05),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'task_detail_points'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${task.pts} points",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<VoteBloc, CompositeVoteState>(
                    builder: (context, state) {
                      if (state.voteByTaskIdState is VoteByTaskIdLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.voteByTaskIdState is VoteByTaskIdError) {
                        return Center(
                          child: Text(
                            (state.voteByTaskIdState as VoteByTaskIdError).message,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      } else if (state.voteByTaskIdState is VoteByTaskIdLoaded) {
                        final votes = (state.voteByTaskIdState as VoteByTaskIdLoaded).votes;
                        if (votes.isNotEmpty) {
                          return Card(
                            color: Colors.blueGrey.withOpacity(0.05),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'task_satisfaction_rate'.tr(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${(votes.where((vote) => vote.value == 1).length / votes.length * 100).toStringAsFixed(2)} %",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Card(
                            color: Colors.blueGrey.withOpacity(0.05),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'task_satisfaction_rate'.tr(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "task_no_vote".tr(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(height: 40);
                      }
                    },
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'task_detail_proof_visual'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        bytes != null
                            ? Card(
                          color: Colors.blueGrey.withOpacity(0.05),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              bytes,
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.8,
                            ),
                          ),
                        )
                            : Text(
                          'task_detail_no_proof'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
