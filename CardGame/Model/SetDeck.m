//
//  SetDeck.m
//  CardGame
//
//  Created by Martin on 14/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

-(id)init{
    
    self = [super init];
    if (self) {
        [self redeal];
    }
    return self;
}

-(void)redeal{
    //runs through all the shading
    for (NSString *shading in [SetCard validShadings]) {
        //runs through all the symbol
        for (NSString *symbol in [SetCard validSymbols]) {
            //runs through all the color
            for (NSArray *color in [SetCard validColors]) {
                //runs through all the number
                for (NSNumber *number in [SetCard validNumbers]) {
                    //Creating a card and sets it's number, color, symbol and shading.
                    SetCard *card = [[SetCard alloc]init];
                    card.number = number;
                    card.color = color;
                    card.symbol = symbol;
                    card.shading = shading;
                    //adding the card to the deck at the top
                    [self addCard:card atTop:YES];
                }
            }
        }
    }
}

@end
