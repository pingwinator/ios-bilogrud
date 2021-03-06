//
//  PersonListViewController.h
//  PersonDBApp
//
//  Created by Natasha on 17.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (retain, nonatomic) UITableView* tableViewPersons;
@property (retain, nonatomic) NSFetchedResultsController* personFetchRC;
@end
