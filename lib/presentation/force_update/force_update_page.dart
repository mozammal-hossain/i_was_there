import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../core/force_update/force_update_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/url_launcher/url_launcher_service.dart';
import 'bloc/force_update_bloc.dart';
import 'bloc/force_update_event.dart';
import 'bloc/force_update_state.dart';

/// Full-screen page shown when a force update is required.
/// User must tap Update to open the store; no skip option.
/// All logic (open store) is in [ForceUpdateBloc]; this widget only dispatches and renders.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForceUpdateBloc(
        forceUpdateService: getIt<ForceUpdateService>(),
        urlLauncherService: getIt<UrlLauncherService>(),
      ),
      child: const _ForceUpdateView(),
    );
  }
}

class _ForceUpdateView extends StatelessWidget {
  const _ForceUpdateView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<ForceUpdateBloc, ForceUpdateState>(
      listenWhen: (prev, curr) => curr.status == ForceUpdateStatus.openFailed,
      listener: (context, state) {
        if (state.openStoreError != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.openStoreError!)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Icon(
                  Icons.system_update,
                  size: AppSize.iconXl4,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSize.spacingXl),
                Text(
                  'Update required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSize.spacingM3),
                Text(
                  'A new version of I Was There is required. Please update to continue.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 2),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.read<ForceUpdateBloc>().add(
                          const ForceUpdateOpenStoreRequested(),
                        ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.spacingL,
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                ),
                const SizedBox(height: AppSize.spacingXl3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
