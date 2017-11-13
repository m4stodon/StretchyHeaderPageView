//
//  ViewController.swift
//  HeaderViewTests
//
//  Created by Yermakov on 11/8/17.
//  Copyright © 2017 YourMac. All rights reserved.
//


import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate {
    
    // HEADER
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarConteinerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelBottomConstraint: NSLayoutConstraint!
    
    // CONTENT
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var capturesTableView: UITableView!
    @IBOutlet weak var playlistsTableView: UITableView!
    
    // TABS
    @IBOutlet weak var tabsContainerView: UIView!
    @IBOutlet weak var separatorLeftOffsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordingsTabButton: UIButton!
    @IBOutlet weak var recordingsTabLabel: UILabel!
    @IBOutlet weak var playlistsTabButton: UIButton!
    @IBOutlet weak var playlistsTabLabel: UILabel!
    @IBOutlet weak var tabsTopOffsetConstraint: NSLayoutConstraint! // 220 to 0
    @IBOutlet weak var separatorView: UIView!
    
    
    let avatarAnimationsGroup = CAAnimationGroup()
    let nameAnimationsGroup   = CAAnimationGroup()
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        setupNameLabel()
        setupLabels()
        setupTables()
        setupFrames()
    }
    
    var displayLink: CADisplayLink? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
    }
    
    
    // MARK: - Actions
    
    
    func setupStyle() {
        nameLabel.text = "ROMAN Reva"
    }
    
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelta = previousContentOffset - scrollView.contentOffset.y
        animateHeader(scrollView)
        previousContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateHeader(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animateHeader(scrollView)
    }
    
    
    // MARK: - Animations
    
    
    fileprivate var isDragging = false
    fileprivate var scrollDelta: CGFloat = 0.0
    fileprivate var previousContentOffset: CGFloat = 0
    fileprivate var headerIsAnimating = false
    
    
    fileprivate func prepareAnimations() {
        displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
            displayLink?.frameInterval = 60
        }
        // Initial Redraw to bypass animationDidUpdate() changes security
        lastTabsOffset = 1.0
    }
    
    func animateHeader(_ scrollView: UIScrollView) {
        updateHeaderConstraints(scrollView.contentOffset.y)
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        //if isDragging == true {
        //redrawUI(scrollView.contentOffset.y, animated: true)
        //} else {
            //completeRedrawingUI(scrollView)
            //redrawUI(scrollView.contentOffset.y, animated: true) // this call is for bouncing, because completeRedrawingUI uses UIView.animateWithDuration 0.25 delay
        //}
    }
    
    fileprivate func updateHeaderConstraints(_ contentOffset: CGFloat) {
        // HEADER HEIGHT
        var tabsOffset = tabsTopOffsetConstraint.constant - contentOffset
        tabsOffset = min(220, max(tabsOffset, 0)) // check ranges
        tabsTopOffsetConstraint.constant = tabsOffset
        
        // Separator Offset
        let separatorAlpha = Double((24 - max(24, tabsOffset)) / 24) // 1.0 max opacity; 24 max offset
        separatorView.alpha = CGFloat(separatorAlpha)
        
        
        let progress = 1/220 * tabsOffset
        
        // Label Offset
        let nameLabelOffset = min(22, 40 - 40 * progress)
        
        
        
    }
    
//    fileprivate func redrawUI(_ contentOffset: CGFloat, animated: Bool) {
//
//        CATransaction.begin()
//        // HEADER HEIGHT
//        var tabsOffset = tabsTopOffsetConstraint.constant - contentOffset
//        tabsOffset = min(220, max(tabsOffset, 0)) // check ranges
//        tabsTopOffsetConstraint.constant = tabsOffset
//
//        // Separator Offset
//        let separatorAlpha = Double((24 - max(24, tabsOffset)) / 24) // 1.0 max opacity; 24 max offset
//        separatorView.alpha = CGFloat(separatorAlpha)
//        self.view.layoutIfNeeded()
//
//        // ANIMATION
//        //if animated == true {
//        //    tabsOffset = 219 - tabsOffset
//        //    if let presentationLayer: CALayer = self.tabsContainerView.layer.presentation() {
//        //        let tabsOffset = 1/219 * (presentationLayer.frame.origin.y - 65)
//        //        let progress = CFTimeInterval(max(0, min(1, 1 - tabsOffset)))
//        //        animateViews(by: progress)
//        //    }
//        //}
//        //self.headerIsAnimating = false // Added here cause of animateWithDuration delays
//        CATransaction.commit()
//    }
    
