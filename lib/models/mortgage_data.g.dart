// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortgage_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MortgageDataAdapter extends TypeAdapter<MortgageData> {
  @override
  final int typeId = 2;

  @override
  MortgageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MortgageData(
      homeValue: fields[0] as double,
      downPayment: fields[1] as double,
      loanAmount: fields[2] as double,
      loanTerm: fields[3] as double,
      homeIns: fields[5] as double,
      interest: fields[6] as double,
      propertyTax: fields[7] as double,
      pmi: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MortgageData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.homeValue)
      ..writeByte(1)
      ..write(obj.downPayment)
      ..writeByte(2)
      ..write(obj.loanAmount)
      ..writeByte(3)
      ..write(obj.loanTerm)
      ..writeByte(5)
      ..write(obj.homeIns)
      ..writeByte(6)
      ..write(obj.interest)
      ..writeByte(7)
      ..write(obj.propertyTax)
      ..writeByte(8)
      ..write(obj.pmi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MortgageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
