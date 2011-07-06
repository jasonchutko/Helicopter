//
//  HelicopterLayer.m
//  Helicopter
//
//  Created by Jason Chutko on 11-07-02.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelicopterLayer.h"

// HelicopterLayer implementation
@implementation HelicopterLayer

CCSprite *helicopterSprite;
CGSize size;

bool isTouching = false;
bool isStarted = false;
bool isOver = false;


CCLabelTTF *lblTitle;
CCLabelTTF *lblUnder;
CCLabelTTF *lblScore;
CCLabelTTF *lblGameOver;
CCLabelTTF *lblBest;

int offset = 0;

int score = 0;
int best = 0;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
    //hide the FPS label
    [[CCDirector sharedDirector] setDisplayFPS:NO];
	
	// 'layer' is an autorelease object.
	HelicopterLayer *layer = [HelicopterLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;
        [self schedule:@selector(nextFrame:)];
        
        gridArray = [[NSMutableArray alloc] init];
		
		// create and initialize a Label
		lblTitle = [CCLabelTTF labelWithString:@"Helicopter" fontName:@"Marker Felt" fontSize:64];
        lblUnder = [CCLabelTTF labelWithString:@"Press anywhere to continue" fontName:@"Marker Felt" fontSize:32];
        
		// ask director the the window size
		size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		lblTitle.position =  ccp( size.width /2 , size.height/2 );
        lblUnder.position = ccp(size.width/2, size.height/2 - 48);
		
		// add the label as a child to this Layer
		[self addChild: lblTitle];
        [self addChild: lblUnder];
	}
	return self;
}



-(void) addToArray
{
    int x = [gridArray count];
    
    int temp = arc4random() % 20;
    if((temp) % 2 == 0)
    {
        [gridArray addObject:[NSNumber numberWithInt:[[gridArray objectAtIndex:(x-1)] intValue] + (temp + 10)]];
    }
    else
    {
        [gridArray addObject:[NSNumber numberWithInt:[[gridArray objectAtIndex:(x-1)] intValue] - (temp + 10)]];
    } 
    
    if([[gridArray objectAtIndex:x] intValue] < 15)
    {
        [gridArray replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:[[gridArray objectAtIndex:x] intValue] + 20]];
    }
    
    else if([[gridArray objectAtIndex:x] intValue] > (size.height / 2) - 35)
    {
        [gridArray replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:[[gridArray objectAtIndex:x] intValue] - 20]];
    }
}

-(void) showGameOver
{
    isOver = true;
    [helicopterSprite setOpacity:128];
    lblGameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
    lblUnder = [CCLabelTTF labelWithString:@"Tap anywhere to play again" fontName:@"Marker Felt" fontSize:32];
    lblGameOver.position = ccp(size.width/2, size.height/2 + 16);
    lblUnder.position = ccp(size.width/2, size.height/2 - 32);
    [self addChild:lblGameOver];
    [self addChild:lblUnder];
}

-(void) nextFrame:(ccTime)dt
{
    if(isOver == true)
    {
        
    }
    else if(isStarted == true)
    {
        //offset += dt * 75;
        offset += floor(dt * 95);
        score++;
        
        if(score > best)
        {
            best = score;
        }
        
        
        [lblScore setString:[NSString stringWithFormat:@"%@%i", @"Score: ", score]];
        [lblBest setString:[NSString stringWithFormat:@"%@%i", @"Best: ", best]];
        
        if(offset > 16)
        {
            offset -= 16;
            [gridArray removeObjectAtIndex:0];
            [self addToArray];
        }
        
        if(isTouching == true)
        {
            helicopterSprite.position = ccp(150, helicopterSprite.position.y + dt*100);
        }
        
        else
        {
            helicopterSprite.position = ccp(150, helicopterSprite.position.y - dt*120);
        }
        
        if(helicopterSprite.position.y > (size.height - helicopterSprite.contentSizeInPixels.height/2) - [[gridArray objectAtIndex:10] intValue])
        {
            [self showGameOver];

        }
        
        if(helicopterSprite.position.y < (helicopterSprite.contentSizeInPixels.height)/2 + [[gridArray objectAtIndex:10] intValue])
        {
            [self showGameOver];
        }
    }
}

