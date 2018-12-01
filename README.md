<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/90c836ec5649e77fb44ff727d7dad96d2009f3d8/Resources/SPStorkController - Name.svg"/>

Modal controller as in mail or Apple music application. Similar animation and transition. I tried to repeat all the animations, corner radius and frames. The controller supports gestures and Navigation Bar

Preview GIF loading `4mb`. Please, wait

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/0acd51bbe76ef48611e1bdd408aebb9c7d9b0ae6/resources/gif-mockup.gif" width="500">

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/4b1c91dacc4d3f901fcab5c7efdff256a40c4381/Resources/SPStorkController - Donate.svg"/>

The project is absolutely free, but but it takes time to support and update it. Your support is very motivating and very important. I often receive emails asking me to update or add functionality. [Small donate](https://money.yandex.ru/to/410012745748312) for a cup of coffee helps to develop the project and make it better

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/4b1c91dacc4d3f901fcab5c7efdff256a40c4381/Resources/SPStorkController - Donate.svg"/>

## Requirements
Swift 4.2. Ready for use on iOS 10+

## Integration
Drop in `Source/Sparrow` folder to your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`

Or via CocoaPods:
```ruby
pod 'SPStorkController'
```

and import library in class:
```swift
import SparrowKit
```

## How to use
Create controller (please, set background, it maybe clear color) and set `transitioningDelegate` to `SPStorkTransitioningDelegate()`. Use `present` or `dismiss` functions:
```swift
let controller = UIViewController()
controller.transitioningDelegate = SPStorkTransitioningDelegate()
controller.modalPresentationStyle = .custom
present(controller, animated: true, completion: nil)
```

## Add Navigation Bar
You may want to add a navigation bar to your modal controller. Since it became impossible to change or customize the native controller in swift 4 (I couldn’t even find a way to change the height of bar), I completely create navigation bar. Visually, it looks real, but it doesn’t execute the necessary functions

```swift
import UIKit

class ModalController: UIViewController {
    
    let navBar = SPFakeBarView(style: .stork)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.navBar.titleLabel.text = "Title"
        self.navBar.leftButton.setTitle("Cancel")
        self.navBar.leftButton.target {
            self.dismiss()
        }

        self.view.addSubview(self.navBar)
    }
}
```

You only need to add a navigation bar to the main view, it will automatically layout. Use style `.stork` in init `SPFakeBarView`. It is image preview with Navigation Bar and without it:

<img src="https://rawcdn.githack.com/IvanVorobei/SPStorkController/916cfef888b3e70ca45d1b8b26fba1947421632b/Recources/SPStorkController - Banner.jpg"/>

## My projects

Here I would like to offer you my other projects

### SPPermission
Project [SPPermission](https://github.com/IvanVorobei/SPPermission) for managing permissions with the customizable visual effects. Beautiful dialog increases the chance of approval (which is important when we request notification). Simple control of this module saves you hours of development. You can start using [this project](https://github.com/IvanVorobei/SPPermission) with just two lines of code and easy customization!

<img src="https://rawcdn.githack.com/IvanVorobei/RequestPermission/fb53d20f152a3e76e053e6af529306611fb794f0/resources/request-permission - mockup_preview.gif" width="500">

### SparrowKit
The `SPStorkController` use [SparrowKit](https://github.com/IvanVorobei/SparrowKit) library. You can install it if you want to receive updates often. Also in library you can find [SPPermission](https://github.com/IvanVorobei/SPPermission) and other useful extensions. For install via CocoaPods use:

```ruby
pod 'SparrowKit'
```

If you use `pod SPStorkController`, library [SparrowKit](https://github.com/IvanVorobei/SparrowKit) install automatically.

## License
`SPStorkController` is released under the MIT license. Check LICENSE.md for details

## Contact
If you need develop application or UI, write me to hello@ivanvorobei.by. I am develop design and ios apps. I am use `swift`. If you want to ask for more functionality, you should create a new issue.
My apps in AppStore: [first account](https://itunes.apple.com/us/developer/polina-zubarik/id1434528595) & [second account](https://itunes.apple.com/us/developer/mikalai-varabei/id1435792103)
