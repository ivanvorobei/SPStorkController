// The MIT License (MIT)
// Copyright © 2017 Ivan Varabei (varabeis@icloud.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

open class SPStorkCloseButton: UIButton {
    
    let iconView = SPStorkCloseView()
    
    var widthIconFactor: CGFloat = 1
    var heightIconFactor: CGFloat = 1
    
    var color = UIColor.blue {
        didSet {
            self.iconView.color = self.color
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.iconView.color = self.color.withAlphaComponent(self.isHighlighted ? 0.7 : 1)
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.iconView.isUserInteractionEnabled = false
        self.addSubview(self.iconView)
        self.backgroundColor = UIColor.init(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1)
        self.color = UIColor.init(red: 142 / 255.0, green: 142 / 255.0, blue: 147 / 255.0, alpha: 1)
        self.widthIconFactor = 0.36
        self.heightIconFactor = 0.36
    }
    
    func layout(bottomX: CGFloat, y: CGFloat) {
        self.sizeToFit()
        self.frame.origin.x = bottomX - self.frame.width
        self.frame.origin.y = y
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        self.iconView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width * self.widthIconFactor, height: self.frame.height * self.heightIconFactor)
        self.iconView.center = CGPoint.init(x: self.frame.width / 2, y: self.frame.height / 2)
    }
    
    override open func sizeToFit() {
        super.sizeToFit()
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: 30, height: 30)
    }
}
