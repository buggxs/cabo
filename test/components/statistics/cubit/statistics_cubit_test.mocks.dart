// Mocks generated by Mockito 5.4.4 from annotations
// in cabo/test/components/statistics/cubit/statistics_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:cabo/core/app_navigator/navigation_service.dart' as _i10;
import 'package:cabo/domain/game/game.dart' as _i4;
import 'package:cabo/domain/game/game_service.dart' as _i12;
import 'package:cabo/domain/game/local_game_repository.dart' as _i5;
import 'package:cabo/domain/player/data/player.dart' as _i9;
import 'package:cabo/domain/rule_set/data/rule_set.dart' as _i2;
import 'package:cabo/domain/rule_set/rules_service.dart' as _i6;
import 'package:cabo/misc/utils/dialogs.dart' as _i7;
import 'package:flutter/material.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeRuleSet_0 extends _i1.SmartFake implements _i2.RuleSet {
  _FakeRuleSet_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGlobalKey_1<T extends _i3.State<_i3.StatefulWidget>>
    extends _i1.SmartFake implements _i3.GlobalKey<T> {
  _FakeGlobalKey_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGame_2 extends _i1.SmartFake implements _i4.Game {
  _FakeGame_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocalGameRepository_3 extends _i1.SmartFake
    implements _i5.LocalGameRepository {
  _FakeLocalGameRepository_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LocalRuleService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalRuleService extends _i1.Mock implements _i6.LocalRuleService {
  @override
  _i2.RuleSet loadRuleSet({bool? useOwnRules = false}) => (super.noSuchMethod(
        Invocation.method(
          #loadRuleSet,
          [],
          {#useOwnRules: useOwnRules},
        ),
        returnValue: _FakeRuleSet_0(
          this,
          Invocation.method(
            #loadRuleSet,
            [],
            {#useOwnRules: useOwnRules},
          ),
        ),
        returnValueForMissingStub: _FakeRuleSet_0(
          this,
          Invocation.method(
            #loadRuleSet,
            [],
            {#useOwnRules: useOwnRules},
          ),
        ),
      ) as _i2.RuleSet);
}

/// A class which mocks [StatisticsDialogService].
///
/// See the documentation for Mockito's code generation for more information.
class MockStatisticsDialogService extends _i1.Mock
    implements _i7.StatisticsDialogService {
  @override
  _i8.Future<Map<String, int?>?> showPointDialog(List<_i9.Player>? players) =>
      (super.noSuchMethod(
        Invocation.method(
          #showPointDialog,
          [players],
        ),
        returnValue: _i8.Future<Map<String, int?>?>.value(),
        returnValueForMissingStub: _i8.Future<Map<String, int?>?>.value(),
      ) as _i8.Future<Map<String, int?>?>);

  @override
  _i8.Future<bool?> showEndGame(_i3.BuildContext? context) =>
      (super.noSuchMethod(
        Invocation.method(
          #showEndGame,
          [context],
        ),
        returnValue: _i8.Future<bool?>.value(),
        returnValueForMissingStub: _i8.Future<bool?>.value(),
      ) as _i8.Future<bool?>);

  @override
  _i8.Future<_i9.Player?> showRoundCloserDialog({List<_i9.Player>? players}) =>
      (super.noSuchMethod(
        Invocation.method(
          #showRoundCloserDialog,
          [],
          {#players: players},
        ),
        returnValue: _i8.Future<_i9.Player?>.value(),
        returnValueForMissingStub: _i8.Future<_i9.Player?>.value(),
      ) as _i8.Future<_i9.Player?>);

  @override
  _i8.Future<bool?> loadNotFinishedGame() => (super.noSuchMethod(
        Invocation.method(
          #loadNotFinishedGame,
          [],
        ),
        returnValue: _i8.Future<bool?>.value(),
        returnValueForMissingStub: _i8.Future<bool?>.value(),
      ) as _i8.Future<bool?>);
}

/// A class which mocks [NavigationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationService extends _i1.Mock implements _i10.NavigationService {
  @override
  _i3.GlobalKey<_i3.NavigatorState> get navigatorKey => (super.noSuchMethod(
        Invocation.getter(#navigatorKey),
        returnValue: _FakeGlobalKey_1<_i3.NavigatorState>(
          this,
          Invocation.getter(#navigatorKey),
        ),
        returnValueForMissingStub: _FakeGlobalKey_1<_i3.NavigatorState>(
          this,
          Invocation.getter(#navigatorKey),
        ),
      ) as _i3.GlobalKey<_i3.NavigatorState>);

  @override
  _i8.Future<T?> showAppDialog<T>(
          {required _i3.Dialog Function(_i3.BuildContext)? dialog}) =>
      (super.noSuchMethod(
        Invocation.method(
          #showAppDialog,
          [],
          {#dialog: dialog},
        ),
        returnValue: _i8.Future<T?>.value(),
        returnValueForMissingStub: _i8.Future<T?>.value(),
      ) as _i8.Future<T?>);
}

/// A class which mocks [LocalGameRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalGameRepository extends _i1.Mock
    implements _i5.LocalGameRepository {
  @override
  String get storageKey => (super.noSuchMethod(
        Invocation.getter(#storageKey),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.getter(#storageKey),
        ),
        returnValueForMissingStub: _i11.dummyValue<String>(
          this,
          Invocation.getter(#storageKey),
        ),
      ) as String);

  @override
  _i4.Game castMapToObject(Map<String, dynamic>? object) => (super.noSuchMethod(
        Invocation.method(
          #castMapToObject,
          [object],
        ),
        returnValue: _FakeGame_2(
          this,
          Invocation.method(
            #castMapToObject,
            [object],
          ),
        ),
        returnValueForMissingStub: _FakeGame_2(
          this,
          Invocation.method(
            #castMapToObject,
            [object],
          ),
        ),
      ) as _i4.Game);

  @override
  _i8.Future<List<_i4.Game>?> getAll() => (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [],
        ),
        returnValue: _i8.Future<List<_i4.Game>?>.value(),
        returnValueForMissingStub: _i8.Future<List<_i4.Game>?>.value(),
      ) as _i8.Future<List<_i4.Game>?>);

  @override
  _i8.Future<void> saveAll(List<_i4.Game>? objectList) => (super.noSuchMethod(
        Invocation.method(
          #saveAll,
          [objectList],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<_i4.Game?> save(_i4.Game? object) => (super.noSuchMethod(
        Invocation.method(
          #save,
          [object],
        ),
        returnValue: _i8.Future<_i4.Game?>.value(),
        returnValueForMissingStub: _i8.Future<_i4.Game?>.value(),
      ) as _i8.Future<_i4.Game?>);

  @override
  _i8.Future<_i4.Game?> getCurrent() => (super.noSuchMethod(
        Invocation.method(
          #getCurrent,
          [],
        ),
        returnValue: _i8.Future<_i4.Game?>.value(),
        returnValueForMissingStub: _i8.Future<_i4.Game?>.value(),
      ) as _i8.Future<_i4.Game?>);
}

/// A class which mocks [LocalGameService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalGameService extends _i1.Mock implements _i12.LocalGameService {
  @override
  _i5.LocalGameRepository get localGameRepository => (super.noSuchMethod(
        Invocation.getter(#localGameRepository),
        returnValue: _FakeLocalGameRepository_3(
          this,
          Invocation.getter(#localGameRepository),
        ),
        returnValueForMissingStub: _FakeLocalGameRepository_3(
          this,
          Invocation.getter(#localGameRepository),
        ),
      ) as _i5.LocalGameRepository);

  @override
  _i8.Future<List<_i4.Game>?> getGames() => (super.noSuchMethod(
        Invocation.method(
          #getGames,
          [],
        ),
        returnValue: _i8.Future<List<_i4.Game>?>.value(),
        returnValueForMissingStub: _i8.Future<List<_i4.Game>?>.value(),
      ) as _i8.Future<List<_i4.Game>?>);

  @override
  _i8.Future<void> saveGames(List<_i4.Game>? games) => (super.noSuchMethod(
        Invocation.method(
          #saveGames,
          [games],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<_i4.Game?> saveGame(_i4.Game? game) => (super.noSuchMethod(
        Invocation.method(
          #saveGame,
          [game],
        ),
        returnValue: _i8.Future<_i4.Game?>.value(),
        returnValueForMissingStub: _i8.Future<_i4.Game?>.value(),
      ) as _i8.Future<_i4.Game?>);

  @override
  _i8.Future<void> saveToGameHistory(_i4.Game? game) => (super.noSuchMethod(
        Invocation.method(
          #saveToGameHistory,
          [game],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<_i4.Game?> getCurrentGame() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentGame,
          [],
        ),
        returnValue: _i8.Future<_i4.Game?>.value(),
        returnValueForMissingStub: _i8.Future<_i4.Game?>.value(),
      ) as _i8.Future<_i4.Game?>);
}
