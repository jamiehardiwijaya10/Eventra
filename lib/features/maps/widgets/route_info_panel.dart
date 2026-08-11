import 'package:eventra/features/maps/navigation/models/route_state.dart';
import 'package:eventra/features/maps/providers/route_provider.dart';
import 'package:eventra/features/maps/providers/search_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteInfoPanel extends ConsumerWidget{
  const RouteInfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeProvider);
    final place = ref.watch(selectedPlaceProvider);

    if (route.status == NavigationStatus.idle || route.status == NavigationStatus.loading) {
      return const SizedBox.shrink();
    }

    final isNavigating = route.status == NavigationStatus.navigating;
    final isArrived = route.status == NavigationStatus.arrived;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isArrived
                ? Colors.green
                : isNavigating
                ? Colors.blue
                : Colors.blueAccent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),

            child: Row(
              children: [
                Icon(
                  isArrived
                    ? Icons.check_circle_rounded
                    : isNavigating
                    ? Icons.navigation_rounded
                    : Icons.route_rounded,
                  color: Colors.white,
                  size: 20,
                ),

                const SizedBox(width: 8,),

                Expanded(
                  child: Text(
                    isArrived
                      ? 'You have arrived!'
                      : isNavigating
                      ? 'Navigating...'
                      : 'Route ready',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),

                if (!isArrived && !isNavigating) ... [
                  const SizedBox(width: 8,),

                  SizedBox(
                    width: 80,
                    child: ElevatedButton.icon(
                      onPressed: () => ref
                        .read(routeProvider.notifier)
                        .startNavigation(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                      ),
                    ),
                  )
                ],

                IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => ref.read(routeProvider.notifier).clearRoute(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.straighten_rounded,
                        label: route.status == NavigationStatus.navigating
                          ? 'Remaining'
                          : 'Distance',
                        value: route.status == NavigationStatus.navigating
                          ? route.remainingDistanceText
                          : route.distanceText,
                        color: Colors.blue,
                      ),
                    ),
                    
                    const SizedBox(width: 12,),

                    Expanded(
                      child: _Stat(
                        icon: Icons.access_time_rounded,
                        label: route.status == NavigationStatus.navigating
                          ? 'ETA'
                          : 'Duration',
                        value: route.status == NavigationStatus.navigating
                          ? route.remainingDurationText
                          : route.durationText,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        
        const SizedBox(width: 8),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}