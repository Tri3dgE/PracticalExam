//
//  MovieDetailsViewController.h
//  PracticalExam
//
//  Created by Mel Bryan Villegas on 5/6/16.
//  Copyright (c) 2016 Mel Bryan Villegas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"


#define movieImageDataURL @"https://dl.dropboxusercontent.com/u/5624850/movielist/images/"


@interface MovieDetailsViewController : UIViewController


//A NSDictionary property value that will be used to contain the data-source of the fields used by Detail Controller.
@property (strong, nonatomic) NSDictionary *movieDetailDictionary;


@property (weak, nonatomic) IBOutlet UIImageView *movieDetailBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIImageView *movieDetailMovieCoverImageView;

@property (weak, nonatomic) IBOutlet UILabel *movieDetailNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *movieDetailReleaseDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *movieDetailRatingLabel;

@property (weak, nonatomic) IBOutlet UITextView *movieDetailDescriptionTextView;

@end
