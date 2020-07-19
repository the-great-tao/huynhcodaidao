import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:huynhcodaidao/blocs/audio_controller_state.dart';
import 'package:huynhcodaidao/blocs/audio_controller_bloc.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';
import 'package:huynhcodaidao/widgets/app_bar_widget.dart';

final GetIt getIt = GetIt.instance;

class AppBar02Widget extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final double audioControllerHeight;

  const AppBar02Widget({
    Key key,
    @required this.height,
    @required this.title,
    @required this.audioControllerHeight,
  })  : assert(height != null),
        assert(title != null),
        assert(audioControllerHeight != null);

  @override
  Size get preferredSize => Size.fromHeight(height + audioControllerHeight);

  @override
  State createState() => _AppBar02WidgetState();
}

class _AppBar02WidgetState extends State<AppBar02Widget> {
  final AssetsAudioPlayer _assetsAudioPlayer = getIt.get<AssetsAudioPlayer>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocBuilder<AudioControllerBloc, AudioControllerState>(
          builder: (BuildContext context, AudioControllerState state) {
            if (state is AudioControllerHiding) {
              return Container();
            }

            return Column(
              children: <Widget>[
                SizedBox(
                  height: widget.height,
                ),
                Container(
                  width: 1080.w,
                  height: widget.audioControllerHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
//                        Color.fromRGBO(208, 246, 255, 1),
//                        Color.fromRGBO(255, 237, 237, 1),
//                        Color.fromRGBO(255, 255, 231, 1),
                        Color.fromRGBO(92, 121, 255, 1),
                        Color.fromRGBO(76, 221, 242, 1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.h,
                        spreadRadius: 2.h,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _assetsAudioPlayer.builderIsPlaying(
                      builder: (context, isPlaying) {
                        return isPlaying
                            ? GestureDetector(
                                onTap: () {
                                  _assetsAudioPlayer.pause();
                                },
                                child: Icon(
                                  FontAwesome.pause,
                                  color: Colors.white,
                                  size: 100.sp,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _assetsAudioPlayer.play();
                                },
                                child: Icon(
                                  FontAwesome.play,
                                  color: Colors.white,
                                  size: 100.sp,
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        AppBarWidget(
          height: widget.height,
          child: Center(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsetsResponsive.fromLTRB(40, 20, 40, 20),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 80.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.robotoSlab(
                      color: Colors.white,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home/',
                    (route) => false,
                  ),
                  child: Container(
                    padding: EdgeInsetsResponsive.fromLTRB(40, 20, 40, 20),
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 80.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradients.main,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.h,
                spreadRadius: 2.h,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
