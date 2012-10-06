//
//  Created by somya on 9/28/12.
//
//


#import <Foundation/Foundation.h>

@interface KittenViewCell : UITableViewCell
{
	UIImageView *m_leftKittenImageView;
	UIImageView *m_rightKittenImageView;
}
@property( nonatomic, retain ) UIImageView *leftKittenImageView;
@property( nonatomic, retain ) UIImageView *rightKittenImageView;

- (void)loadImages;


@end