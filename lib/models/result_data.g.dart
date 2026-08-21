// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultDataAdapter extends TypeAdapter<ResultData> {
  @override
  final typeId = 3;

  @override
  ResultData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResultData(
      monthlyPayment: fields[0] as String?,
      biWeeklyPayment: fields[1] as String?,
      lastPayment: fields[2] as String?,
      biWeeklyLastPayment: fields[3] as String?,
      totalInterest: fields[4] as String?,
      biWeeklyTotalInterest: fields[5] as String?,
      monthlyTax: fields[6] as String?,
      monthlyIns: fields[7] as String?,
      monthlyPmi: fields[8] as String?,
      totalPmi: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ResultData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.monthlyPayment)
      ..writeByte(1)
      ..write(obj.biWeeklyPayment)
      ..writeByte(2)
      ..write(obj.lastPayment)
      ..writeByte(3)
      ..write(obj.biWeeklyLastPayment)
      ..writeByte(4)
      ..write(obj.totalInterest)
      ..writeByte(5)
      ..write(obj.biWeeklyTotalInterest)
      ..writeByte(6)
      ..write(obj.monthlyTax)
      ..writeByte(7)
      ..write(obj.monthlyIns)
      ..writeByte(8)
      ..write(obj.monthlyPmi)
      ..writeByte(9)
      ..write(obj.totalPmi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
