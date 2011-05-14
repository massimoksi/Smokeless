//
//  NoteView.h
//  Smokeless
//
//  Created by Massimo Peri on 08/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoteView : UIImageView {
	UILabel *_message;
}

@property (nonatomic, retain) UILabel *message;

@end
