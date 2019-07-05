# SPStorkController

<a href="https://itunes.apple.com/app/id1446635818" target="_blank"><img align="left" src="https://github.com/ivanvorobei/SPStorkController/blob/master/Resources/Preview.gif" width="400"/></a>

### About
Controller **as in Apple Music, Podcasts and Mail** apps. Simple adding close button and centering arrow indicator. Customizable height. Using custom `TransitionDelegate`. Alert you can find in [SPAlert](https://github.com/IvanVorobei/SPAlert) project. 

You can download example [Debts - Spending tracker](https://itunes.apple.com/app/id1446635818) app from AppStore. For **buy source code** of app in preview, go to:

[![xcode-shop.com](https://github.com/ivanvorobei/SPPermission/blob/master/Resources/Buttons/Xcode%20Shop%20Button%20-%203.svg)](https://xcode-shop.com)

If you like the project, do not forget to `put star ★` or follow me in twitter:

[![https://twitter.com/varabeis](https://github.com/ivanvorobei/SPPermission/blob/master/Resources/Buttons/Twitter-2.svg)](https://twitter.com/varabeis)

See project's backers in [Sponsors](https://github.com/ivanvorobei/SPStorkController#sponsors) section.

## Navigate

- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
    - [Light StatusBar](#light-statusbar)
    - [Custom Height](#custom-height)
    - [Close Button](#close-button)
    - [Indicator](#indicator)
    - [Dismissing](#dismissing)
    - [Corner Radius](#corner-radius)
    - [Haptic](#haptic)
    - [Snapshots](#snapshots)
    - [Add Navigation Bar](#add-navigation-bar)
    - [Working with UIScrollView](#working-with-uiscrollview)
    - [UITableView & UICollectionView](#working-with-uitableview--uicollectionview)
    - [Delegate](#delegate)
    - [Storyboard](#storyboard)
- [Sheets in iOS 13](#sheets-in-ios-13)
- [Sponsors](#sponsors)
- [Other Projects +gif](#my-projects)
    - [SPAlert](#spalert)
    - [SPLarkController](#splarkcontroller)
    - [SPPermission](#sppermission)
    - [Awesome iOS UI](https://github.com/ivanvorobei/awesome-ios-ui)
- [License](#license)

## Requirements

Swift `4.2` & `5.0`. Ready for use on iOS 10+

## Installation

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `SPStorkController` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SPStorkController'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate `SPStorkController` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "ivanvorobei/SPStorkController"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate `SPStorkController` into your Xcode project using Xcode 11, specify it in `Project > Swift Packages`:

```ogdl
https://github.com/ivanvorobei/SPStorkController
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate `SPStorkController` into your project manually. Put `Source/SPStorkController` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Quick Start

Create controller and call func `presentAsStork`:

```swift
import UIKit
import SPStorkController

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let controller = UIViewController()
        self.presentAsStork(controller)
    }
}
```

If you want customize controller (remove indicator, set custom height and other), create controller and set `transitioningDelegate` to `SPStorkTransitioningDelegate` object. Use `present` or `dismiss` functions:

```swift
let controller = UIViewController()
let transitionDelegate = SPStorkTransitioningDelegate()
controller.transitioningDelegate = transitionDelegate
controller.modalPresentationStyle = .custom
controller.modalPresentationCapturesStatusBarAppearance = true
self.present(controller, animated: true, completion: nil)
```

Please, do not init `SPStorkTransitioningDelegate` like this:

```swift
controller.transitioningDelegate = SPStorkTransitioningDelegate()
```

You will get an error about weak property.

## Usage

### Light StatusBar

To set light status bar for presented controller, use `preferredStatusBarStyle` property. Also set `modalPresentationCapturesStatusBarAppearance`. See example:

```swift
import UIKit

class ModalViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
```

### Custom Height

Property `customHeight` sets custom height for controller. Default is `nil`:

```swift
transitionDelegate.customHeight = 350
```

### Close Button

Property `showCloseButton` added circle button with dismiss action. Default is `false`:
```swift
transitionDelegate.showCloseButton = false
```

### Indicator

On the top of controller you can add arrow indicator with animatable states. It simple configure.
Property `showIndicator` shows or hides top arrow indicator. Default is `true`:

```swift
transitionDelegate.showIndicator = true
```

Property Parameter `indicatorColor` for customize color of arrow. Default is `gray`:

```swift
transitionDelegate.indicatorColor = UIColor.white
```

Property `hideIndicatorWhenScroll` shows or hides indicator when scrolling. Default is `false`:

```swift
transitionDelegate.hideIndicatorWhenScroll = true
```

### Dismissing

You can also configure events that will dimiss the controller.
Property `swipeToDismissEnabled` enables dismissal by swipe gesture. Default is `true`:

```swift
transitionDelegate.swipeToDismissEnabled = true
```

Property `translateForDismiss` sets how much need to swipe down to close the controller. Work only if `swipeToDismissEnabled` is true. Default is `240`:

```swift
transitionDelegate.translateForDismiss = 100
```

Property `tapAroundToDismissEnabled` enables dismissal by tapping parent controller. Default is `true`:

```swift
transitionDelegate.tapAroundToDismissEnabled = true
```

### Corner Radius

Property `cornerRadius` for customize corner radius of controller's view. Default is `10`:

```swift
transitionDelegate.cornerRadius = 10
```

### Haptic

Property `hapticMoments` allow add taptic feedback for some moments. Default is `.willDismissIfRelease`:

```swift
transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
```

### Snapshots

The project uses a snapshot of the screen in order to avoid compatibility and customisation issues. Before controller presentation, a snapshot of the parent view is made, and size and position are changed for the snapshot. Sometimes you will need to update the screenshot of the parent view, for that use static func:

```swift
SPStorkController.updatePresentingController(modal: controller)
```

and pass the controller, which is modal and uses `SPStorkTransitioningDelegate`.

### Add Navigation Bar

You may want to add a navigation bar to your modal controller. Since it became impossible to change or customize the native controller in swift 4 (I couldn’t even find a way to change the height of the bar), I had to recreate navigation bar from the ground up. Visually it looks real, but it doesn’t execute the necessary functions:

```swift
import UIKit
import SPFakeBar

class ModalController: UIViewController {
    
    let navBar = SPFakeBarView(style: .stork)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.navBar.titleLabel.text = "Title"
        self.navBar.leftButton.setTitle("Cancel", for: .normal)
        self.navBar.leftButton.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)

        self.view.addSubview(self.navBar)
    }
}
```

You only need to add a navigation bar to the main view, it will automatically layout. Use style `.stork` in init of `SPFakeBarView`. Here is visual preview with Navigation Bar and without it:

<img src="https://github.com/ivanvorobei/SPStorkController/blob/master/Resources/Navigation%20Bar.jpg"/>

To use it, you need to install [SPFakeBar](https://github.com/ivanvorobei/SPFakeBar) pod: 

```ruby
pod 'SPFakeBar'
```

### Working with UIScrollView

If you use `UIScrollView` (or UITableView & UICollectionView) on controller, I recommend making it more interactive. When scrolling reaches the top position, the controller will interactively drag down, simulating a closing animation. Also available close controller by drag down on `UIScrollView`. To do this, set the delegate and in the function `scrollViewDidScroll` call:

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    SPStorkController.scrollViewDidScroll(scrollView)
}
```

### Working with UITableView & UICollectionView

Working with a collections classes is not difficult. In the `Example` folder you can find an implementation. However, I will give a couple of tips for making the table look better.

Firstly, if you use `SPFakeBarView`, don't forget to set top insets for content & scroll indicator. Also, I recommend setting bottom insets (it optional):

```swift
tableView.contentInset.top = self.navBar.height
tableView.scrollIndicatorInsets.top = self.navBar.height
```

Please, also use `SPStorkController.scrollViewDidScroll` function in scroll delegate for more interactiveness with your collection or table view.

### Delegate

You can check events by implement `SPStorkControllerDelegate` and set delegate for `transitionDelegate`:

```swift
transitionDelegate.storkDelegate = self
```

Delagate has this functions: 

```swift
protocol SPStorkControllerDelegate: class {
    
    optional func didDismissStorkBySwipe()
    
    optional func didDismissStorkByTap()
}
```

### Storyboard

If need using `SPStorkController` with storyboard, set class `SPStorkSegue` for transition setting in storyboard file. I will give the class code so that you understand what it does:

```swift
import UIKit

class SPStorkSegue: UIStoryboardSegue {
    
    public var transitioningDelegate: SPStorkTransitioningDelegate?
    
    override func perform() {
        transitioningDelegate = transitioningDelegate ?? SPStorkTransitioningDelegate()
        destination.transitioningDelegate = transitioningDelegate
        destination.modalPresentationStyle = .custom
        super.perform()
    }
}
```

Open your storyboard, choose transition and open right menu. Open `Attributes Inspector` and in Class section insert `SPStorkSegue`.

### Modal presentation of other controller

If you want to present modal controller on `SPStorkController`, please set:

```swift
controller.modalPresentationStyle = .custom
```

It’s needed for correct presentation and dismissal of all modal controllers.

### Stop scroll

`SPStorkController` use snapshots. If the parent controller scrollings and you try to show `SPStorkController`, you will see how it froze, and in a second its final position is updated. I recommend to stop scrolling force:

```swift 
scrollView.setContentOffset(self.contentOffset, animated: false)
```

## Sheets in iOS 13

Apple present in `WWDC 2019` new modal presentation style - `Sheets`. It ready use Support interactive dismiss and work with navigations bars. Available since iOS 13. I will add more information when I study this in more detail. You can see presentation [here](https://developer.apple.com/videos/play/wwdc2019/224/).

<a href="https://developer.apple.com/videos/play/wwdc2019/224/" target="_blank"><img align="center" src="https://github.com/ivanvorobei/SPStorkController/blob/master/Resources/Sheets.png"/></a>

## Sponsors

Support me with a monthly donation and help me continue activities. After payment I add you to list of sponsor **in my all projects** with link to your profile. [Become a sponsors](https://www.patreon.com/ivanvorobei)

<a href="https://github.com/zubara21/" target="_blank"><img src="https://github.api.ivanvorobei.by/sponsors/zubara21.jpg" width="100"></a>
<a href="https://github.com/sparrowganz/" target="_blank"><img src="https://github.api.ivanvorobei.by/sponsors/sparrowganz.jpg" width="100"></a>
<a href="https://github.com/shatk0vskiy/" target="_blank"><img src="https://github.api.ivanvorobei.by/sponsors/shatk0vskiy.jpg" width="100"></a>
<a href="https://www.patreon.com/ivanvorobei" target="_blank"><img src="https://github.api.ivanvorobei.by/sponsors/add.jpg" width="100"></a>

## My projects

<img align="left" src="https://github.com/ivanvorobei/SPAlert/blob/master/Resources/Preview-Done.gif" width="220"/>

### SPAlert

[SPAlert](https://github.com/ivanvorobei/SPAlert) is **popup from Apple Music & Feedback in AppStore**. Contains `Done` & `Heart` presets. `Done` present with draw path animation. I clone Apple's alerts as much as possible.  
You can find this alerts in AppStore after feedback, after added song to library in Apple Music. I am also add alert without icon, as simple message.

You can download example [Debts - Spending tracker](https://itunes.apple.com/app/id1446635818) app from AppStore. If you want to **buy source code** of app in preview, please, go to [xcode-shop.com](https://xcode-shop.com).

---

<img align="left" src="https://github.com/ivanvorobei/SPLarkController/blob/master/Resources/Preview.gif" width="220"/>

### SPLarkController

[SPLarkController](https://github.com/ivanvorobei/SPLarkController) transition between controllers. Translate to top. Make **settings screen** for application. You can add **buttons and switches**. The amount cells is not limited. You can start using project with just two lines of code and easy customisation. For implement settings as in preiew, see section [Settings Controller](https://github.com/ivanvorobei/SPLarkController#settings-controller).

You can download example app [Code - Learn Swift & Design](https://itunes.apple.com/app/id1453325619) from AppStore. If you want to **buy source code** of app this app, please, go to [xcode-shop.com](https://xcode-shop.com).

---

<img align="left" src="https://github.com/ivanvorobei/SPPermission/blob/master/Resources/Preview.gif" width="220"/>

### SPPermission

[SPPermission](https://github.com/ivanvorobei/SPPermission) allow request permissions **with native dialog** UI and interactive animations. Also you can request permissions without dialog. Check state any permission. You can start using this project with just two lines of code and easy customisation.

You can buy example Dialog & Dinamic animations in [xcode-shop.com](https://xcode-shop.com/ui-elements), see [preview](https://xcode-shop.com/assets/preview/dinamic-alert.mov).

## License

`SPStorkController` is released under the MIT license. Check `LICENSE.md` for details.
