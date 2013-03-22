//
//  CardMatchingGame.m
//  CardGame
//
//  Created by Martin on 20/02/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGame()
@property(readwrite, nonatomic)int score;
@property(nonatomic)NSUInteger numberOfCards;
@property(strong,nonatomic)NSMutableArray *cards; //of Card
@property(strong,nonatomic)Deck *deck;
@end
@implementation CardMatchingGame


-(NSMutableArray *)cards
{
    if(!_cards){
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

-(NSMutableArray *)selectedCards
{
    if(!_selectedCards){
        _selectedCards = [[NSMutableArray alloc]init];
    }
    return _selectedCards;
}

-(NSUInteger)numbercOfCardMatchMode{
    if (_numbercOfCardMatchMode == 0) {
        _numbercOfCardMatchMode = 3;
    }
    return _numbercOfCardMatchMode;
}

-(void)flipCardAtIndex:(NSUInteger)index{
    if (!self.isStarted) {
        //set the game is stated
        self.started = !self.isStarted;
    }
    Card *card = [self cardAtIndex:index];
    [self.selectedCards removeAllObjects];

    if(card && !card.isUnplayable){
        //init the array for the cards to compare 
        NSMutableArray *scoreCoutingCards = [[NSMutableArray alloc] initWithObjects:nil];
        
        if(!card.isFaceUp){
            //Set the status to which card that are flipped.
            self.status = [NSString stringWithFormat:@"flipped"];
            //adding the newest selected card to the seletedCard array
            [self.selectedCards addObject:card];
            
            //Looking at all the card in the game and adds the one with the face up to the scoreCoutingCards array
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    [scoreCoutingCards addObject:otherCard];
                }
            }
            
            //if the number of the cards with their face up match the number Of Card that has to accour to make Match
            //then we are mathing them
            if([scoreCoutingCards count] == self.numbercOfCardMatchMode-1){
                int matchScore = [card match:scoreCoutingCards];
                if(matchScore){
                    //If there are a match the cards are made unplable and the score rewarded are added to the game score
                    //and the status is set with which card are matched.
                    for (Card *scoreCard in scoreCoutingCards) {
                        [self.selectedCards addObject:scoreCard];
                        scoreCard.unplayable = YES;
                    }
                    card.unplayable = YES;
                    self.score += matchScore * 4;
                    self.status = [NSString stringWithFormat:@"mached"];
                }else{
                    //If there aren't a match the penalty are added to the game score
                    //and the status is set with which card that didn't match.
                    for (Card *scoreCard in scoreCoutingCards) {
                        [self.selectedCards addObject:scoreCard];
                        scoreCard.faceUp = NO;
                    }
                    self.score -= 2;
                    self.status = [NSString stringWithFormat:@"don't match"];
                }
            }
            //The current card are set to the oppersit as it is in the current state.
            card.faceUp = !card.isFaceUp;
            //The card flip penalty are added to the game score
            self.score -= 1;
        }else{
            //All the cards are turn with face down.
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    otherCard.faceUp = NO;
                }
            }
        }
    }
}

-(Card *)cardAtIndex:(NSUInteger)index{
    //Finds which card that correspond an index.
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)reset{
    //resetting all the settings in the game.
    //and deals new cards
    [self.selectedCards removeAllObjects];
    self.started = !self.isStarted;
    self.status = @"New game";
    self.score = 0;
    [self dealCard];
    
}

-(void)dealCard{
    //Dealing card.
    //Creating a playingcard deck and selects a certain amount
    //of random cards and add them to the game

    for (int i = 0; i < self.numberOfCards; i++){
        Card *card = [self.deck drawRandomCard];
        if(card) {
            self.cards[i] = card;
        }else{
            break;
        }
    }
}
-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck NumberOfCardsToCompare: (NSUInteger)number{
    //inits the game by dealing cards.
    self.numbercOfCardMatchMode = number;
    self = [super init];
    self.numberOfCards = count;
    self.deck = deck;
    
    if(self){
        [self dealCard];
    }
    return self;
}
@end
