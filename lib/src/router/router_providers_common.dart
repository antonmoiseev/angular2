library angular2.src.router.router_providers_common;

import "package:angular2/core.dart" show ApplicationRef, Provider;
import "package:angular2/platform/common.dart"
    show LocationStrategy, PathLocationStrategy, Location;
import "package:angular2/src/facade/exceptions.dart" show BaseException;
import "package:angular2/src/router/route_registry.dart"
    show RouteRegistry, ROUTER_PRIMARY_COMPONENT;
import "package:angular2/src/router/router.dart" show Router, RootRouter;

/**
 * The Platform agnostic ROUTER PROVIDERS
 */
const List<dynamic> ROUTER_PROVIDERS_COMMON = const [
  RouteRegistry,
  const Provider(LocationStrategy, useClass: PathLocationStrategy),
  Location,
  const Provider(Router, useFactory: routerFactory, deps: const [
    RouteRegistry,
    Location,
    ROUTER_PRIMARY_COMPONENT,
    ApplicationRef
  ]),
  const Provider(ROUTER_PRIMARY_COMPONENT,
      useFactory: routerPrimaryComponentFactory, deps: const [ApplicationRef])
];
RootRouter routerFactory(RouteRegistry registry, Location location,
    dynamic primaryComponent, ApplicationRef appRef) {
  var rootRouter = new RootRouter(registry, location, primaryComponent);
  appRef.registerDisposeListener(() => rootRouter.dispose());
  return rootRouter;
}

dynamic routerPrimaryComponentFactory(ApplicationRef app) {
  if (app.componentFactories.length == 0) {
    throw new BaseException(
        "Bootstrap at least one component before injecting Router.");
  }
  return app.componentFactories[0];
}
