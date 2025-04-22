// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewStatus {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ViewStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ViewStatus()';
  }
}

/// @nodoc
class $ViewStatusCopyWith<$Res> {
  $ViewStatusCopyWith(ViewStatus _, $Res Function(ViewStatus) __);
}

/// @nodoc

class ViewStatusInitial implements ViewStatus {
  const ViewStatusInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ViewStatusInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ViewStatus.initial()';
  }
}

/// @nodoc

class ViewStatusLoading implements ViewStatus {
  const ViewStatusLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ViewStatusLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ViewStatus.loading()';
  }
}

/// @nodoc

class ViewStatusSuccess implements ViewStatus {
  const ViewStatusSuccess();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ViewStatusSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ViewStatus.success()';
  }
}

/// @nodoc

class ViewStatusFailure implements ViewStatus {
  const ViewStatusFailure(this.error);

  final ViewStatusError error;

  /// Create a copy of ViewStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $ViewStatusFailureCopyWith<ViewStatusFailure> get copyWith =>
      _$ViewStatusFailureCopyWithImpl<ViewStatusFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ViewStatusFailure &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ViewStatus.failure(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ViewStatusFailureCopyWith<$Res>
    implements $ViewStatusCopyWith<$Res> {
  factory $ViewStatusFailureCopyWith(
          ViewStatusFailure value, $Res Function(ViewStatusFailure) _then) =
      _$ViewStatusFailureCopyWithImpl;
  $Res call({ViewStatusError error});
}

/// @nodoc
class _$ViewStatusFailureCopyWithImpl<$Res>
    implements $ViewStatusFailureCopyWith<$Res> {
  _$ViewStatusFailureCopyWithImpl(this._self, this._then);

  final ViewStatusFailure _self;
  final $Res Function(ViewStatusFailure) _then;

  /// Create a copy of ViewStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(ViewStatusFailure(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ViewStatusError,
    ));
  }
}

// dart format on
