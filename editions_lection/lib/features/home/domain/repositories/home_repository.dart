import 'package:dartz/dartz.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<MaterialEntity>>> getBooks();
  Future<Either<Failure, List<MaterialEntity>>> getPolycopies();
}