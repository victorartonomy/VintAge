import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import '../cubits/service_cubit.dart';

class RatingWidget extends StatefulWidget {
  final Service service;
  final bool showRatingDialog;
  final double size;
  final Color? color;

  const RatingWidget({
    super.key,
    required this.service,
    this.showRatingDialog = false,
    this.size = 20.0,
    this.color,
  });

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late final serviceCubit = context.read<ServiceCubit>();
  AppUser? currentUser;
  int? userRating;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserRating();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> getUserRating() async {
    if (currentUser != null) {
      final rating = await serviceCubit.getUserRating(
        widget.service.id,
        currentUser!.uid,
      );
      setState(() {
        userRating = rating;
      });
    }
  }

  void _showRatingDialog() {
    if (currentUser == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRating = userRating ?? 0;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Rate this service'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How would you rate this service?'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  Text(
                    selectedRating > 0
                        ? '$selectedRating star${selectedRating > 1 ? 's' : ''}'
                        : 'Select rating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      selectedRating > 0
                          ? () async {
                            Navigator.of(context).pop();
                            await _rateService(selectedRating);
                          }
                          : null,
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _rateService(int rating) async {
    if (currentUser == null) return;

    try {
      await serviceCubit.rateService(
        widget.service.id,
        currentUser!.uid,
        rating,
      );
      setState(() {
        userRating = rating;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rating submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit rating: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final averageRating = widget.service.averageRating;
    final totalRatings = widget.service.userRatings.length;
    final color = widget.color ?? Colors.amber;

    return GestureDetector(
      onTap: widget.showRatingDialog ? _showRatingDialog : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display stars based on average rating
          ...List.generate(5, (index) {
            if (index < averageRating.floor()) {
              // Full star
              return Icon(Icons.star, color: color, size: widget.size);
            } else if (index == averageRating.floor() &&
                averageRating % 1 > 0) {
              // Half star
              return Icon(Icons.star_half, color: color, size: widget.size);
            } else {
              // Empty star
              return Icon(Icons.star_border, color: color, size: widget.size);
            }
          }),
          SizedBox(width: 8),
          // Show rating text
          Text(
            averageRating > 0 ? averageRating.toStringAsFixed(1) : 'No ratings',
            style: TextStyle(
              fontSize: widget.size * 0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (totalRatings > 0) ...[
            SizedBox(width: 4),
            Text(
              '($totalRatings)',
              style: TextStyle(fontSize: widget.size * 0.5, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
