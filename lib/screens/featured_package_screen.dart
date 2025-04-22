import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/featured_package_blocs/featured_package_bloc.dart';
import '../blocs/featured_package_blocs/featured_package_event.dart';
import '../blocs/featured_package_blocs/featured_package_state.dart';
import '../widgets/featured_package_item.dart';
import '../models/featured_package.dart';

class FeaturedPackageScreen extends StatelessWidget {
  const FeaturedPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeaturedPackageBloc()..add(LoadFeaturedPackages()),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF2FB),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Chip(
                      label: Text("Halo"),
                      backgroundColor: Color(0xFF0A1D51),
                      labelStyle: TextStyle(color: Colors.white),
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
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Usage",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Rp120.000",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Internet Quota",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "38.05 GB",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What package do you want to buy?",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF0A1D51),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // List packages
              Expanded(
                child: BlocBuilder<FeaturedPackageBloc, FeaturedPackageState>(
                  builder: (context, state) {
                    if (state is FeaturedPackageLoaded) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.packages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder:
                            (_, index) => FeaturedPackageItem(
                              package: state.packages[index],
                            ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

              // Search Button (compact)
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  label: const Text("Search Package"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0A1D51),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
