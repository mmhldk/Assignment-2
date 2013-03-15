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

/*-(void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}*/

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
        _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtonCollection count] usingDeck:self.deck];
    }
    return _game;
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    self.game.numbercOfCardMatchMode = index + 2;
    
}


-(void)updateUI{
    for (UIButton *cardButton in self.cardButtonCollection) {
        Card *card = [self.game cardAtIndex:[self.cardButtonCollection indexOfObject:cardButton]];
        
        NSAttributedString *content = [self createAttributedStringFromCard:(SetCard *)card];
        
        [cardButton setAttributedTitle:content forState:UIControlStateSelected];
        [cardButton setAttributedTitle:content forState:UIControlStateSelected|
         UIControlStateDisabled];
        //[cardButton setBackgroundImage:self.deck.cardBacksideBackgroundImage forState:UIControlStateNormal];
        //[cardButton setBackgroundImage:self.deck.cardFrontsideBackgroundImage forState:UIControlStateSelected];
        
        cardButton.selected = card.isFaceUp;
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
    //NSMutableDictionary *attributes = [NSDictionary dictionaryWithObject:color forKey:NSStrokeColorAttributeName];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    
    if([card.shading isEqual:[SetCard validShadings][0] ]){
        [attributes setObject:color forKey:NSStrokeColorAttributeName];
        [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        [attributes setObject:[[UIColor grayColor] colorWithAlphaComponent:0.2] forKey:NSForegroundColorAttributeName];
    }
    if([card.shading isEqual:[SetCard validShadings][1]]){
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    if([card.shading isEqual:[SetCard validShadings][2]]){
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
-(NSAttributedString *)createStatusMessage{
    NSMutableAttributedString *stringX = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@", self.game.status]];
    if([self.game.selectedCards count] == 3){
        for(SetCard *card in self.game.selectedCards){
            [stringX insertAttributedString:[self createAttributedStringFromCard:card] atIndex:0];
        }
    }else if([self.game.selectedCards count]){
        [stringX insertAttributedString:[self createAttributedStringFromCard:self.game.selectedCards[0]] atIndex:0];
    }
    [self.status removeAllObjects];
    return stringX;
}

- (IBAction)dealNew:(UIButton *)sender {
    [self.game reset];
    self.flipCount = 0;
    [self updateUI];
}

-(void)setFlipCount:(NSUInteger)flipCount{
    _flipCount = flipCount;
    self.flipLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}
- (IBAction)flipCard:(UIButton *)sender {
    self.flipCount++;
    [self.game flipCardAtIndex:[self.cardButtonCollection indexOfObject:sender]];
    [self updateUI];
    
}


@end
