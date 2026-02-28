import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:i_was_there/presentation/add_edit_place/bloc/add_edit_place_bloc.dart';
import 'package:i_was_there/presentation/add_edit_place/bloc/add_edit_place_event.dart';
import 'package:i_was_there/presentation/add_edit_place/bloc/add_edit_place_state.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_form_sheet.dart';

/// Form sheet for add/edit place. Reads [AddEditPlaceBloc] from context.
class AddEditPlaceFormSection extends StatelessWidget {
  const AddEditPlaceFormSection({
    super.key,
    required this.isDark,
    required this.nameController,
    required this.addressController,
    required this.onSave,
  });

  final bool isDark;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditPlaceBloc, AddEditPlaceState>(
      buildWhen: (prev, curr) =>
          prev.locationLoading != curr.locationLoading,
      builder: (context, state) {
        return AddEditPlaceFormSheet(
          isDark: isDark,
          nameController: nameController,
          addressController: addressController,
          locationLoading: state.locationLoading,
          onUseCurrentLocation: () => context.read<AddEditPlaceBloc>().add(
                const AddEditPlaceUseCurrentLocationRequested(),
              ),
          onSearchAddress: () => context.read<AddEditPlaceBloc>().add(
                AddEditPlaceAddressSearchRequested(addressController.text),
              ),
          onSave: onSave,
        );
      },
    );
  }
}
