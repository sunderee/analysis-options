import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

const DeepCollectionEquality _equality = DeepCollectionEquality();

@immutable
abstract class Equatable {
  const Equatable();

  List<Object?> get props;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Equatable &&
          runtimeType == other.runtimeType &&
          _equals(props, other.props);

  @override
  int get hashCode => runtimeType.hashCode ^ _finish(props.fold(0, _combine));

  @override
  String toString() =>
      '$runtimeType(${props.map((prop) => prop.toString()).join(', ')})';
}

bool _equals(List<Object?>? list1, List<Object?>? list2) {
  if (identical(list1, list2)) {
    return true;
  }

  if (list1 == null || list2 == null) {
    return false;
  }

  final length = list1.length;
  if (length != list2.length) {
    return false;
  }

  for (var i = 0; i < length; i++) {
    final unit1 = list1[i];
    final unit2 = list2[i];

    if (_isEquatable(unit1) && _isEquatable(unit2)) {
      if (unit1 != unit2) {
        return false;
      }
    } else if (unit1 is Iterable || unit1 is Map) {
      if (!_equality.equals(unit1, unit2)) {
        return false;
      }
    } else if (unit1?.runtimeType != unit2?.runtimeType) {
      return false;
    } else if (unit1 != unit2) {
      return false;
    }
  }

  return true;
}

bool _isEquatable(Object? object) {
  return object is Equatable;
}

int _combine(int hash, Object? object) {
  if (object is Map) {
    object.keys
        .sorted((Object? a, Object? b) => a.hashCode - b.hashCode)
        .forEach((Object? key) {
      hash = hash ^ _combine(hash, [key, (object! as Map)[key]]);
    });

    return hash;
  }

  if (object is Set) {
    object = object.sorted((Object? a, Object? b) => a.hashCode - b.hashCode);
  }

  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }

    return hash ^ object.length;
  }

  hash = 0x1fffffff & (hash + object.hashCode);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
