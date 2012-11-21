//
//  Activity.m
//  Kinesiology Review
//
//  Created by Devin Burke on 4/11/12.
//

#import "Activity.h"

@implementation Activity

@synthesize description = _description;
@synthesize videoURL = _videoURL;
@synthesize imageURL = _imageURL;
@synthesize imageData = _imageData;
@synthesize video = _video;
@synthesize answer = _answer;

//These methods were added for use in storing activities lists.  They're part of the NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_description forKey:@"description"];
	[aCoder encodeObject:_videoURL forKey:@"videoURL"];
    [aCoder encodeObject:_imageURL forKey:@"imageURL"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	_description = [aDecoder decodeObjectForKey:@"description"];
	_videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
	_video = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    _imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
	_imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
	[_video prepareToPlay];
	
	return self;
}

@end
