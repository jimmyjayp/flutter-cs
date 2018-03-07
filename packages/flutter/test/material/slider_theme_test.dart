// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart';

import '../rendering/mock_canvas.dart';

void main() {
  testWidgets('Slider theme is built by ThemeData', (WidgetTester tester) async {
    final ThemeData theme = new ThemeData(
      platform: TargetPlatform.android,
      primarySwatch: Colors.red,
    );
    final SliderThemeData sliderTheme = theme.sliderTheme;

    expect(sliderTheme.activeRailColor.value, equals(Colors.red.value));
    expect(sliderTheme.inactiveRailColor.value, equals(Colors.red.withAlpha(0x3d).value));
  });

  testWidgets('Slider uses ThemeData slider theme if present', (WidgetTester tester) async {
    final ThemeData theme = new ThemeData(
      platform: TargetPlatform.android,
      primarySwatch: Colors.red,
    );
    final SliderThemeData sliderTheme = theme.sliderTheme;

    Widget buildSlider(SliderThemeData data) {
      return new Directionality(
        textDirection: TextDirection.ltr,
        child: new Material(
          child: new Center(
            child: new Theme(
              data: theme,
              child: const Slider(
                value: 0.5,
                label: '0.5',
                onChanged: null,
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildSlider(sliderTheme));

    final RenderBox sliderBox = tester.firstRenderObject<RenderBox>(find.byType(Slider));

    expect(
        sliderBox,
        paints
          ..rect(color: sliderTheme.disabledActiveRailColor)
          ..rect(color: sliderTheme.disabledInactiveRailColor));
  });

  testWidgets('Slider overrides ThemeData theme if SliderTheme present',
      (WidgetTester tester) async {
    final ThemeData theme = new ThemeData(
      platform: TargetPlatform.android,
      primarySwatch: Colors.red,
    );
    final SliderThemeData sliderTheme = theme.sliderTheme;
    final SliderThemeData customTheme = sliderTheme.copyWith(
      activeRailColor: Colors.purple,
      inactiveRailColor: Colors.purple.withAlpha(0x3d),
    );

    Widget buildSlider(SliderThemeData data) {
      return new Directionality(
        textDirection: TextDirection.ltr,
        child: new Material(
          child: new Center(
            child: new Theme(
              data: theme,
              child: new SliderTheme(
                data: customTheme,
                child: const Slider(
                  value: 0.5,
                  label: '0.5',
                  onChanged: null,
                ),
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildSlider(sliderTheme));

    final RenderBox sliderBox = tester.firstRenderObject<RenderBox>(find.byType(Slider));

    expect(
        sliderBox,
        paints
          ..rect(color: customTheme.disabledActiveRailColor)
          ..rect(color: customTheme.disabledInactiveRailColor));
  });

  testWidgets('SliderThemeData generates correct opacities for materialDefaults',
      (WidgetTester tester) async {
    const Color customColor1 = const Color(0xcafefeed);
    const Color customColor2 = const Color(0xdeadbeef);
    const Color customColor3 = const Color(0xdecaface);

    final SliderThemeData sliderTheme = new SliderThemeData.materialDefaults(
      primaryColor: customColor1,
      primaryColorDark: customColor2,
      primaryColorLight: customColor3,
    );

    expect(sliderTheme.activeRailColor, equals(customColor1.withAlpha(0xff)));
    expect(sliderTheme.inactiveRailColor, equals(customColor1.withAlpha(0x3d)));
    expect(sliderTheme.disabledActiveRailColor, equals(customColor2.withAlpha(0x52)));
    expect(sliderTheme.disabledInactiveRailColor, equals(customColor2.withAlpha(0x1f)));
    expect(sliderTheme.activeTickMarkColor, equals(customColor3.withAlpha(0x8a)));
    expect(sliderTheme.inactiveTickMarkColor, equals(customColor1.withAlpha(0x8a)));
    expect(sliderTheme.disabledActiveTickMarkColor, equals(customColor3.withAlpha(0x1f)));
    expect(sliderTheme.disabledInactiveTickMarkColor, equals(customColor2.withAlpha(0x1f)));
    expect(sliderTheme.thumbColor, equals(customColor1.withAlpha(0xff)));
    expect(sliderTheme.disabledThumbColor, equals(customColor2.withAlpha(0x52)));
    expect(sliderTheme.overlayColor, equals(customColor1.withAlpha(0x29)));
    expect(sliderTheme.valueIndicatorColor, equals(customColor1.withAlpha(0xff)));
    expect(sliderTheme.thumbShape, equals(const isInstanceOf<RoundSliderThumbShape>()));
    expect(sliderTheme.valueIndicatorShape,
        equals(const isInstanceOf<PaddleSliderValueIndicatorShape>()));
    expect(sliderTheme.showValueIndicator, equals(ShowValueIndicator.onlyForDiscrete));
  });

  testWidgets('SliderThemeData lerps correctly', (WidgetTester tester) async {
    final SliderThemeData sliderThemeBlack = new SliderThemeData.materialDefaults(
      primaryColor: Colors.black,
      primaryColorDark: Colors.black,
      primaryColorLight: Colors.black,
    );
    final SliderThemeData sliderThemeWhite = new SliderThemeData.materialDefaults(
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.white,
    );
    final SliderThemeData lerp = SliderThemeData.lerp(sliderThemeBlack, sliderThemeWhite, 0.5);
    const Color middleGrey = const Color(0xff7f7f7f);
    expect(lerp.activeRailColor, equals(middleGrey.withAlpha(0xff)));
    expect(lerp.inactiveRailColor, equals(middleGrey.withAlpha(0x3d)));
    expect(lerp.disabledActiveRailColor, equals(middleGrey.withAlpha(0x52)));
    expect(lerp.disabledInactiveRailColor, equals(middleGrey.withAlpha(0x1f)));
    expect(lerp.activeTickMarkColor, equals(middleGrey.withAlpha(0x8a)));
    expect(lerp.inactiveTickMarkColor, equals(middleGrey.withAlpha(0x8a)));
    expect(lerp.disabledActiveTickMarkColor, equals(middleGrey.withAlpha(0x1f)));
    expect(lerp.disabledInactiveTickMarkColor, equals(middleGrey.withAlpha(0x1f)));
    expect(lerp.thumbColor, equals(middleGrey.withAlpha(0xff)));
    expect(lerp.disabledThumbColor, equals(middleGrey.withAlpha(0x52)));
    expect(lerp.overlayColor, equals(middleGrey.withAlpha(0x29)));
    expect(lerp.valueIndicatorColor, equals(middleGrey.withAlpha(0xff)));
  });

  testWidgets('Default slider thumb shape draws correctly', (WidgetTester tester) async {
    final ThemeData theme = new ThemeData(
      platform: TargetPlatform.android,
      primarySwatch: Colors.blue,
    );
    final SliderThemeData sliderTheme = theme.sliderTheme.copyWith(thumbColor: Colors.red.shade500);
    double value = 0.45;
    Widget buildApp({
      int divisions,
      bool enabled: true,
    }) {
      final ValueChanged<double> onChanged = enabled ? (double d) => value = d : null;
      return new Directionality(
        textDirection: TextDirection.ltr,
        child: new Material(
          child: new Center(
            child: new SliderTheme(
              data: sliderTheme,
              child: new Slider(
                value: value,
                label: '$value',
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildApp());

    final RenderBox sliderBox = tester.firstRenderObject<RenderBox>(find.byType(Slider));

    expect(sliderBox, paints..circle(color: sliderTheme.thumbColor, radius: 6.0));

    await tester.pumpWidget(buildApp(enabled: false));
    await tester.pump(const Duration(milliseconds: 500)); // wait for disable animation
    expect(sliderBox, paints..circle(color: sliderTheme.disabledThumbColor, radius: 4.0));

    await tester.pumpWidget(buildApp(divisions: 3));
    await tester.pump(const Duration(milliseconds: 500)); // wait for disable animation
    expect(
        sliderBox,
        paints
          ..circle(color: sliderTheme.activeTickMarkColor)
          ..circle(color: sliderTheme.activeTickMarkColor)
          ..circle(color: sliderTheme.inactiveTickMarkColor)
          ..circle(color: sliderTheme.inactiveTickMarkColor)
          ..circle(color: sliderTheme.thumbColor, radius: 6.0));

    await tester.pumpWidget(buildApp(divisions: 3, enabled: false));
    await tester.pump(const Duration(milliseconds: 500)); // wait for disable animation
    expect(
        sliderBox,
        paints
          ..circle(color: sliderTheme.disabledActiveTickMarkColor)
          ..circle(color: sliderTheme.disabledInactiveTickMarkColor)
          ..circle(color: sliderTheme.disabledInactiveTickMarkColor)
          ..circle(color: sliderTheme.disabledThumbColor, radius: 4.0));
  });

  testWidgets('Default slider value indicator shape draws correctly', (WidgetTester tester) async {
    final ThemeData theme = new ThemeData(
      platform: TargetPlatform.android,
      primarySwatch: Colors.blue,
    );
    final SliderThemeData sliderTheme = theme.sliderTheme
        .copyWith(thumbColor: Colors.red.shade500, showValueIndicator: ShowValueIndicator.always);
    Widget buildApp(String value) {
      return new Directionality(
        textDirection: TextDirection.ltr,
        child: new Material(
          child: new Center(
            child: new SliderTheme(
              data: sliderTheme,
              child: new Slider(
                value: 0.5,
                label: '$value',
                divisions: 3,
                onChanged: (double d) {},
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildApp('1'));

    final RenderBox sliderBox = tester.firstRenderObject<RenderBox>(find.byType(Slider));

    Offset center = tester.getCenter(find.byType(Slider));
    TestGesture gesture = await tester.startGesture(center);
    await tester.pump();
    // Wait for value indicator animation to finish.
    await tester.pump(const Duration(milliseconds: 500));
    expect(
        sliderBox,
        paints
          ..path(
            color: sliderTheme.valueIndicatorColor,
            includes: <Offset>[
              const Offset(0.0, -40.0),
              const Offset(15.9, -40.0),
              const Offset(-15.9, -40.0),
            ],
            excludes: <Offset>[const Offset(16.1, -40.0), const Offset(-16.1, -40.0)],
          ));

    await gesture.up();

    // Test that it expands with a larger label.
    await tester.pumpWidget(buildApp('1000'));
    center = tester.getCenter(find.byType(Slider));
    gesture = await tester.startGesture(center);
    await tester.pump();
    // Wait for value indicator animation to finish.
    await tester.pump(const Duration(milliseconds: 500));
    expect(
        sliderBox,
        paints
          ..path(
            color: sliderTheme.valueIndicatorColor,
            includes: <Offset>[
              const Offset(0.0, -40.0),
              const Offset(35.9, -40.0),
              const Offset(-35.9, -40.0),
            ],
            excludes: <Offset>[const Offset(36.1, -40.0), const Offset(-36.1, -40.0)],
          ));
    await gesture.up();
  });
}
