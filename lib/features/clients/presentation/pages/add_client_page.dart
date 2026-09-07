import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/client.dart';
import '../controllers/client_mutation_controller.dart';

class AddClientPage extends ConsumerStatefulWidget {
  const AddClientPage({super.key});
  @override
  ConsumerState<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends ConsumerState<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  final first = TextEditingController(), last = TextEditingController(), email = TextEditingController(), phone = TextEditingController(), goal = TextEditingController();
  DateTime start = DateTime.now(), end = DateTime.now().add(const Duration(days: 30));
  TrainingLevel? level = TrainingLevel.beginner;
  BaselineRequirement baseline = BaselineRequirement.optional;

  @override
  void dispose(){ for(final c in [first,last,email,phone,goal]){c.dispose();} super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(clientMutationControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Client')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text('Personal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            TextFormField(controller:first,decoration:const InputDecoration(labelText:'First name'),validator:_required),
            TextFormField(controller:last,decoration:const InputDecoration(labelText:'Last name'),validator:_required),
            TextFormField(controller:email,decoration:const InputDecoration(labelText:'Email'),keyboardType:TextInputType.emailAddress,validator:_required),
            TextFormField(controller:phone,decoration:const InputDecoration(labelText:'Phone')),
            const SizedBox(height:20),
            const Text('Coaching', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            TextFormField(controller:goal,decoration:const InputDecoration(labelText:'Goal'),validator:_required),
            DropdownButtonFormField<TrainingLevel>(value:level,decoration:const InputDecoration(labelText:'Training level'),items:TrainingLevel.values.map((e)=>DropdownMenuItem(value:e,child:Text(e.name))).toList(),onChanged:(v)=>setState(()=>level=v)),
            const SizedBox(height:20),
            const Text('Subscription & onboarding', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            ListTile(title:const Text('Start date'),subtitle:Text(_date(start)),trailing:const Icon(Icons.calendar_today),onTap:()=>_pick(true)),
            ListTile(title:const Text('End date'),subtitle:Text(_date(end)),trailing:const Icon(Icons.calendar_today),onTap:()=>_pick(false)),
            DropdownButtonFormField<BaselineRequirement>(value:baseline,decoration:const InputDecoration(labelText:'Starting baseline'),items:const [DropdownMenuItem(value:BaselineRequirement.optional,child:Text('Optional')),DropdownMenuItem(value:BaselineRequirement.required,child:Text('Required'))],onChanged:(v)=>setState(()=>baseline=v ?? baseline)),
            const SizedBox(height:24),
            FilledButton(
              onPressed: mutation.isLoading ? null : () async {
                if(!_formKey.currentState!.validate()) return;
                final client = await ref.read(clientMutationControllerProvider.notifier).create(CreateClientInput(firstName:first.text.trim(),lastName:last.text.trim(),email:email.text.trim(),phone:phone.text.trim(),goal:goal.text.trim(),trainingLevel:level,subscriptionStartDate:start,subscriptionEndDate:end,baselineRequirement:baseline));
                if(mounted && client != null) context.go('/clients/${client.id}');
              },
              child: Text(mutation.isLoading ? 'Creating…' : 'Create Client'),
            ),
            if(mutation.hasError) Padding(padding:const EdgeInsets.only(top:12),child:Text(mutation.error.toString(),style:TextStyle(color:Theme.of(context).colorScheme.error))),
          ],
        ),
      ),
    );
  }

  String? _required(String? value)=>value==null||value.trim().isEmpty?'Required':null;
  String _date(DateTime v)=>'${v.year}-${v.month.toString().padLeft(2,'0')}-${v.day.toString().padLeft(2,'0')}';
  Future<void> _pick(bool isStart) async { final current=isStart?start:end; final picked=await showDatePicker(context:context,initialDate:current,firstDate:DateTime(2020),lastDate:DateTime(2100)); if(picked!=null)setState((){if(isStart)start=picked;else end=picked;}); }
}
