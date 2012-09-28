//
//  Created by somya on 9/28/12.
//
//


#import <Foundation/Foundation.h>

@interface KittenViewCell : UITableViewCell
{
	UIImageView * m_kittenImageView;
	NSString * m_url;
}
@property( nonatomic, retain ) UIImageView *kittenImageView;
@property( nonatomic, copy ) NSString *url;


@end