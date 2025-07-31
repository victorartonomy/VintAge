/*

Service States

 */

import '../../domain/entities/service.dart';

abstract class ServiceStates {}

// initial
class ServicesInitial extends ServiceStates {}

// loading..
class ServicesLoading extends ServiceStates {}

// uploading..
class ServicesUploading extends ServiceStates {}

// error
class ServicesError extends ServiceStates {
  final String message;
  ServicesError(this.message);
}

// loaded
class ServicesLoaded extends ServiceStates {
  final List<Service> services;
  ServicesLoaded(this.services);
}