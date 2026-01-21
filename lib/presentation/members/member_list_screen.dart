import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/members/member_list_view_model.dart';
import 'package:asha_ehr/presentation/create_member/create_member_screen.dart';
import 'package:asha_ehr/presentation/visits/visit_list_screen.dart';

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
  
  String _formatDate(int millis) {
     final dt = DateTime.fromMillisecondsSinceEpoch(millis);
     return "${dt.day}/${dt.month}/${dt.year}";
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
                "Members: ${viewModel.members.length}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.members.isEmpty
              ? const Center(child: Text("No members added yet."))
              : ListView.builder(
                  itemCount: viewModel.members.length,
                  itemBuilder: (context, index) {
                    final member = viewModel.members[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(member.gender),
                      ),
                      title: Text(member.name),
                      subtitle: Text("DOB: ${_formatDate(member.dateOfBirth)}"),
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
}
