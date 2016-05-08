//
//  MovieDetailsViewController.m
//  PracticalExam
//
//  Created by Mel Bryan Villegas on 5/6/16.
//  Copyright (c) 2016 Mel Bryan Villegas. All rights reserved.
//

#import "MovieDetailsViewController.h"


@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

@synthesize movieDetailDictionary = _movieDetailDictionary;

@synthesize movieDetailBackgroundImageView;

@synthesize movieDetailMovieCoverImageView;

@synthesize movieDetailNameLabel;

@synthesize movieDetailReleaseDateLabel;

@synthesize movieDetailRatingLabel;

@synthesize movieDetailDescriptionTextView;

#pragma mark - OVERRIDEN GETTER
//Implements a GETTER method for the movieDetailDictionary in order to avoid NIL / NULL parameter values.
- (NSDictionary *)movieDetailDictionary
{
    if (!_movieDetailDictionary) {
        
        _movieDetailDictionary = [NSDictionary dictionary];
    }
    
    return _movieDetailDictionary;
}

#pragma mark - OVERRIDEN SETTER

#pragma mark - INITIALIZATION


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     [self setupMovieDetailsInterface];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    movieDetailDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    movieDetailDescriptionTextView.layer.borderWidth = 1.3f;
    
    movieDetailMovieCoverImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    movieDetailMovieCoverImageView.layer.borderWidth = 1.3f;
}


#pragma mark - FUNCTION


/*!
    @define: Function called in order to load the necessary Data-Source values acquired from the movieDetailDictionary object to their designated outlets.
 
 */
- (void)setupMovieDetailsInterface {

   __block NSMutableDictionary *movieDictionary = [NSMutableDictionary dictionaryWithDictionary:self.movieDetailDictionary];
    
    movieDetailNameLabel.text = [movieDictionary valueForKey:@"title"];
    
    movieDetailRatingLabel.text = [NSString stringWithFormat:@"Rating: %.2f", [[movieDictionary valueForKey:@"rating"] floatValue]];
    
    movieDetailReleaseDateLabel.text = [NSString stringWithFormat:@"Year: %@",[movieDictionary valueForKey:@"year"]];
    
    movieDetailDescriptionTextView.text = [movieDictionary valueForKey:@"overview"];

    
    //Performs an asynchronous URL request in order to load in the Movie Image Backdrop to be used should it still not exists on the current dictionary keys.
    if ([self.movieDetailDictionary valueForKey:@"movieBackdropImage"] == nil) {
        
        NSString *movieImageURLString = [NSString stringWithFormat:@"%@%@-backdrop.jpg", movieImageDataURL, [self.movieDetailDictionary valueForKey:@"slug"]];
        
        [movieDetailBackgroundImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:movieImageURLString]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            if (image) {
    
                [movieDictionary setObject:image forKey:@"movieBackdropImage"];
                [movieDetailBackgroundImageView setImage:image];
            }
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
    
    else {
        
        [movieDetailBackgroundImageView setImage:[movieDictionary valueForKey:@"movieBackdropImage"]];
    }
    
    
    //Performs an asynchronous URL request in order to load in the Movie Image Cover to be used should it still not exists on the current dictionary keys.
    if ([self.movieDetailDictionary valueForKey:@"movieCoverImage"] == nil) {
        
        NSString *movieImageURLString = [NSString stringWithFormat:@"%@%@-cover.jpg", movieImageDataURL, [movieDictionary valueForKey:@"slug"]];
        
        [movieDetailMovieCoverImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:movieImageURLString]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            if (image) {

                
                [movieDictionary setObject:image forKey:@"movieCoverImage"];
                
                [movieDetailMovieCoverImageView setImage:image];
            }
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
    }
    
    else {
        
        [movieDetailMovieCoverImageView setImage:[movieDictionary valueForKey:@"movieCoverImage"]];
    }

}


#pragma mark - DEALLOCATION

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
