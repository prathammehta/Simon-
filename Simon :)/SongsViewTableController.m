//
//  SongsViewTableController.m
//  Simon :)
//
//  Created by Pratham Mehta on 22/01/15.
//  Copyright (c) 2015 Pratham Mehta. All rights reserved.
//

#import "SongsViewTableController.h"
#import "AppDelegate.h"
#import "Song+Operations.h"

@interface SongsViewTableController ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation SongsViewTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
    
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = song.name;
    
    return cell;
}

- (IBAction)addSongPressed:(UIBarButtonItem *)sender
{
    [Song insertSongWithName:[NSString stringWithFormat:@"Song %lu",(unsigned long)self.fetchedResultsController.fetchedObjects.count+1]
                 withContext:self.context];
    [self.context save:nil];
}

@end
