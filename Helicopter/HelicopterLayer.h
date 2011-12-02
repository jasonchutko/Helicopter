//
//  HelicopterLayer.h
//  Helicopter
//
//  Created by Jason Chutko on 11-07-02.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelicopterLayer
@interface HelicopterLayer : CCLayer
{
    NSMutableArray *gridArray;
}

// returns a CCScene that contains the HelicopterLayer as the only child
+(CCScene *) scene;

@end
