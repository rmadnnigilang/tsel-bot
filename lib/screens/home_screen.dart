import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsel_bot/blocs/auth_cubit.dart';
import 'package:tsel_bot/blocs/profile_blocs/profile_bloc.dart';
import 'package:tsel_bot/blocs/profile_blocs/profile_event.dart';
import 'package:tsel_bot/blocs/profile_blocs/profile_state.dart';
import 'package:tsel_bot/main.dart';
import 'package:tsel_bot/models/user_model.dart';
import 'package:tsel_bot/screens/buy_credit_screen.dart';
import 'package:tsel_bot/screens/buy_package_screen.dart';
import 'package:tsel_bot/screens/login_screen.dart';
import 'package:tsel_bot/screens/profile_screen.dart';
import '../blocs/menu_bloc/menu_bloc.dart';
import '../blocs/menu_bloc/menu_event.dart';
import '../blocs/menu_bloc/menu_state.dart';
import '../repositories/menu_repository.dart';
import '../widgets/menu_button.dart';
import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

class HomeScreen extends StatefulWidget {
  final MenuRepository menuRepository;

  const HomeScreen({Key? key, required this.menuRepository}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    final token = authCubit.state?.token;
    _profileBloc = ProfileBloc();
    if (token != null) {
      _profileBloc.add(FetchProfileData(token));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Triggered when returning back to this screen
    final token = context.read<AuthCubit>().state?.token;
    if (token != null) {
      _profileBloc.add(FetchProfileData(token));
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MenuBloc(widget.menuRepository)..add(LoadMenu()),
        ),
        BlocProvider.value(value: _profileBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthCubit, User?>(
            builder: (context, user) {
              final isLoggedIn = user != null;

              // Refetch ulang di build jika user login berubah
              if (isLoggedIn) {
                final token = user.token;
                if (token != null) {
                  _profileBloc.add(FetchProfileData(token));
                }
              }
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0A1D51),
                          Color(0xFF1B1F60),
                          Color(0xFFE50914),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isLoggedIn) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Chip(
                                    label: Text(
                                      "Halo",
                                      style: TextStyle(
                                        color: Color(0xFF0A1D51),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.msisdn ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.more_horiz, color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 20),

                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is ProfileLoaded) {
                                final profile = state.profile;
                                final totalUsage = profile['total_usage'] ?? 0;
                                final quota = profile['quota'] ?? '0 GB';

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProfileScreen(),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF11265E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Pulsa",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              formatCurrency(
                                                num.tryParse(
                                                      profile['pulsa']
                                                          .toString(),
                                                    ) ??
                                                    0,
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "Kuota",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  "${profile['remaining_quota'] ?? '0'} GB",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (state is ProfileLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox(); // fallback jika error atau belum ada data
                            },
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const BuyCreditScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.phone_android,
                                    size: 18,
                                  ),
                                  label: const Text("Beli Pulsa"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0A1D51),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const BuyPackageScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.shopping_bag,
                                    size: 18,
                                  ),
                                  label: const Text("Beli Paket"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF0A1D51),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const Text(
                            "Welcome to MyTelkomsel Basic!",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Log in to access the menu below",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // sisanya tetap pakai Expanded dan ListView menu
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF2FB),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: BlocBuilder<MenuBloc, MenuState>(
                        builder: (context, state) {
                          if (state is MenuLoaded) {
                            final grouped = <String, List<String>>{};
                            for (var item in state.items) {
                              grouped
                                  .putIfAbsent(item.category, () => [])
                                  .add(item.title);
                            }

                            return ListView(
                              children:
                                  grouped.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Color(0xFF0A1D51),
                                            ),
                                          ),
                                        ),
                                        ...entry.value.map(
                                          (title) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: MenuButton(title: title),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    );
                                  }).toList(),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
