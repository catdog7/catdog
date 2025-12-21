import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_dependency.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) => Supabase.instance.client;
