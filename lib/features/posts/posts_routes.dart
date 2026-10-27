import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/posts/ui/screens/post_detail_screen.dart';

final Map<String, WidgetBuilder> postsRoutes = {
  AppRoutes.postDetail: (_) => const PostDetailScreen(),
};
