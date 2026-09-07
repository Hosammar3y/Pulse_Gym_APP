import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/baseline/presentation/pages/baseline_page.dart';
import '../../features/clients/presentation/pages/add_client_page.dart';
import '../../features/clients/presentation/pages/client_details_page.dart';
import '../../features/clients/presentation/pages/clients_page.dart';
import '../../features/inbox/presentation/pages/inbox_page.dart';
import '../../features/more/presentation/pages/more_page.dart';
import '../../features/notifications/presentation/pages/notification_center_page.dart';
import '../../features/programs/presentation/pages/programs_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../../shared/widgets/app_shell.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/today',
  routes: <RouteBase>[
    GoRoute(path:'/login',name:RouteNames.login,builder:(context,state)=>const LoginPage()),
    StatefulShellRoute.indexedStack(
      builder:(context,state,navigationShell)=>AppShell(navigationShell:navigationShell),
      branches:<StatefulShellBranch>[
        StatefulShellBranch(routes:[GoRoute(path:'/today',name:RouteNames.today,builder:(context,state)=>const TodayPage())]),
        StatefulShellBranch(routes:[GoRoute(path:'/clients',name:RouteNames.clients,builder:(context,state)=>const ClientsPage(),routes:[
          GoRoute(path:'new',builder:(context,state)=>const AddClientPage()),
          GoRoute(path:':clientId',builder:(context,state)=>ClientDetailsPage(clientId:state.pathParameters['clientId']!),routes:[
            GoRoute(path:'baseline',builder:(context,state)=>BaselinePage(clientId:state.pathParameters['clientId']!)),
            GoRoute(path:'program/workout',builder:(context,state)=>_Placeholder(title:'Workout',clientId:state.pathParameters['clientId']!)),
            GoRoute(path:'program/diet',builder:(context,state)=>_Placeholder(title:'Diet',clientId:state.pathParameters['clientId']!)),
            GoRoute(path:'program/cardio',builder:(context,state)=>_Placeholder(title:'Cardio',clientId:state.pathParameters['clientId']!)),
            GoRoute(path:'progress',builder:(context,state)=>_Placeholder(title:'Progress',clientId:state.pathParameters['clientId']!)),
            GoRoute(path:'checkins',builder:(context,state)=>_Placeholder(title:'Check-ins',clientId:state.pathParameters['clientId']!)),
          ]),
        ])]),
        StatefulShellBranch(routes:[GoRoute(path:'/programs',name:RouteNames.programs,builder:(context,state)=>const ProgramsPage())]),
        StatefulShellBranch(routes:[GoRoute(path:'/inbox',name:RouteNames.inbox,builder:(context,state)=>const InboxPage())]),
        StatefulShellBranch(routes:[GoRoute(path:'/more',name:RouteNames.more,builder:(context,state)=>const MorePage(),routes:[GoRoute(path:'notifications',name:RouteNames.notifications,builder:(context,state)=>const NotificationCenterPage())])]),
      ],
    ),
  ],
));

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title,required this.clientId});
  final String title,clientId;
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(title)),body:Center(child:Text('$title for client $clientId — scheduled for later phase')));
}
