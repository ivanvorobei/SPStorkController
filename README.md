<img src="https://github.com/IvanVorobei/SPStorkController/blob/master/Resources/Banner.svg"/>

Modal controller like in Mail or Apple Music application. Similar animation and transition. I tried to recreate all the animations, corner radius and frames. Controller supports gestures and Navigation Bar and works with ScrollView. You can watch [how to use pod tutorial](https://youtu.be/wOTNGswT2-0) on YouTube.

Preview GIF is loading `3mb`. Please, wait.

<img src="https://github.com/IvanVorobei/SPStorkController/blob/master/Resources/Preview.gif" width="500">

You can download example [from AppStore](https://itunes.apple.com/app/id1446635818) or see [video preview](https://xcode-shop.com/assets/preview/debts.mov). If you want to buy source code of the full app, please go to [xcode-shop.com](https://xcode-shop.com). Price: $200.

<img src="https://github.com/IvanVorobei/SPStorkController/blob/master/Resources/Shop.svg"/>

I have a store where I sell applications and modules for Xcode projects. You can find source codes of applications or custom animations / UI. I regularly update the code. Visit my website to see all items for sale: [xcode-shop.com](https://xcode-shop.com). On the website you can find previews and for some items links to AppStore.

<img src="https://github.com/IvanVorobei/SPStorkController/blob/master/Resources/Shop.svg"/>

## Requirements
Swift 4.2. Ready for use on iOS 10+

## Integration
Put `Source/SPStorkController` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

Or via CocoaPods:
```ruby
pod 'SPStorkController'
```

## How to use

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

### Video Tutorial

You can see how to use `SPStorkController` and how to customize it [in this video](https://youtu.be/wOTNGswT2-0). For English speakers I’ve added subtitles, don’t forget to turn them on:

[![Tutorial on YouTube](https://github.com/IvanVorobei/SPStorkController/blob/master/Resources/YouTube.jpg)](https://youtu.be/wOTNGswT2-0)

On my [YouTube channel](http://youtube.com/ivanvorobei) you can find videos about Xcode and Design. I would appreciate it if you like and subscribe. If you do not want to watch the video, I wrote a small wiki below.

### Light StatusBar

To set `light` status bar for presented controller, use `preferredStatusBarStyle` property. Also set `modalPresentationCapturesStatusBarAppearance`. See example:

```swift
import UIKit

class ModalViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
```

### Parameters

- Parameter `customHeight` sets custom height for modal controller. Default is `nil`:
```swift
transitionDelegate.customHeight = 350
```

- Parameter `swipeToDismissEnabled` enables dismissal by swipe gesture. Default is `true`:

```swift
transitionDelegate.swipeToDismissEnabled = true
```

- Parameter `translateForDismiss` sets how much need to swipe down to close the controller. Work only if `swipeToDismissEnabled` is true. Default is `240`:
```swift
transitionDelegate.translateForDismiss = 100
```

- Parameter `tapAroundToDismissEnabled` enables dismissal by tapping parent controller. Default is `true`:

```swift
transitionDelegate.tapAroundToDismissEnabled = true
```

- Parameter `showIndicator` shows or hides top arrow indicator. Default is `true`:
```swift
transitionDelegate.showIndicator = true
```

- Parameter `indicatorColor` for customize color of arrow. Default is `gray`:
```swift
transitionDelegate.indicatorColor = UIColor.white
```

- Parameter `cornerRadius` for customize corner radius of controller's view. Default is `10`:
```swift
transitionDelegate.cornerRadius = 10
```

### Snapshots

The project uses a snapshot of the screen in order to avoid compatibility and customization issues. Before controller presentation, a snapshot of the parent view is made, and size and position are changed for the snapshot. Sometimes you will need to update the screenshot of the parent view, for that use static func:

```swift
SPStorkController.updatePresentingController(modal: controller)
```

and pass the controller, which is modal and uses `SPStorkTransitioningDelegate`

### Add Navigation Bar
You may want to add a navigation bar to your modal controller. Since it became impossible to change or customize the native controller in swift 4 (I couldn’t even find a way to change the height of the bar), I had to recreate navigation bar from the ground up. Visually it looks real, but it doesn’t execute the necessary functions:

```swift
import UIKit

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

<img src="https://github.com/IvanVorobei/SPStorkController/blob/master/Resources/Navigation%20Bar.jpg"/>

To use `SPFakeBarView` you need to install [SparrowKit](https://github.com/IvanVorobei/SparrowKit) pod: 

```ruby
pod 'SparrowKit'
```

### Working with UIScrollView

If you use `UIScrollView` (or UITableView & UICollectionView) on your controller, I recommend making it more interactive. When scrolling reaches the top position, the controller will interactively drag down, simulating a closing animation. Also available close controller by drag down on `UIScrollView`. To do this, set the delegate and in the function `scrollViewDidScroll` call:

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

### Modal presentation of different controller

If you want to present modal controller on SPStorkController, please set:

```swift
controller.modalPresentationStyle = .custom
```

It’s needed for correct presentation and dismissal of all modal controllers.

## My projects

Here I would like to offer you my other projects.

### SPPermission
Project [SPPermission](https://github.com/IvanVorobei/SPPermission) for managing permissions with customizable visual effects. Beautiful dialog increases the chance of approval (which is important when we request notification). Simple control of this module saves you hours of development. You can start using project with just two lines of code and easy customization!

<img src="https://github.com/IvanVorobei/SPPermission/blob/master/Resources/Preview.gif" width="500">

### SparrowKit
`SPStorkController` was formerly a part of [SparrowKit](https://github.com/IvanVorobei/SparrowKit) library. In the library you can find many useful extensions & classes. To install via CocoaPods use:

```ruby
pod 'SparrowKit'
```

## License
`SPStorkController` is released under the MIT license. Check `LICENSE.md` for details.

## Contact
If you need any application or UI to be developed, message me at hello@ivanvorobei.by. I develop iOS apps and create designs, too. I use `swift` for development. To request more functionality, you should create a new issue. 
Here are my apps in AppStore: [first account](https://itunes.apple.com/us/developer/polina-zubarik/id1434528595) & [second account](https://itunes.apple.com/us/developer/mikalai-varabei/id1435792103).
