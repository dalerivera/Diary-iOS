//
//  DRDiaryEntry.h
//  Diary
//
//  Created by Dale Rivera on 7/17/14.
//  Copyright (c) 2014 example. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
NS_ENUM(int16_t, DRDiaryEntryMood) {
    DRDiaryEntryMoodGood = 0,
    DRDiaryEntryMoodAverage = 1,
    DRDiaryEntryMoodBad = 2
};

@interface DRDiaryEntry : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;
@property (nonatomic,readonly) NSString *sectionName;
@end
