// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortgage_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MortgageDataAdapter extends TypeAdapter<MortgageData> {
  @override
  final typeId = 2;

  @override
  MortgageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MortgageData(
      homeValue: (fields[0] as num?)?.toDouble(),
      downPayment: (fields[1] as num?)?.toDouble(),
      loanAmount: (fields[2] as num?)?.toDouble(),
      loanTerm: (fields[3] as num?)?.toDouble(),
      homeIns: (fields[5] as num?)?.toDouble(),
      interest: (fields[6] as num?)?.toDouble(),
      propertyTax: (fields[7] as num?)?.toDouble(),
      pmi: (fields[8] as num?)?.toDouble(),
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
