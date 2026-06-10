import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user.dart';
import '../providers/auth_providers.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  static const List<User> mockUsers = [
    User(
      id: 'john-doe-id',
      name: 'John Doe',
      email: 'john.doe@example.com',
    ),
    User(
      id: 'jane-smith-id',
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
    ),
    User(
      id: 'mike-johnson-id',
      name: 'Mike Johnson',
      email: 'mike.johnson@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.bolt_rounded,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // App Title
                  Text(
                    'QuickSlot',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    'Select a profile below to start booking sports courts instantly',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // User Cards
                  ...mockUsers.map((user) {
                    final initials = user.name.split(' ').map((e) => e[0]).join('');
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155).withOpacity(0.5) // Slate 700
                                : const Color(0xFFE2E8F0), // Slate 200
                            width: 1,
                          ),
                        ),
                        color: isDark ? const Color(0xFF1E293B) : Colors.white, // Slate 800
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            ref.read(currentUserProvider.notifier).setUser(user);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                            child: Row(
                              children: [
                                // Avatar circle
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // User info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Arrow icon
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.colorScheme.primary.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
