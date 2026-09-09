import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/child_model.dart';
import '../../providers/children_provider.dart';
import '../../widgets/child_list_item.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_error_widgets.dart';
import 'add_child_screen.dart';
import 'child_details_screen.dart';

class ChildrenListScreen extends StatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  State<ChildrenListScreen> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChildrenProvider>(context, listen: false).fetchChildren();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDeleteChild(ChildModel child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الطفل "${child.fullName}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final provider = Provider.of<ChildrenProvider>(context, listen: false);
              final success = await provider.deleteChild(child.id);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف الطفل بنجاح')),
                );
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final childrenProvider = Provider.of<ChildrenProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.children,
        showBackButton: true,
        showAddButton: true,
        onAdd: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddChildScreen()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Row with cartoon kids artwork matching XD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Kids Banner Graphic on the left
                  _buildMiniKidsBanner(),
                  const SizedBox(width: 12),
                  // Search Field
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.primaryLight, width: 1.5),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => childrenProvider.setSearchQuery(val),
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          hintText: AppStrings.searchChildHint,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          suffixIcon: Icon(Icons.person_search_rounded, color: Colors.black87),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          filled: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Children List Items
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => childrenProvider.fetchChildren(),
child: childrenProvider.children.isEmpty
    ? const EmptyDataWidget(message: 'لا يوجد أطفال مسجلين حالياً')
    
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: childrenProvider.children.length,
                                itemBuilder: (context, index) {
                                  final child = childrenProvider.children[index];
                                  return ChildListItem(
                                    child: child,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ChildDetailsScreen(child: child),
                                        ),
                                      );
                                    },
                                    onEdit: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AddChildScreen(childToEdit: child),
                                        ),
                                      );
                                    },
                                    onDelete: () => _confirmDeleteChild(child),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniKidsBanner() {
    return Container(
      width: 60,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC80), width: 1.2),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.face_3_rounded, size: 22, color: Colors.pink),
          Icon(Icons.face_rounded, size: 22, color: Colors.blue),
        ],
      ),
    );
  }
}
