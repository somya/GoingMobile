//
//  Created by somya on 9/28/12.
//
//


#import <Foundation/Foundation.h>

@interface KittenViewCell : UITableViewCell
{
	UIImageView *m_leftKittenImageView;
	UIImageView *m_rightKittenImageView;
@private
	NSString *m_urlLeft;
	NSString *m_urlRight;
}
@property( nonatomic, retain ) UIImageView *leftKittenImageView;
@property( nonatomic, retain ) UIImageView *rightKittenImageView;
@property( nonatomic, copy ) NSString *urlLeft;
@property( nonatomic, copy ) NSString *urlRight;

- (void)loadImages;


@end