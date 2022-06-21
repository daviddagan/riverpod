part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeChangeNotifierProviderRef<Notifier>
    implements AutoDisposeRef<Notifier> {
  /// The [ChangeNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider}
@sealed
class AutoDisposeChangeNotifierProvider<Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderBase<Notifier>
    with
        ChangeNotifierProviderOverrideMixin<Notifier>,
        OverrideWithProviderMixin<Notifier,
            AutoDisposeChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider}
  AutoDisposeChangeNotifierProvider(
    Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
    Duration? cacheTime,
    Duration? disposeDelay,
  })  : notifier = _AutoDisposeNotifierProvider<Notifier>(
          create,
          name: modifierName(name, 'notifier'),
          dependencies: dependencies,
          from: from,
          argument: argument,
          cacheTime: cacheTime,
        ),
        super(
          name: name,
          from: from,
          argument: argument,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamilyBuilder();

  @override
  ProviderBase<Notifier> get originProvider => notifier;

  /// {@macro flutter_riverpod.changenotifierprovider.notifier}
  @override
  final AutoDisposeProviderBase<Notifier> notifier;

  @override
  AutoDisposeProviderElementBase<Notifier> createElement() =>
      _AutoDisposeChangeNotifierProviderElement<Notifier>(this);
}

class _AutoDisposeChangeNotifierProviderElement<
        Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderElementBase<Notifier> {
  _AutoDisposeChangeNotifierProviderElement(this.provider);
  @override
  final AutoDisposeChangeNotifierProvider<Notifier> provider;

  @override
  Notifier create() {
    final notifier = watch<Notifier>(provider.notifier);
    _listenNotifier(notifier, this);
    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

// ignore: subtype_of_sealed_class
class _AutoDisposeNotifierProvider<Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderBase<Notifier> {
  _AutoDisposeNotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
    Family? from,
    Object? argument,
    Duration? cacheTime,
    Duration? disposeDelay,
  }) : super(
          name: modifierName(name, 'notifier'),
          from: from,
          argument: argument,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  @override
  final List<ProviderOrFamily>? dependencies;

  final Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>>
      _create;

  @override
  _AutoDisposeNotifierProviderElement<Notifier> createElement() {
    return _AutoDisposeNotifierProviderElement<Notifier>(this);
  }
}

class _AutoDisposeNotifierProviderElement<Notifier extends ChangeNotifier?>
    extends AutoDisposeProviderElementBase<Notifier>
    implements AutoDisposeChangeNotifierProviderRef<Notifier> {
  _AutoDisposeNotifierProviderElement(this.provider);

  @override
  final _AutoDisposeNotifierProvider<Notifier> provider;

  @override
  Notifier get notifier => requireState;

  @override
  Notifier create() {
    final notifier = provider._create(this);
    if (notifier != null) onDispose(notifier.dispose);

    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;
}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.changenotifierprovider.family}
@sealed
class AutoDisposeChangeNotifierProviderFamily<Notifier extends ChangeNotifier?,
        Arg>
    extends Family<Notifier, Arg, AutoDisposeChangeNotifierProvider<Notifier>> {
  /// {@macro riverpod.changenotifierprovider.family}
  AutoDisposeChangeNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Duration? cacheTime,
    Duration? disposeDelay,
  }) : super(
          name: name,
          dependencies: dependencies,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  final FamilyCreate<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>,
      Arg> _create;

  @override
  AutoDisposeChangeNotifierProvider<Notifier> create(Arg argument) {
    return AutoDisposeChangeNotifierProvider<Notifier>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);

    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }

  /// {@endtemplate}
  Override overrideWithProvider(
    AutoDisposeChangeNotifierProvider<Notifier> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(
      this,
      (arg, setup) {
        final provider = call(arg);

        setup(origin: provider.notifier, override: override(arg).notifier);
        setup(origin: provider, override: provider);
      },
    );
  }
}
