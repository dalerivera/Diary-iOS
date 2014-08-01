//
//  DRNewEntryViewController.m
//  Diary
//
//  Created by Dale Rivera on 7/17/14.
//  Copyright (c) 2014 example. All rights reserved.
//

#import "DREntryViewController.h"
#import "DRDiaryEntry.h"
#import "DRCoreDataStack.h"
#import <CoreLocation/CoreLocation.h>
@interface DREntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong) NSString *location;
@property(nonatomic,assign) enum DRDiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong,nonatomic) UIImage *pickedImage;
@property(strong,nonatomic) CLLocationManager *locationManager;
@end

@implementation DREntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date;
    if(self.entry !=nil ) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    }else {
        self.pickedMood = DRDiaryEntryMoodGood;
        date = [NSDate date];
        [self loadLocation];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc ]  init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView  = self.accessoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
 }

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadLocation {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy =1000;
    
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    
    }];


}
-(void)insertDiaryEntry {
    DRCoreDataStack *coreDataStack = [DRCoreDataStack defaultStack];
    DRDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DRDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.location = self.location;
    [coreDataStack saveContext];
}

-(void)updateDiaryEntry {
    self.entry.body = self.textView.text;
    DRCoreDataStack *coreDataStack = [DRCoreDataStack defaultStack];
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    [coreDataStack saveContext];

}

-(void) promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

-(void) promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void) promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) setPickedMood:(enum DRDiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case DRDiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case DRDiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        case DRDiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
    }
}

- (void) setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    if(pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
        
    }else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
        
    }
    
    
    
}

- (IBAction)doneWasPressed:(id)sender {
    if(self.entry!=nil){
        [self updateDiaryEntry];
    }else {
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}
- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}
- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = DRDiaryEntryMoodBad;
    
}
- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = DRDiaryEntryMoodAverage;
}
- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = DRDiaryEntryMoodGood;
}
- (IBAction)imageButtonWasPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    }else {
        [self promptForPhotoRoll];
    }
}

@end
