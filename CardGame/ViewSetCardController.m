//
//  ViewSetCardController.m
//  CardGame
//
//  Created by Martin on 14/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "ViewSetCardController.h"
#import "CardMatchingGame.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "Card.h"

@interface ViewSetCardController ()


@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtonCollection;
@property (strong, nonatomic) SetDeck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger flipCount;
@property (strong, nonatomic) NSMutableArray *status;


@end

@implementation ViewSetCardController

#define INIT_NUMBER_OF_CARD_MODE 3
-(NSMutableArray*)status{
    if (!_status) {
        _status = [[NSMutableArray alloc] init];
    }
    return _status;
}
-(SetDeck*)deck
{
    if(!_deck){
        _deck = [[SetDeck alloc] init];
    }
    return _deck;
}

-(CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtonCollection count] usingDeck:self.deck  NumberOfCardsToCompare: INIT_NUMBER_OF_CARD_MODE];
    }
    return _game;
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    self.game.numbercOfCardMatchMode = index + 2;
    
}


-(void)updateUI{
    //Updating all the buttons in the view one by one.
    for (UIButton *cardButton in self.cardButtonCollection) {
        //Retreiving the card from thh button
        Card *card = [self.game cardAtIndex:[self.cardButtonCollection indexOfObject:cardButton]];
        
        NSAttributedString *content = [self createAttributedStringFromCard:(SetCard *)card];
        //Setting the content the card will show when the button are seleted.
        [cardButton setAttributedTitle:content forState:UIControlStateSelected];
        //Setting the content the card will show when the card is matched with an other card.
        [cardButton setAttributedTitle:content forState:UIControlStateSelected|
         UIControlStateDisabled];

        //Set which side of the card is upward.
        cardButton.selected = card.isFaceUp;
        //Set if the card is out of the game
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1);
    }
    
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.statusLabel.text = self.game.status;
    self.statusLabel.attributedText = [self createStatusMessage];
    
}
-(NSAttributedString *)createAttributedStringFromCard:(SetCard *)card{
    UIColor *color = [UIColor colorWithRed:[card.color[0] floatValue] green:[card.color[1] floatValue] blue:[card.color[2] floatValue] alpha:1];
    NSString *symbol = @"";
    
    //Creating the attributes dict
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    
    //Adding shading and the color to the attributes dict
    if([card.shading isEqual:[SetCard validShadings][0] ]){
        //Setting stripped shading by making the middle gray and the stoke the color of the card 
        [attributes setObject:color forKey:NSStrokeColorAttributeName];
        [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [attributes setObject:[[UIColor grayColor] colorWithAlphaComponent:0.2] forKey:NSForegroundColorAttributeName];
    }
    if([card.shading isEqual:[SetCard validShadings][1]]){
        //Setting solid shading by filling with a color  
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    if([card.shading isEqual:[SetCard validShadings][2]]){
        //Setting stripped shading by making the middle white and the stoke the color of the card 
        [attributes setObject:color forKey:NSStrokeColorAttributeName];
        [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    for (int i = 0; i < [card.number intValue]; i++) {
        symbol = [NSString stringWithFormat:@"%@%@", symbol,card.symbol];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", symbol] attributes:attributes];
  
    if(card.faceUp){
        [self.status addObject:attString];
    }
    return attString;
    
}
//Creating the status messag
-(NSAttributedString *)createStatusMessage{
    NSMutableAttributedString *stringX = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@", self.game.status]];
    if([self.game.selectedCards count] == 3){
        //takes the cards in the array and creates a AttributedString from them 
        for(SetCard *card in self.game.selectedCards){
            [stringX insertAttributedString:[self createAttributedStringFromCard:card] atIndex:0];
        }
    }else if([self.game.selectedCards count]){
        //takes the first card in the array and creates a AttributedString.
        [stringX insertAttributedString:[self createAttributedStringFromCard:self.game.selectedCards[0]] atIndex:0];
    }
    [self.status removeAllObjects];
    return stringX;
}

- (IBAction)dealNew:(UIButton *)sender {
    //When pressing the button the game is reset and the view are updated.
    [self.game reset];
    self.flipCount = 0;
    [self updateUI];
}

-(void)setFlipCount:(NSUInteger)flipCount{
    //Setting the flipcounter and updating the flipCounter label in the view
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}
- (IBAction)flipCard:(UIButton *)sender {
    //Flipping a card
    //setting the flipcount + 1
    self.flipCount++;
    //Sending the card from the button to the model for playing the game.
    [self.game flipCardAtIndex:[self.cardButtonCollection indexOfObject:sender]];
    //redrawing the view.
    [self updateUI];
    
}


@end
