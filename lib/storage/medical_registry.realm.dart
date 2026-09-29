// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_registry.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class HarmfulComponent extends _HarmfulComponent
    with RealmEntity, RealmObjectBase, RealmObject {
  HarmfulComponent(String id, String marker, String description, String risk) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'marker', marker);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'risk', risk);
  }

  HarmfulComponent._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get marker => RealmObjectBase.get<String>(this, 'marker') as String;
  @override
  set marker(String value) => RealmObjectBase.set(this, 'marker', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get risk => RealmObjectBase.get<String>(this, 'risk') as String;
  @override
  set risk(String value) => RealmObjectBase.set(this, 'risk', value);

  @override
  Stream<RealmObjectChanges<HarmfulComponent>> get changes =>
      RealmObjectBase.getChanges<HarmfulComponent>(this);

  @override
  Stream<RealmObjectChanges<HarmfulComponent>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<HarmfulComponent>(this, keyPaths);

  @override
  HarmfulComponent freeze() =>
      RealmObjectBase.freezeObject<HarmfulComponent>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'marker': marker.toEJson(),
      'description': description.toEJson(),
      'risk': risk.toEJson(),
    };
  }

  static EJsonValue _toEJson(HarmfulComponent value) => value.toEJson();
  static HarmfulComponent _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'marker': EJsonValue marker,
        'description': EJsonValue description,
        'risk': EJsonValue risk,
      } =>
        HarmfulComponent(
          fromEJson(id),
          fromEJson(marker),
          fromEJson(description),
          fromEJson(risk),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(HarmfulComponent._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      HarmfulComponent,
      'HarmfulComponent',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('marker', RealmPropertyType.string),
        SchemaProperty('description', RealmPropertyType.string),
        SchemaProperty('risk', RealmPropertyType.string),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
