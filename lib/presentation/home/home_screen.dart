import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asha_ehr/core/di/service_locator.dart';
import 'package:asha_ehr/presentation/home/home_view_model.dart';
import 'package:asha_ehr/presentation/create_household/create_household_screen.dart';
import 'package:asha_ehr/presentation/members/member_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<HomeViewModel>()..loadHouseholds(),
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHA EHR - Households'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search Households",
                hintText: "Name or Location",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<HomeViewModel>().setSearchQuery(val),
            ),
          ),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.households.isEmpty
                    ? const Center(child: Text("No results found."))
                    : ListView.builder(
                        itemCount: viewModel.households.length,
                        itemBuilder: (context, index) {
                          final household = viewModel.households[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: const Icon(Icons.home),
                              title: Text(
                                household.familyHeadName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(household.locationDescription),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                      final result = await Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => CreateHouseholdScreen(household: household),
                                      ));
                                      if (result == true && context.mounted) {
                                        context.read<HomeViewModel>().loadHouseholds();
                                      }
                                  } else if (value == 'archive') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Archive Household?"),
                                          content: const Text("This will hide the household and its members. It can be restored by admin only."),
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
                                        context.read<HomeViewModel>().archiveHousehold(household.id);
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
                                    builder: (context) => MemberListScreen(
                                      householdId: household.id,
                                      householdName: household.familyHeadName,
                                    ),
                                  ),
                                );
                              },
                            ),
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
            MaterialPageRoute(builder: (context) => const CreateHouseholdScreen()),
          );
          if (result == true) {
            if (context.mounted) {
              context.read<HomeViewModel>().loadHouseholds();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
