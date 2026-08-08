import 'package:flutter/material.dart';

class EventStepIndicator extends StatelessWidget {
  final int currentStep;

  const EventStepIndicator({
    super.key,
    required this.currentStep,
  });

  static const List<String> labels = [
    "Information",
    "Venue",
    "Booth",
    "Review",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final isActive = index <= currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isActive
                          ? Colors.orange
                          : Colors.grey.shade300,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isActive
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              if (index != labels.length - 1)
                Expanded(
                  child: Container(
                    margin:
                    const EdgeInsets.only(bottom: 24),
                    height: 3,
                    color: index < currentStep
                        ? Colors.orange
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}