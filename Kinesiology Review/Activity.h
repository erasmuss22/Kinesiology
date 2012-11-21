//
//  Activity.h
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>


@interface Activity : NSObject <NSCoding> {
	NSString *description;
    NSString *answer;
	NSURL *videoURL;
    NSURL *imageURL;
    NSData *imageData;
	MPMoviePlayerController *video;
}

@property (strong) NSString *description;
@property (strong) NSURL *videoURL;
@property (strong) MPMoviePlayerController *video;
@property (strong) NSString *answer;
@property (strong) NSURL *imageURL;
@property (strong) NSData *imageData;


@end
