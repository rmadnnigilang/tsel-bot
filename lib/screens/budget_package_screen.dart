import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/budget_package_blocs/budget_package_bloc.dart';
import '../blocs/budget_package_blocs/budget_package_event.dart';
import '../blocs/budget_package_blocs/budget_package_state.dart';
import '../widgets/budget_package_item.dart';

class BudgetPackageScreen extends StatefulWidget {
  const BudgetPackageScreen({super.key});

  @override
  State<BudgetPackageScreen> createState() => _BudgetPackageScreenState();
}

class _BudgetPackageScreenState extends State<BudgetPackageScreen> {
  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.thumb_up_alt_outlined, "label": "Kamu Banget"},
    {"icon": Icons.public, "label": "Internet"},
    {"icon": Icons.flight, "label": "Roaming"},
    {"icon": Icons.movie, "label": "Entertainment"},
  ];

  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BudgetPackageBloc()..add(LoadBudgetPackages()),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF2FB),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tetap Terhubung\ndi Mana Saja!",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: Color(0xFF0A1D51),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2FB),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.more_horiz,
                              size: 18,
                              color: Colors.black87,
                            ),
                            Container(
                              width: 1,
                              height: 20,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: Colors.black26,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.home_outlined,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Nomor Tujuan (langsung isi)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nomor Tujuan",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: "08111016543"),
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone_android),
                        suffixIcon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD52222),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Cari Paket",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter kategori (opsional mockup)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedCategoryIndex;
                      final category = categories[index];

                      return ChoiceChip(
                        avatar: Icon(
                          category['icon'],
                          size: 18,
                          color:
                              isSelected
                                  ? const Color(0xFF0A1D51)
                                  : Colors.black54,
                        ),
                        label: Text(
                          category['label'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? const Color(0xFF0A1D51)
                                    : Colors.black54,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                        selectedColor: const Color.fromARGB(255, 207, 224, 251),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? Colors.transparent
                                    : Colors.black12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Paket
              Expanded(
                child: BlocBuilder<BudgetPackageBloc, BudgetPackageState>(
                  builder: (context, state) {
                    if (state is BudgetPackageLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: state.packages.length,
                          itemBuilder: (context, index) {
                            return BudgetPackageItem(
                              package: state.packages[index],
                            );
                          },
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
