<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/90c836ec5649e77fb44ff727d7dad96d2009f3d8/Resources/SPStorkController - Name.svg"/>

Modal controller as in mail or Apple music application. Similar animation and transition. I tried to repeat all the animations, corner radius and frames. The controller supports gestures and Navigation Bar & work with ScrollView. You can see [how use pod tutorial](https://youtu.be/wOTNGswT2-0) on youtube

Preview GIF loading `3mb`. Please, wait

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/c66764082c0d9bf11d0bd46d5fa458edb62044fe/Resources/gif-mockup - 3.gif" width="500">

You can download example [in AppStore](https://itunes.apple.com/app/id1446635818). If you want buy code of app on gif, please, [contact me](#contact). Source code can be used for educational purposes only

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/4b1c91dacc4d3f901fcab5c7efdff256a40c4381/Resources/SPStorkController - Donate.svg"/>

The project is absolutely free, but but it takes time to support and update it. Your support is very motivating and very important. I often receive emails asking me to update or add functionality. [Small donate](https://money.yandex.ru/to/410012745748312) for a cup of coffee helps to develop the project and make it better

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/4b1c91dacc4d3f901fcab5c7efdff256a40c4381/Resources/SPStorkController - Donate.svg"/>

## Requirements
Swift 4.2. Ready for use on iOS 10+

## Integration
Drop in `Source/SPStorkController` folder to your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

Or via CocoaPods:
```ruby
pod 'SPStorkController'
```

## How to use
Create controller and set `transitioningDelegate` to `SPStorkTransitioningDelegate` object. Use `present` or `dismiss` functions:

```swift
import UIKit
import SPStorkController

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let controller = UIViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        self.present(controller, animated: true, completion: nil)
    }
}
```

Please, _not_ init `SPStorkTransitioningDelegate` like here:

```swift
controller.transitioningDelegate = SPStorkTransitioningDelegate()
```

You will get error about weak property.

### Light StatusBar

For set `light` status bar for presented controller, user `preferredStatusBarStyle` propert. Also set `modalPresentationCapturesStatusBarAppearance`. See example:

```swift
import UIKit

class ModalViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationCapturesStatusBarAppearance = true
    }
}
```

### Parametrs

- Parameter `isSwipeToDismissEnabled` enables dissmiss by swipe gester. Defualt is `true`:

```swift
transitionDelegate.isSwipeToDismissEnabled = true
```

- Parameter `isTapAroundToDismissEnabled` enables dissmiss by tap parrent controller. Defualt is `true`:

```swift
transitionDelegate.isTapAroundToDismissEnabled = true
```

- Parameter `showIndicator` shows or hides top arrow indicator. Defualt is `true`:
```swift
transitionDelegate.showIndicator = true
```

- Parameter `customHeight` sets custom height for modal controller. Defualt is `nil`:
```swift
transitionDelegate.customHeight = 350
```

### Add Navigation Bar
You may want to add a navigation bar to your modal controller. Since it became impossible to change or customize the native controller in swift 4 (I couldn’t even find a way to change the height of bar), I had to completely create navigation bar. Visually, it looks real, but it doesn’t execute the necessary functions:

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

You only need to add a navigation bar to the main view, it will automatically layout. Use style `.stork` in init `SPFakeBarView`. It is image preview with Navigation Bar and without it:

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/916cfef888b3e70ca45d1b8b26fba1947421632b/Recources/SPStorkController - Banner.jpg"/>

For use `SPFakeBarView` you should install [SparrowKit](https://github.com/IvanVorobei/SparrowKit) pod: 

```ruby
pod 'SparrowKit'
```

### Work with UIScrollView

If you use `UIScrollView` (or UITableView & UICollectionView) on your controller, I recommend making it more interactive. When the scroll reaches the top position, the controller will interactively drag down, simulating a closing animation. To do this, set the delegate and in the function `scrollViewDidScroll` call:

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    SPStorkController.scrollViewDidScroll(scrollView)
}
```

### Work with UITableView & UICollectionView

Working with a collections classes is not difficult. In the `Example` folder you can find the implementation, however I will give a couple of tips to help the table look better.

For fist, if you use `SPFakeBarView`, don't forget set top insets for content & scroll indicator. Also I am recomeded set bottom insets:

```swift
tableView.contentInset.top = self.navBar.height
tableView.scrollIndicatorInsets.top = self.navBar.height

tableView.contentInset.bottom = self.safeArea.bottom
tableView.scrollIndicatorInsets.bottom = self.safeArea.bottom
```

Please, use also `SPStorkController.scrollViewDidScroll()` function in delegate for more intaractive with your collection or table view

## My projects

Here I would like to offer you my other projects.

### SPPermission
Project [SPPermission](https://github.com/IvanVorobei/SPPermission) for managing permissions with the customizable visual effects. Beautiful dialog increases the chance of approval (which is important when we request notification). Simple control of this module saves you hours of development. You can start using project with just two lines of code and easy customization!

<img src="https://rawcdn.githack.com/IvanVorobei/RequestPermission/fb53d20f152a3e76e053e6af529306611fb794f0/resources/request-permission - mockup_preview.gif" width="500">

### SparrowKit
The `SPStorkController` in the past was part of [SparrowKit](https://github.com/IvanVorobei/SparrowKit) library. In library you can find many useful extensions & classes. For install via CocoaPods use:

```ruby
pod 'SparrowKit'
```

## License
`SPStorkController` is released under the MIT license. Check `LICENSE.md` for details

## Contact
If you have any requirements to develop any application or UI, write to me at hello@ivanvorobei.by. I am developing iOS apps and creates designs too. I use `swift` for developing projects. For requesting more functionality, you should create a new issue. 
Here are my apps in AppStore: [first account](https://itunes.apple.com/us/developer/polina-zubarik/id1434528595) & [second account](https://itunes.apple.com/us/developer/mikalai-varabei/id1435792103)
