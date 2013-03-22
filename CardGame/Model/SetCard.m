//
//  SetCard.m
//  CardGame
//
//  Created by Martin on 14/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(int)match:(NSArray *)otherCards{
    int score = 0;
    if ([otherCards count] == 2) {
        //If we have all the cards need to furfill the game rules
        //Retreiving the two cards to match with.
        SetCard *cardOne = otherCards[0];
        SetCard *cardTwo = otherCards[1];
        
        //Matching the numbers to see if all the card has different number
        if (self.number != cardOne.number && self.number != cardTwo.number && cardTwo.number != cardOne.number) {
            score++;
        }
        //Matching the numbers to see if the cards has the same number
        if (self.number == cardOne.number && self.number == cardTwo.number && cardTwo.number == cardOne.number) {
            score++;
        }
        //Matching the shading to see if the cards has the same shading
        if ([self.shading isEqualToString:cardOne.shading] && [self.shading isEqualToString:cardTwo.shading] && [cardTwo.shading isEqualToString:cardOne.shading]) {
            score++;
        }
        //Matching the shading to see if all the card has different shading
        if (![self.shading isEqualToString:cardOne.shading] && ![self.shading isEqualToString:cardTwo.shading] && ![cardTwo.shading isEqualToString:cardOne.shading]) {
            score++;
        }//Matching the color to see if the cards has the same color
        if ([self.color isEqualToArray:cardOne.color] && [self.color isEqualToArray:cardTwo.color] && [cardTwo.color isEqualToArray:cardOne.color]) {
            score++;
        }
        //Matching the color to see if all the card has different color
        if (![self.color isEqualToArray:cardOne.color] && ![self.color isEqualToArray:cardTwo.color] && ![cardTwo.color isEqualToArray:cardOne.color]) {
            score++;
        }
        //Matching the symbol to see if the cards has the same symbol
        if ([self.symbol isEqualToString:cardOne.symbol] && [self.symbol isEqualToString:cardTwo.symbol] && [cardTwo.symbol isEqualToString:cardOne.symbol]) {
            score++;
        }
        //Matching the symbol to see if all the card has different symbol
        if (![self.symbol isEqualToString:cardOne.symbol] && ![self.symbol isEqualToString:cardTwo.symbol] && ![cardTwo.symbol isEqualToString:cardOne.symbol]) {
            score++;
        }
    }
    //return the score that are rewarded if there are some matches.
    return score;
}
//all the numbers that can accur on a card
+(NSArray*)validNumbers{
    return @[@1,@2,@3];
}
//all the colors that can accur on a card
+(NSArray*)validColors{
    return @[@[@255.0,@0.0,@0.0],@[@0.0,@255.0,@0.0],@[@255.0,@0.0,@255.0]];
}
//all the sahdings that can accur on a card
+(NSArray*)validShadings{
    return @[@"0.4",@"0.7",@"1"];
}
//all the symbols that can accur on a card
+(NSArray*)validSymbols{
    return @[@"▲",@"■",@"●"];
}

@end
