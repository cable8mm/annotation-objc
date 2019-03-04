//
//  PictureCollectionViewController.h
//  Annotation
//
//  Created by 이삼구 on 10/02/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PictureCollectionViewController : UICollectionViewController
@property (nonatomic) int os_picture_type_id;
@property (nonatomic, retain) NSString *typeName;
@end

NS_ASSUME_NONNULL_END
