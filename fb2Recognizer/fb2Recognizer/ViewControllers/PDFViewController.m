//
//  PDFViewController.m
//  fb2Recognizer
//
//  Created by Natasha on 27.04.13.
//  Copyright (c) 2013 Natasha. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()
//@property (assign, nonatomic) NSInteger currentPageNumber;
//@property (strong, nonatomic) NSURL* urlToFile;
@end

@implementation PDFViewController


//- (id)initWithDocument:(DocumentModel*)model
//{
//    self = [super init];
//    if (self) {
////        self.urlToFile = model.documentUrl;
////        self.currentPageNumber = model.documentLastPage;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
    
    //Step 1
    //Instantiate the UIPageViewController.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    //Step 2:
    //Assign the delegate and datasource as self.
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    //Step 3:
    //Set the initial view controllers.
    ContentViewController *contentViewController = [[ContentViewController alloc] initWithUrl:self.docModel.documentUrl andCurrentNumber:self.docModel.documentCurrentPage];
    
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    //Step 4:
    //ViewController containment steps
    //Add the pageViewController as the childViewController
    [self addChildViewController:self.pageViewController];
    
    //Add the view of the pageViewController to the current view
    [self.view addSubview:self.pageViewController.view];
    
    //Call didMoveToParentViewController: of the childViewController, the UIPageViewController instance in our case.
    [self.pageViewController didMoveToParentViewController:self];
    
    //Step 5:
    // set the pageViewController's frame as an inset rect.
    CGRect pageViewRect = self.view.bounds;
    //pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    self.pageViewController.view.frame = pageViewRect;
    
    //Step 6:
    //Assign the gestureRecognizers property of our pageViewController to our view's gestureRecognizers property.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    [self decreasePageNumber];
    ContentViewController *contentViewController = [[ContentViewController alloc] initWithUrl:self.docModel.documentUrl andCurrentNumber:self.docModel.documentCurrentPage];
    
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    [self increasePageNumber];
    ContentViewController *contentViewController = [[ContentViewController alloc] initWithUrl:self.docModel.documentUrl andCurrentNumber:self.docModel.documentCurrentPage];
    
    return contentViewController;
}


- (void)increasePageNumber
{
    size_t pageCount = CGPDFDocumentGetNumberOfPages(CGPDFDocumentCreateWithURL((__bridge CFURLRef)self.docModel.documentUrl));
    if (self.docModel.documentCurrentPage == pageCount) {
        // do nothing
    }
    else {
        self.docModel.documentCurrentPage++;
    }
}

- (void)decreasePageNumber
{
    if (self.docModel.documentCurrentPage == 1) {
        // do nothing
    }
    else {
        self.docModel.documentCurrentPage--;
    }
}
//
//- (void)increasePageNumber
//{
//    size_t pageCount = CGPDFDocumentGetNumberOfPages(CGPDFDocumentCreateWithURL((__bridge CFURLRef)self.urlToFile));
//    if (self.currentPageNumber == pageCount) {
//        // do nothing
//    }
//    else {
//        self.currentPageNumber++;
//        //        [self.pdfView setNeedsDisplay];
//    }
//}
//
//- (void)decreasePageNumber
//{
//    if (self.currentPageNumber == 1) {
//        // do nothing
//    }
//    else {
//        self.currentPageNumber--;
//        //        [self.pdfView setNeedsDisplay];
//    }
//}


#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        //Set the array with only 1 view controller
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        //Important- Set the doubleSided property to NO.
        self.pageViewController.doubleSided = NO;
        //Return the spine location
        return UIPageViewControllerSpineLocationMin;
    } /*
       else
       {
       NSArray *viewControllers = nil;
       ContentViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
       
       NSUInteger currentIndex = [self.modelArray indexOfObject:[(ContentViewController *)currentViewController labelContents]];
       if(currentIndex == 0 || currentIndex %2 == 0)
       {
       UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
       viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
       }
       else
       {
       UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
       viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
       }
       //Now, set the viewControllers property of UIPageViewController
       [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
       
       return UIPageViewControllerSpineLocationMid;
       } */
}

@end
