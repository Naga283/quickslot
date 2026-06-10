import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/venues/presentation/views/venue_list_view.dart';
import '../../features/venues/presentation/views/venue_detail_view.dart';
import '../../features/bookings/presentation/views/my_bookings_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Watch the current user state to trigger router rebuilds reactively on login/logout
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: user == null ? '/login' : '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const VenueListView(),
      ),
      GoRoute(
        path: '/venues/:id',
        name: 'venue-detail',
        builder: (context, state) => VenueDetailView(
          venueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const MyBookingsView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = user != null;
      final isLoggingIn = state.uri.path == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}
