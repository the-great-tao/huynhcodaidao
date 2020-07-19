import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:huynhcodaidao/blocs/audio_controller_state.dart';
import 'package:huynhcodaidao/blocs/audio_controller_bloc.dart';

import 'package:huynhcodaidao/ui_components/linear_gradients.dart';

import 'package:huynhcodaidao/widgets/app_bar_02_widget.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScreen({
    Key key,
    this.title,
    this.body,
  })  : assert(title != null),
        assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      width: 1080,
      height: 1920,
      allowFontScaling: true,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradients.main,
      ),
      child: SafeArea(
        child: BlocBuilder<AudioControllerBloc, AudioControllerState>(
          builder: (BuildContext context, AudioControllerState state) {
            double audioControllerHeight = 180.sp;

            if (state is AudioControllerHiding) {
              audioControllerHeight = 0;
            }

            return Scaffold(
              appBar: AppBar02Widget(
                height: 160.sp,
                title: title,
                audioControllerHeight: audioControllerHeight,
              ),
              body: body,
            );
          },
        ),
      ),
    );
  }
}
