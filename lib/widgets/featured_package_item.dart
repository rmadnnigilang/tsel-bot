import 'package:flutter/material.dart';
import '../models/featured_package.dart';

class FeaturedPackageItem extends StatelessWidget {
  final FeaturedPackage package;

  const FeaturedPackageItem({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 0,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to detail page
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            package.name,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
