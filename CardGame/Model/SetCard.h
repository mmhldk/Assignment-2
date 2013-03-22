//
//  SetCard.h
//  CardGame
//
//  Created by Martin on 14/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card

@property (nonatomic)NSNumber *number; // the number the card have
@property (nonatomic)NSString *shading; // the shading the card have
@property (strong, nonatomic)NSString *symbol; // the symbol the card have
@property (strong, nonatomic)NSArray *color; // the color the card have

+(NSArray*)validNumbers; //all the numbers that can accur on a card
+(NSArray*)validShadings; //all the shadings that can accur on a card
+(NSArray*)validSymbols; //all the symbols that can accur on a card
+(NSArray*)validColors; //all the scolors that can accur on a card

@end