-(void) draw
{
    glEnable(GL_LINE_SMOOTH);
    
    glColor4ub(20, 209, 0, 255);
    glLineWidth(16);
    
    if(isOver == true)
    {
        for(int x = 0; x < size.width / 16; x++)
        {
            if(x <= 13)
            {
                ccDrawLine(ccp(x*16 - offset + 1, 0), ccp(x*16 - offset + 1, [[gridArray objectAtIndex:x] intValue]));
                ccDrawLine(ccp(x*16 - offset + 1, size.height), ccp(x*16 - offset + 1, size.height - [[gridArray objectAtIndex:x] intValue]));
            }
            
            else
            {
                ccDrawLine(ccp(x*16 - offset, 0), ccp(x*16 - offset, [[gridArray objectAtIndex:x] intValue]));
                ccDrawLine(ccp(x*16 - offset, size.height), ccp(x*16 - offset, size.height - [[gridArray objectAtIndex:x] intValue]));
            }
        }
        
        glColor4ub(255, 0, 0, 255);
        glLineWidth(1);
        
        ccDrawCircle(helicopterSprite.position, 40, 0, 100, NO);
    }
    
    else if(isStarted == true)
    {
        for(int x = 0; x < size.width / 16; x++)
        {
            ccDrawLine(ccp(x*16 - offset, 0), ccp(x*16 - offset, [[gridArray objectAtIndex:x] intValue]));
            ccDrawLine(ccp(x*16 - offset, size.height), ccp(x*16 - offset, size.height - [[gridArray objectAtIndex:x] intValue]));
        }
    }
}

-(void) setupScreen
{        
    [gridArray addObject:[NSNumber numberWithInt:5]];
        
    for(int x = 1; x < size.width / 16; x++)
    {
        [self addToArray];
        
    } 
    
    helicopterSprite = [CCSprite spriteWithFile:@"heli-small-white.png"];
    helicopterSprite.position = ccp(150, size.height / 2);
    [self addChild:helicopterSprite];
    
    lblScore = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:20];
    lblScore.position = ccp(10, size.height - 10);
    lblScore.anchorPoint = ccp(0, 1);
    
    lblBest = [CCLabelTTF labelWithString:@"Best: " fontName:@"Marker Felt" fontSize:20];
    lblBest.position = ccp(size.width - 20, size.height - 33);
    lblBest.anchorPoint = ccp(1, 0);
    
    
    [self addChild:lblScore];
    [self addChild:lblBest];
    
    isStarted = true;
}

-(void) removeTitle
{
    [self removeChild:lblTitle cleanup:YES];
    [self removeChild:lblUnder cleanup:YES];
    [self setupScreen];
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(isOver == true)
    {
        score = 0;
        [gridArray removeAllObjects];
        [self removeChild:helicopterSprite cleanup:YES];
        [self removeChild:lblScore cleanup:YES];
        [self removeChild:lblBest cleanup:YES];
        [self removeChild:lblGameOver cleanup:YES];
        [self removeChild:lblUnder cleanup:YES];
        [self setupScreen];
        isStarted = true;
        isOver = false;
    }
    
    if(isStarted == false)
    {
        //isStarted = true;
        [lblTitle runAction: [CCMoveTo actionWithDuration:1 position:ccp(size.width + 200, size.height + 200)]];
        [lblUnder runAction: [CCMoveTo actionWithDuration:1 position:ccp(size.width + 200, size.height + 200)]];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration: 1.5], [CCCallFunc actionWithTarget:self selector:@selector(removeTitle)], nil]];
    }
    
    else
    {
        isTouching = true;
    }
    
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    isTouching = false;
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end