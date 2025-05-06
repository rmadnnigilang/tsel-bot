import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tsel_bot/blocs/auth_cubit.dart';
import '../blocs/profile_blocs/profile_bloc.dart';
import '../blocs/profile_blocs/profile_state.dart';
import '../blocs/profile_blocs/profile_event.dart';
import '../blocs/package_blocs/package_bloc.dart';
import '../blocs/package_blocs/package_event.dart';
import '../blocs/package_blocs/package_state.dart';

class BuyPackageScreen extends StatelessWidget {
  const BuyPackageScreen({super.key});

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthCubit>().state?.token ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc()..add(FetchProfileData(token)),
        ),
        BlocProvider(
          create:
              (_) =>
                  PackageBloc(token)..add(FetchPackages(page: 1, limit: 100)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Pilih Paket Internet")),
        backgroundColor: const Color(0xFFEAF2FB),
        body: BlocConsumer<PackageBloc, PackageState>(
          listener: (context, state) {
            if (state is PackageBought) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              // Refetch profile untuk update pulsa
              context.read<ProfileBloc>().add(FetchProfileData(token));

              // Kembali ke halaman sebelumnya (Home)
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
              });
            } else if (state is PackageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          builder: (context, packageState) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (packageState is PackageLoading ||
                    profileState is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (packageState is PackageLoaded &&
                    profileState is ProfileLoaded) {
                  final double userPulsa =
                      double.tryParse(
                        profileState.profile['pulsa'].toString(),
                      ) ??
                      0;

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: packageState.packages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            final pkg = packageState.packages[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pkg.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    pkg.description,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Text("Kuota: ${pkg.quota} GB"),
                                  const SizedBox(height: 6),
                                  Text(
                                    formatCurrency(pkg.price),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (pkg.id == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "ID paket tidak tersedia.",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      if (userPulsa < pkg.price) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Pulsa tidak mencukupi.",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      context.read<PackageBloc>().add(
                                        BuyPackage(
                                          packageId: pkg.id.toString(),
                                          paymentMethod: "pulsa",
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0A1D51),
                                      minimumSize: const Size(
                                        double.infinity,
                                        36,
                                      ),
                                    ),
                                    child: const Text("Beli"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Pagination controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (packageState.currentPage > 1)
                            TextButton(
                              onPressed: () {
                                context.read<PackageBloc>().add(
                                  FetchPackages(
                                    page: packageState.currentPage - 1,
                                    limit: 100,
                                  ),
                                );
                              },
                              child: const Text('Previous'),
                            ),
                          Text(
                            'Page ${packageState.currentPage} of ${packageState.totalPages}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (packageState.currentPage <
                              packageState.totalPages)
                            TextButton(
                              onPressed: () {
                                context.read<PackageBloc>().add(
                                  FetchPackages(
                                    page: packageState.currentPage + 1,
                                    limit: 100,
                                  ),
                                );
                              },
                              child: const Text('Next'),
                            ),
                        ],
                      ),
                    ],
                  );
                }

                return const Center(child: Text("Data tidak tersedia."));
              },
            );
          },
        ),
      ),
    );
  }
}
