import 'package:app_mobile_plusroom/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/init_view.dart';
import 'package:app_mobile_plusroom/ui-profile/profile_view.dart';
import 'package:app_mobile_plusroom/ui-initial-section/welcome_view.dart';
import '../models/roomie.dart';
import '../pages/clients/ui/client_detail_page.dart';
import '../pages/post_detail.dart';
import '../ui-initial-section/login_view.dart';
import '../ui-initial-section/register_view.dart';
import '../router/routes.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/make_post.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/list_posts.dart';

var customRoutes = <String, WidgetBuilder>{
  LoginView.id: (_) => const LoginView(),
  RegisterView.id: (_) => const RegisterView(),
  InitView.id: (_) => const InitView(),
  WelcomeView.id: (_) => const WelcomeView(tenantId: 1, landlordId: 1), // Provide valid tenantId and landlordId
  ProfileView.id: (context) => ProfileView(tenantId: 1), // Provide valid tenantId
  BottomNavBar.id: (context) => BottomNavBar(tenantId: 1, landlordId: 1), // Provide valid tenantId and landlordId
  MakePost.id: (context) => MakePost(),
  ListPosts.id: (context) => ListPosts(),
  ClientDetailPage.id: (context) {
    final client = ModalRoute.of(context)!.settings.arguments as Tenant?;
    return ClientDetailPage(client: client!);
  },
};