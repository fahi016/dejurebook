import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dejurebook/services/profile_service.dart';
import 'package:dejurebook/services/lawyer_profile_service.dart';
import 'package:dejurebook/services/supabase_config.dart';
import 'package:dejurebook/models/lawyer_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfileDataEvent>(_onLoadProfileData);
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<SendMessageEvent>(_onSendMessage);
    on<BecomeCreatorEvent>(_onBecomeCreator);
  }

  Future<void> _onLoadProfileData(
      LoadProfileDataEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Get current user
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) {
        emit(state.copyWith(
          isLoading: false,
          error: 'No authenticated user',
        ));
        return;
      }

      // Fetch user profile
      final userProfile = await ProfileService.getCurrentUserProfile();
      
      if (userProfile == null) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Profile not found',
        ));
        return;
      }

      // Format join date
      String? joinDate;
      if (userProfile.createdAt != null) {
        final months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        joinDate = '${months[userProfile.createdAt!.month - 1]} ${userProfile.createdAt!.year}';
      }

      // Check if user is a lawyer and fetch lawyer profile
      LawyerProfile? lawyerProfile;
      if (userProfile.profession?.toLowerCase() == 'lawyer') {
        lawyerProfile = await LawyerProfileService.fetchProfile(user.id);
      }

      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          userProfile: userProfile,
          lawyerProfile: lawyerProfile,
          name: userProfile.fullName,
          profession: userProfile.profession,
          joinDate: joinDate,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to load profile: $e',
        ));
      }
    }
  }

  void _onFollowUser(FollowUserEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      isFollowing: true,
      followersCount: state.followersCount + 1,
    ));
  }

  void _onUnfollowUser(UnfollowUserEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      isFollowing: false,
      followersCount: state.followersCount - 1,
    ));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ProfileState> emit) {
    // This would typically navigate to messages screen
    // For now, we'll just emit the same state
    emit(state);
  }

  void _onBecomeCreator(BecomeCreatorEvent event, Emitter<ProfileState> emit) {
    // This would typically navigate to creator registration screen
    // For now, we'll just emit the same state
    emit(state);
  }
}
