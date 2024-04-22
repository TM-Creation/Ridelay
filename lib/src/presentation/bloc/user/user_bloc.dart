import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ridely/src/infrastructure/local_storage/local_storage.dart';
import 'package:ridely/src/presentation/ui/config/debug_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<CheckIfLoggedIn>(
      ((event, emit) async {
        DebugHelper.printAll("Check if Logged In");
        const totalDuration = 3000;
        emit(ShowSplashScreen());
        await Storage.initialize();
        if (!Storage.containsValue("language")) {
          Storage.setValue("language", "english");
        }

        DebugHelper.printAll(Storage.getValue("language"));

        DebugHelper.printAll('trying prefs');

        try {
          final prefs = await SharedPreferences.getInstance();
          if (!prefs.containsKey('user')) {
            DebugHelper.printAll('pref key not found');

            await Future.delayed(const Duration(milliseconds: totalDuration));
            emit(UserInitial());
          } else {
            // print('pref key found');
            // final userId = prefs.getString("user");
            // // await Future.delayed(Duration(seconds: 1));
            // final user = await _repository.getUser(userId!);
            // final endDate = DateTime.now();
            // final diff = endDate.difference(initialDate).inMilliseconds;
            // print('Difference: $diff');
            // if (diff < totalDuration) {
            //   await Future.delayed(
            //       Duration(milliseconds: totalDuration - diff));
            // }
            // // emit( UserLoggedIn(user: user);
            // emit(UserLoggedIn(user: user));
          }
        } catch (e) {
          emit(UserInitial());
        }
      }),
    );
  }
}
