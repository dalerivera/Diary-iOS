//
//  DREntryCell.m
//  Diary
//
//  Created by Dale Rivera on 7/17/14.
//  Copyright (c) 2014 example. All rights reserved.
//

#import "DREntryCell.h"
#import "DRDiaryEntry.h"
#import <QuartzCore/QuartzCore.h>
@interface DREntryCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;


@end
@implementation DREntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForEntry:(DRDiaryEntry *)entry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox  = [entry.body boundingRectWithSize:CGSizeMake(190.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: font} context:nil];
    return MAX(minHeight, (CGRectGetHeight(boundingBox) + topMargin + bottomMargin));
}

-(void)configureCellForEntry:(DRDiaryEntry *)entry  {
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if(entry.imageData) {
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    }else {
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
        
    }
    
    if(entry.mood == DRDiaryEntryMoodGood){
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    }else if (entry.mood == DRDiaryEntryMoodAverage){
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    }else if(entry.mood == DRDiaryEntryMoodBad){
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame)/2.0f;
    
    if(entry.location.length>0) {
        self.locationLabel.text = entry.location;
    }else {
        self.locationLabel.text = @"No Location";
    }
}

@end
