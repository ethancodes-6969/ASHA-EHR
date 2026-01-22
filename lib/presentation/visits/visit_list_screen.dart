import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/visits/visit_list_view_model.dart';
import 'package:asha_ehr/presentation/create_visit/create_visit_screen.dart';

class VisitListScreen extends StatelessWidget {
  final String memberId;
  final String memberName;

  const VisitListScreen({
    super.key,
    required this.memberId,
    required this.memberName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<VisitListViewModel>()..loadVisits(memberId),
      child: _VisitContent(memberId: memberId, memberName: memberName),
    );
  }
}

class _VisitContent extends StatelessWidget {
  final String memberId;
  final String memberName;

  const _VisitContent({required this.memberId, required this.memberName});

  String _formatDate(int millis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis);
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VisitListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Visits: $memberName"),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.visits.isEmpty
              ? const Center(child: Text("No visits recorded."))
              : ListView.builder(
                  itemCount: viewModel.visits.length,
                  itemBuilder: (context, index) {
                    final visit = viewModel.visits[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text("${visit.visitType.name} - ${_formatDate(visit.visitDate)}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (visit.notes != null && visit.notes!.isNotEmpty)
                              Text(visit.notes!, maxLines: 2, overflow: TextOverflow.ellipsis),
                            if (visit.programTags.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Wrap(
                                  spacing: 4,
                                  children: visit.programTags
                                      .map((tag) => Chip(
                                            label: Text(tag, style: const TextStyle(fontSize: 10)),
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
                                          ))
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateVisitScreen(memberId: memberId, memberName: memberName),
            ),
          );
          if (result == true) {
            if (context.mounted) {
              context.read<VisitListViewModel>().loadVisits(memberId);
            }
          }
        },
        child: const Icon(Icons.medical_services_outlined),
      ),
    );
  }
}
