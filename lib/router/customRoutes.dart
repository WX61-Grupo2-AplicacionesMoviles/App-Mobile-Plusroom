import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/init_view.dart';
import 'package:app_mobile_plusroom/ui-profile/profile_view.dart';
import 'package:app_mobile_plusroom/ui-initial-section/welcome_view.dart';
import '../ui-initial-section/login_view.dart';
import '../ui-initial-section/register_view.dart';
import '../router/routes.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/make_post.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/list_posts.dart';

var customRoutes = <String, WidgetBuilder>{
  LoginView.id: (_) => const LoginView(),
  RegisterView.id: (_) => const RegisterView(),
  InitView.id: (_) => const InitView(),
  WelcomeView.id: (_) => const WelcomeView(userId: 1),
  ProfileView.id: (context) => ProfileView(userId: 1),
  BottomNavBar.id: (context) => BottomNavBar(userId: 1),
  MakePost.id: (context) => MakePost(), // Usamos MakePost.id en lugar de 'MakePost'
  ListPosts.id: (context) => ListPosts(), // Usamos ListPosts.id en lugar de 'ListPosts'
};