//    func completeRedrawingUI(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 { return }
//
//        //guard !headerIsAnimating else { return }
//        //headerIsAnimating = true
//
//        UIView.animate(withDuration: 0.25, animations: {
//            var constant: CGFloat = 0
//
//            if self.tabsTopOffsetConstraint.constant >= 40 {
//                constant = -(219 - self.tabsTopOffsetConstraint.constant)
//            } else {
//                constant = 219
//            }
//            self.redrawUI(constant, animated: true)
//            self.view.layoutIfNeeded()
//        }, completion: { _ in
//            //self.headerIsAnimating = false
//        })
//    }
    
    
    
    
    // TRACK THE PROGRESS OF HEADER ANIMATION
    fileprivate var lastTabsOffset: CGFloat = 0.0
    fileprivate var currentAnimationProgress: CFTimeInterval = 0.0
    
    @objc func animationDidUpdate(displayLink: CADisplayLink) {
        guard let presentationLayer: CALayer = self.tabsContainerView.layer.presentation() else { return }
        let tabsOffset = 1/220 * (presentationLayer.frame.origin.y - 65)
        currentAnimationProgress = CFTimeInterval(max(0, min(1, 1 - tabsOffset)))
    }
    
    func animateHeaderxxx(_ scrollView: UIScrollView) {
        updateHeaderConstraints(scrollView.contentOffset.y)
        // Do not increase duration, because corners of the image wont get redrawed in time so it will be recty
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
            // must update corner radius, cause images becomes recty
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
            self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frame.height / 2
        }, completion: nil)
    }
    
    fileprivate func updateHeaderConstraintsxxx(_ contentOffset: CGFloat) {
        
        // Constants
        let tabsMaxOffset: CGFloat = 190
        
        // Recalculate offset if dragging
        var offset = contentOffset
        //print("offset without initial " , contentOffset, "offset with initial " , initialHeaderHeight - (tabsMaxOffset - contentOffset))
        if isDragging {
            //offset = dragCurrentOffset - dragCurrentOffset
            //offset = initialHeaderHeight - (tabsMaxOffset - contentOffset)
            
            if tabsTopOffsetConstraint.constant > 0 && capturesTableView.contentOffset.y > 0 {
                //capturesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
        
        // Header
        var tabsOffset = tabsTopOffsetConstraint.constant - offset
        tabsOffset = min(tabsMaxOffset, max(tabsOffset, 0)) // check ranges
        tabsTopOffsetConstraint.constant = tabsOffset
        
        // Recalculated header
        //initialHeaderHeight = tabsOffset
        
        // Separator
        let separatorAlpha = Double((24 - max(24, tabsOffset)) / 24) // 1.0 max opacity; 24 max offset
        separatorView.alpha = CGFloat(separatorAlpha)
        
        // Name
        let maxFontSize             : CGFloat = 25
        let minFontSize             : CGFloat = 12
        let maxLetterSpacing        : CGFloat = 1.86
        let maxLabelBottomOffset    : CGFloat = 40
        let minLabelBottomOffset    : CGFloat = 22
        let nameOffsetProgress      : CGFloat = 1 - 1/tabsMaxOffset * tabsOffset
        nameLabelBottomConstraint.constant = maxLabelBottomOffset - (maxLabelBottomOffset - minLabelBottomOffset) * nameOffsetProgress
        
        let fontSize        : CGFloat = maxFontSize - (maxFontSize - minFontSize) * nameOffsetProgress
        let font            : UIFont = .systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
        let letterSpacing   : CGFloat = maxLetterSpacing - maxLetterSpacing * nameOffsetProgress
        nameLabel.font = font
        nameLabel.character(spacing: letterSpacing)
        
        // Avatar
        let avatarContainerMaxHeight: CGFloat = 220
        let avatarContainerMinHeight: CGFloat = 100
        let avatarOffsetProgress = 1 - 1/tabsMaxOffset * tabsOffset
        avatarConteinerHeightConstraint.constant = avatarContainerMaxHeight - (avatarContainerMaxHeight - avatarContainerMinHeight) * avatarOffsetProgress
        
        let maxOpacityValue_Avatar                  : CGFloat = 1.0
        let progressThreshholdMaxValue_Avatar       : CGFloat = 0.6
        let avatarAlphaStep_Avatar                  : CGFloat = maxOpacityValue_Avatar / progressThreshholdMaxValue_Avatar
        let backgroundOpacityProgress_Avatar        : CGFloat = min(progressThreshholdMaxValue_Avatar, avatarOffsetProgress)
        let backgroundOpacityRecalculated_Avatar    : CGFloat = avatarAlphaStep_Avatar * backgroundOpacityProgress_Avatar
        let newOpacityValue_Avatar                  : CGFloat = maxOpacityValue_Avatar - backgroundOpacityRecalculated_Avatar
        avatarContainerView.alpha = newOpacityValue_Avatar
        
        // Avatar Shadow
        let maxOpacityValue_AvatarShadow                : CGFloat = 0.7
        let progressThreshholdMaxValue_AvatarShadow     : CGFloat = 0.15
        let avatarAlphaStep_AvatarShadow                : CGFloat = maxOpacityValue_AvatarShadow / progressThreshholdMaxValue_AvatarShadow
        let backgroundOpacityProgress_AvatarShadow      : CGFloat = min(progressThreshholdMaxValue_AvatarShadow, avatarOffsetProgress)
        let backgroundOpacityRecalculated_AvatarShadow  : CGFloat = avatarAlphaStep_AvatarShadow * backgroundOpacityProgress_AvatarShadow
        let newOpacityValue_AvatarShadow                : CGFloat = maxOpacityValue_AvatarShadow - backgroundOpacityRecalculated_AvatarShadow
        backgroundImageView.alpha = newOpacityValue_AvatarShadow
        
    }
    
    
    // MARK: - Private
    
    
    fileprivate func setupNameLabel() {
        nameLabel.character(spacing: 1.86)
    }
    
    fileprivate func setupLabels() {
        playlistsTabLabel.character(spacing: 0.79)
        recordingsTabLabel.character(spacing: 0.79)
    }
    
    fileprivate func setupTables() {
        capturesTableView.delegate    = self
        capturesTableView.dataSource  = self
        playlistsTableView.delegate   = self
        playlistsTableView.dataSource = self
    }
    
    fileprivate func setupFrames() {
        avatarImageView.layer.cornerRadius     = avatarImageView.frame.width / 2
        backgroundImageView.layer.cornerRadius = backgroundImageView.frame.width / 2
        
        let img = UIImage.init(named: "Fallout4_AwesomeTales6")!
        let resizedImage = img.resized(toSize: CGSize(width: 118, height: 118))
        avatarImageView.image     = resizedImage
        backgroundImageView.image = resizedImage.rounded(radius: 59).blurred(blurRadius: 8.0)
    }
}


extension UILabel {
    
    func character(spacing: CGFloat = 0) {
        guard let text = self.text else {
            return
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: text.characters.count))
        
        attributedText = attributedString
    }
}

extension UIImage {
    
    func rounded(radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: self)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    func blurred(blurRadius: CGFloat) -> UIImage? {
        guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }
        blur.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        let ciContext = CIContext(options: [kCIContextUseSoftwareRenderer : false])
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage!
        let outputImage = blur.outputImage
        let cgImage = ciContext.createCGImage(result!, from: (outputImage?.extent)!)
        let filteredImage = UIImage(cgImage: cgImage!)
        return filteredImage
    }
    
    func resized(toSize newSize: CGSize) -> UIImage {
        let scaleFactor = newSize.width / self.size.width
        let size = self.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}




