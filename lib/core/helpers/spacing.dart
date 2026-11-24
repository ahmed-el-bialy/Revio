// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox verticalSpacing(double height) => SizedBox(height: height.h);

SizedBox horizontalSpacing(double width) => SizedBox(width: width.w);

SliverToBoxAdapter sliverHorizontalSpacing(double width) =>
    SliverToBoxAdapter(child: SizedBox(width: width.w));

SliverToBoxAdapter sliverVerticalSpacing(double height) =>
    SliverToBoxAdapter(child: SizedBox(height: height.h));
