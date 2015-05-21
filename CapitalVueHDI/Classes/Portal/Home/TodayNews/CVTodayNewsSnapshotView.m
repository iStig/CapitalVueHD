//
//  CVTodayNewsSnapshotView.m
//  CapitalVueHD
//
//  Created by jishen on 9/10/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVTodayNewsSnapshotView.h"

#import "CVPortal.h"

@interface CVTodayNewsSnapshotView()

/*
 * It loads the data of image from the remote server
 *
 * @param: none
 * @return: none
 */
- (void)loadImage;

@end

@implementation CVTodayNewsSnapshotView

@synthesize imageUrl;
@synthesize postId;

@synthesize thumbnailView;
@synthesize newsTitleLabel;
@synthesize articleButton;

@synthesize dictNews;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		assert([self retainCount]==1);
		self.autoresizesSubviews = NO;
		self.autoresizingMask = UIViewAutoresizingNone;
		self.backgroundColor = [UIColor clearColor];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"cv_news_default_logo.png" ofType:nil];
		UIImage *imgDefault = [[UIImage alloc] initWithContentsOfFile:path];
		UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 228, 160)];
		imgv.image = imgDefault;
		[imgDefault release];
		
		[self addSubview:imgv];
		self.thumbnailView = imgv;
		[imgv release];
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(1, 162, 229, 44)];
		lbl.textAlignment = UITextAlignmentLeft;
		lbl.numberOfLines = 2;
		lbl.font = [UIFont systemFontOfSize:14];
		lbl.backgroundColor = [UIColor whiteColor];
		[self addSubview:lbl];
		self.newsTitleLabel = lbl;
		[lbl release];
		
		self.articleButton = [UIButton buttonWithType:UIButtonTypeCustom];
		articleButton.frame = CGRectMake(1, 1, 229, 204);
		[articleButton addTarget:self action:@selector(goNewsArticle) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:articleButton];
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


-(void)adjustTitleLabel{
	NSString *theText = newsTitleLabel.text;
	CGSize labelSize = newsTitleLabel.frame.size;
	CGSize theStringSize = [theText sizeWithFont:newsTitleLabel.font constrainedToSize:labelSize lineBreakMode:newsTitleLabel.lineBreakMode];
	newsTitleLabel.frame = CGRectMake(newsTitleLabel.frame.origin.x, newsTitleLabel.frame.origin.y, theStringSize.width, theStringSize.height);
	newsTitleLabel.text = theText;
}

- (void)dealloc {
	[postId release];
	[imageUrl release];
	
	[thumbnailView release];
	[newsTitleLabel release];
	[articleButton release];
	
	[dictNews release];
	
    [super dealloc];
}


#pragma mark private methods
/*
 * It loads the data of image from the remote server
 *
 * @param: none
 * @return: none
 */
- (void)loadImage {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *url = [NSURL URLWithString:imageUrl];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *image;
	
	image = [[UIImage alloc] initWithData:imageData];
	NSLog(@"image before changed:%@",image);
	if (image){
		UIImage *cropImage;
		CGFloat originWidth = image.size.width;
		CGFloat originHeight = image.size.height;
		CGFloat uiImageWidth = 228.0;
		CGFloat uiImageHeight = 160.0;
		if (originWidth/originHeight > uiImageWidth/uiImageHeight) {
			CGFloat cropWidth = uiImageWidth*(originHeight/uiImageHeight);
			CGFloat cropLeftWidth = (originWidth - cropWidth)/2;
			cropImage = [image croppedImage:CGRectMake(cropLeftWidth, 0, cropWidth, originHeight)];
		}else {
			CGFloat cropHeight = uiImageHeight*(originWidth/uiImageWidth);
			CGFloat cropTopHeight = (originHeight - cropHeight)/2;
			cropImage = [image croppedImage:CGRectMake(0, cropTopHeight, originWidth, cropHeight)];
		}
		thumbnailView.image = cropImage;
		
	}
	
	[image release];
	[pool release];
}

/*
 * It responds the tapping and switches to news portalset
 * where article of news is shown.
 *
 * @param: sender - the obj recieves the event of tap. Here is the articleButton.
 * @return: none
 */
- (void)goNewsArticle{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithInt:4] forKey:@"Number"];
	[dict setObject:dictNews forKey:@"dictContent"];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:CVPortalSwitchPortalSetNotification object:dict];
	[dict release];
}

@end
