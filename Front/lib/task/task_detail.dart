import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/task/task.dart';

import '../vote/bloc/vote_bloc.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});
  static const routeName = "/task-detail";

  @override
  Widget build(BuildContext context) {
    context.read<VoteBloc>().add(FetchVotesByTaskId(task.id));
    Uint8List? bytes = task.picture != "" ? base64Decode(task.picture) : null;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.task, color: Colors.white),
            const SizedBox(width: 10),
            Text('task_detail'.tr(),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  task.title,
                  style: const TextStyle(fontSize: 28, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'task_detail_description'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'task_detail_date_realization'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      task.date,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    )
                  ]),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'task_detail_duration'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${(task.duration / 60).toStringAsPrecision(2)} h",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'task_detail_points'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${task.pts} points",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ]),
              BlocBuilder<VoteBloc, CompositeVoteState>(
                  builder: (context, state) {
                if (state.voteByTaskIdState is VoteByTaskIdLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.voteByTaskIdState is VoteByTaskIdError) {
                  return Center(
                    child: Text(
                        (state.voteByTaskIdState as VoteByTaskIdError).message),
                  );
                } else if (state.voteByTaskIdState is VoteByTaskIdLoaded) {
                  final votes =
                      (state.voteByTaskIdState as VoteByTaskIdLoaded).votes;
                  if ((votes.length) > 0) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'task_satisfaction_rate'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${(votes.where((vote) => vote.value == 1).length / votes.length * 100).toStringAsFixed(2)} %",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ]),
                        const SizedBox(height: 40),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'task_satisfaction_rate'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "task_no_vote".tr(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ]),
                        const SizedBox(height: 40),
                      ],
                    );
                  }
                } else {
                  return const SizedBox(height: 40);
                }
              }),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'task_detail_proof_visual'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    bytes != null
                        ? Card(
                            child: Image.memory(
                              bytes,
                              width: 300,
                              height: 300,
                            ),
                          )
                        : Text(
                            'task_detail_no_proof'.tr(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black45),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
