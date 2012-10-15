//
//  Created by somya on 9/28/12.
//
//


#import <Foundation/Foundation.h>

@interface KittenViewCell : UITableViewCell
{
	UIImageView *m_leftKittenImageView;
	UIImageView *m_rightKittenImageView;
	NSString *m_leftUrl;
	NSString *m_rightUrl;
}
@property( nonatomic, retain ) UIImageView *leftKittenImageView;
@property( nonatomic, retain ) UIImageView *rightKittenImageView;
@property( atomic, copy ) NSString *leftUrl;
@property( atomic, copy ) NSString *rightUrl;

- (void)loadImages;


@end