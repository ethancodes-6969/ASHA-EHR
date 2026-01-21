import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/due_list/due_list_view_model.dart';
import 'package:asha_ehr/presentation/visits/visit_list_screen.dart';

class DueListScreen extends StatelessWidget {
  const DueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DueListViewModel>()..loadItems(),
      child: const _DueListContent(),
    );
  }
}

class _DueListContent extends StatelessWidget {
  const _DueListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DueListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Due Tasks")),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.items.isEmpty
              ? const Center(child: Text("All caught up! No due tasks."))
              : ListView.builder(
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getColorForCategory(item.coreCategory),
                          child: Text(item.coreCategory[0]),
                        ),
                        title: Text("${item.memberName} (${item.programTag})"),
                        subtitle: Text(item.householdLocation ?? "Unknown Location"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                           // Navigate to Visit List for that member
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => VisitListScreen(
                               memberId: item.memberId,
                               memberName: item.memberName,
                             ))
                           );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'CHILD': return Colors.lightBlueAccent;
      case 'MATERNAL': return Colors.pinkAccent;
      case 'ROUTINE': return Colors.greenAccent;
      default: return Colors.grey;
    }
  }
}
