/*
Copyright 2015-present the Material Components for iOS authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import UIKit

import CatalogByConvention
import MaterialComponents.MDCBottomSheetController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
                   launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.window = MDCCatalogWindow(frame: UIScreen.main.bounds)
    UIApplication.shared.statusBarStyle = .lightContent

    // The navigation tree will only take examples that implement
    // and return YES to catalogIsPresentable.
    let tree = CBCCreatePresentableNavigationTree()

    let rootNodeViewController = MDCCatalogComponentsController(node: tree)
    let navigationController = UINavigationController(rootViewController: rootNodeViewController)

    // In the event that an example view controller hides the navigation bar we generally want to
    // ensure that the edge-swipe pop gesture can still take effect. This may be overly-assumptive
    // but we'll explore other alternatives when we have a concrete example of this approach causing
    // problems.
    navigationController.interactivePopGestureRecognizer?.delegate = navigationController

    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()

    return true
  }
}

extension UINavigationController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

extension UINavigationController {
  func presentMenu() {
    let menuViewController = MDCMenuViewController(style: .plain)
    let bottomSheet = MDCBottomSheetController(contentViewController: menuViewController)
    self.present(bottomSheet, animated: true, completion: nil)
  }

  func setMenuBarButton(for viewController: UIViewController) {
    let dotsImage = MDCIcons.imageFor_ic_more_horiz()?.withRenderingMode(.alwaysTemplate)
    viewController.navigationItem.rightBarButtonItem =
      UIBarButtonItem(image: dotsImage,
                      style: .plain,
                      target: self,
                      action: #selector(self.presentMenu))
  }
}
