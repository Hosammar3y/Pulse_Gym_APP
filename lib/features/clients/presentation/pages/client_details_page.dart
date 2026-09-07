import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../domain/entities/client.dart';
import '../controllers/client_mutation_controller.dart';
import '../providers/clients_providers.dart';

class ClientDetailsPage extends ConsumerWidget {
  const ClientDetailsPage({required this.clientId, super.key});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(clientProvider(clientId));
    final mutation = ref.watch(clientMutationControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Client Profile')),
      body: client.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorState(message:e.toString(),onRetry:()=>ref.invalidate(clientProvider(clientId))),
        data: (c) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Row(children:[CircleAvatar(radius:28,child:Text(c.firstName.isEmpty?'?':c.firstName[0])),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(c.displayName,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),Text('${c.status.name.toUpperCase()} • ${c.goal}')]))]),
            const SizedBox(height:20),
            Wrap(spacing:8,runSpacing:8,children:[
              _Action(label:'Baseline',icon:Icons.photo_camera_back_outlined,onTap:()=>context.push('/clients/$clientId/baseline')),
              _Action(label:'Workout',icon:Icons.fitness_center,onTap:()=>context.push('/clients/$clientId/program/workout')),
              _Action(label:'Diet',icon:Icons.restaurant_outlined,onTap:()=>context.push('/clients/$clientId/program/diet')),
              _Action(label:'Cardio',icon:Icons.directions_run,onTap:()=>context.push('/clients/$clientId/program/cardio')),
              _Action(label:'Progress',icon:Icons.insights,onTap:()=>context.push('/clients/$clientId/progress')),
              _Action(label:'Check-ins',icon:Icons.fact_check_outlined,onTap:()=>context.push('/clients/$clientId/checkins')),
            ]),
            const SizedBox(height:20),
            _Section(title:'Overview',children:[
              _row('Email',c.email),_row('Phone',c.phone?.isNotEmpty==true?c.phone!:'—'),_row('Training level',c.trainingLevel?.name.toUpperCase()??'—'),_row('Subscription','${_date(c.subscriptionStartDate)} → ${_date(c.subscriptionEndDate)}'),_row('Baseline',c.baselineStatus.name.toUpperCase()),
            ]),
            const SizedBox(height:16),
            _Section(title:'Account actions',children:[
              if(c.status==ClientStatus.paused) ListTile(contentPadding:EdgeInsets.zero,title:const Text('Resume client'),trailing:mutation.isLoading?const SizedBox.square(dimension:20,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.play_arrow),onTap:mutation.isLoading?null:()=>ref.read(clientMutationControllerProvider.notifier).resume(c.id))
              else if(c.status==ClientStatus.active) ListTile(contentPadding:EdgeInsets.zero,title:const Text('Pause client'),trailing:mutation.isLoading?const SizedBox.square(dimension:20,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.pause),onTap:mutation.isLoading?null:()=>ref.read(clientMutationControllerProvider.notifier).pause(c.id)),
            ]),
          ],
        ),
      ),
    );
  }
  String _date(DateTime v)=>'${v.year}-${v.month.toString().padLeft(2,'0')}-${v.day.toString().padLeft(2,'0')}';
  Widget _row(String a,String b)=>Padding(padding:const EdgeInsets.symmetric(vertical:6),child:Row(children:[Expanded(child:Text(a)),Text(b,style:const TextStyle(fontWeight:FontWeight.w700))]));
}

class _Action extends StatelessWidget { const _Action({required this.label,required this.icon,required this.onTap}); final String label; final IconData icon; final VoidCallback onTap; @override Widget build(BuildContext context)=>ActionChip(avatar:Icon(icon,size:18),label:Text(label),onPressed:onTap); }
class _Section extends StatelessWidget { const _Section({required this.title,required this.children}); final String title; final List<Widget> children; @override Widget build(BuildContext context)=>Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:8),...children]))); }
