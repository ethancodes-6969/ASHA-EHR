import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/members/member_list_view_model.dart';
import 'package:asha_ehr/presentation/create_member/create_member_screen.dart';
import 'package:asha_ehr/presentation/visits/visit_list_screen.dart';

import 'package:asha_ehr/l10n/app_localizations.dart';

class MemberListScreen extends StatelessWidget {
  final String householdId;
  final String householdName;

  const MemberListScreen({
    super.key,
    required this.householdId,
    required this.householdName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<MemberListViewModel>()..loadMembers(householdId),
      child: _MemberContent(householdId: householdId, householdName: householdName),
    );
  }
}

class _MemberContent extends StatelessWidget {
  final String householdId;
  final String householdName;

  const _MemberContent({required this.householdId, required this.householdName});
  
  String _formatDate(int? millis) {
     if (millis == null) return "Age: N/A";
     final dt = DateTime.fromMillisecondsSinceEpoch(millis);
     return "DOB: ${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MemberListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(householdName),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context)!.membersCount(viewModel.members.length),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ),
      ),
      body: Column(
        children: [
          // 1. Summary & Search Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       _buildStatItem(AppLocalizations.of(context)!.visits, viewModel.visitCount.toString(), Colors.blue),
                       _buildStatItem(AppLocalizations.of(context)!.dueTasks, viewModel.dueCount.toString(), Colors.deepOrange),
                    ],
                  ),
                  const Divider(height: 24),
                  TextField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchMembers,
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (val) => context.read<MemberListViewModel>().setSearchQuery(val),
                  ),
                ],
              ),
            ),
          ),

          // 2. Member List
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.members.isEmpty
                    ? Center(child: Text(AppLocalizations.of(context)!.noMembersFound))
                    : ListView.builder(
                        itemCount: viewModel.members.length,
                        itemBuilder: (context, index) {
                          final member = viewModel.members[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(member.gender),
                            ),
                            title: Text(member.name),
                            subtitle: Text(_formatDate(member.dateOfBirth)),
                            trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                     final result = await Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => CreateMemberScreen(householdId: householdId, member: member),
                                     ));
                                     if (result == true && context.mounted) {
                                        context.read<MemberListViewModel>().loadMembers(householdId);
                                     }
                                  } else if (value == 'archive') {
                                     final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                            title: const Text("Archive Member?"),
                                            content: const Text("This will hide the member and remove them from due lists."),
                                            actions: [
                                              TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(ctx, false)),
                                              TextButton(
                                                  child: const Text("Archive", style: TextStyle(color: Colors.red)),
                                                  onPressed: () => Navigator.pop(ctx, true)
                                              ),
                                            ],
                                        )
                                     );
                                     if (confirm == true && context.mounted) {
                                        context.read<MemberListViewModel>().archiveMember(member.id, householdId);
                                     }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                                  const PopupMenuItem(value: 'archive', child: Text("Archive", style: TextStyle(color: Colors.red))),
                                ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VisitListScreen(
                                    memberId: member.id,
                                    memberName: member.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMemberScreen(householdId: householdId),
            ),
          );
          if (result == true) {
            if (context.mounted) {
              context.read<MemberListViewModel>().loadMembers(householdId);
            }
          }
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
