import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/constants/responsive_utils.dart';
import 'package:dejurebook/pages/user_selection/bloc/user_selection_bloc.dart';
import 'package:dejurebook/pages/user_selection/bloc/user_selection_event.dart';
import 'package:dejurebook/pages/user_selection/bloc/user_selection_state.dart';
import 'package:dejurebook/pages/consumer/consumer_home_page.dart';
import 'package:dejurebook/widgets/user_type_card.dart';
import 'package:dejurebook/widgets/custom_button.dart';

class UserSelection extends StatelessWidget {
  const UserSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSelectionBloc(),
      child: const UserSelectionView(),
    );
  }
}

class UserSelectionView extends StatelessWidget {
  const UserSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserSelectionBloc, UserSelectionState>(
      listener: (context, state) {
        if (state.isCompleted) {
          // Navigate based on selected user type
          if (state.selectedUserType == UserType.consumer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ConsumerHomePage(),
              ),
            );
          }
          // TODO: Add navigation for other user types (lawyer, lawStudent, other)
          print('User type selected: ${state.selectedUserType}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 80)),

                // Title
                Text(
                  "Let's Get To Know You!",
                  style: TextStyle(
                    fontSize:
                        ResponsiveUtils.getResponsiveFontSize(context, 24),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 40)),

                // User Type Cards
                Expanded(
                  child: Padding(
                    padding: ResponsiveUtils.getResponsivePadding(context),
                    child: ListView(
                      children: [
                        UserTypeCard(
                          imagePath: 'assets/images/consumer_image.png',
                          title: "I'm a consumer",
                          userType: UserType.consumer,
                          isSelected:
                              state.selectedUserType == UserType.consumer,
                          onTap: () {
                            context.read<UserSelectionBloc>().add(
                                const SelectUserTypeEvent(UserType.consumer));
                          },
                        ),
                        UserTypeCard(
                          imagePath: 'assets/images/lawyer_image.png',
                          title: "I'm a Lawyer",
                          userType: UserType.lawyer,
                          isSelected: state.selectedUserType == UserType.lawyer,
                          onTap: () {
                            context.read<UserSelectionBloc>().add(
                                const SelectUserTypeEvent(UserType.lawyer));
                          },
                        ),
                        UserTypeCard(
                          imagePath: 'assets/images/law_student_image.png',
                          title: "I'm a law student",
                          userType: UserType.lawStudent,
                          isSelected:
                              state.selectedUserType == UserType.lawStudent,
                          onTap: () {
                            context.read<UserSelectionBloc>().add(
                                const SelectUserTypeEvent(UserType.lawStudent));
                          },
                        ),
                        UserTypeCard(
                          imagePath: 'assets/images/other_user_image.png',
                          title: "Other",
                          userType: UserType.other,
                          isSelected: state.selectedUserType == UserType.other,
                          onTap: () {
                            context
                                .read<UserSelectionBloc>()
                                .add(const SelectUserTypeEvent(UserType.other));
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

                // Continue Button
                CustomButton(
                  text: 'Continue',
                  onPressed: state.canContinue
                      ? () {
                          context
                              .read<UserSelectionBloc>()
                              .add(const ContinueEvent());
                        }
                      : null, // Disabled if no selection
                ),

                SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 30)),
              ],
            ),
          ),
        );
      },
    );
  }
}
