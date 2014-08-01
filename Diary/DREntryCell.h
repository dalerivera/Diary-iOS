//
//  DREntryCell.h
//  Diary
//
//  Created by Dale Rivera on 7/17/14.
//  Copyright (c) 2014 example. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DRDiaryEntry;
@interface DREntryCell : UITableViewCell

@property(nonatomic,readonly) NSString *sectionName;
+(CGFloat)heightForEntry:(DRDiaryEntry *)entry;
-(void) configureCellForEntry:(DRDiaryEntry *) entry;
@end
