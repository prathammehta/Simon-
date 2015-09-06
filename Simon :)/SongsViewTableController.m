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
#import "ViewController.h"
#import "Sample.h"

@interface SongsViewTableController ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation SongsViewTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateOfCreation" ascending:YES]];
    self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
    
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = song.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"songSelected"])
    {
        ViewController *viewController = (ViewController *)segue.destinationViewController;
        viewController.didAppearFromNav = YES;
        [viewController performSelector:@selector(setSong:) withObject:[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delete song: %@",((Song *)[self.fetchedResultsController objectAtIndexPath:indexPath]).name);
    
    Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    for(Sample *sample in song.samples)
    {
        [self.context deleteObject:sample];
    }
    
    [self.context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [self.context save:nil];
    
//    if([self.tableView numberOfRowsInSection:0]==0)
//    {
//        [self.tableView setEditing:NO];
//    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL response){
        NSLog(@"Recording permission: %d",response);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text
                                              forKey:@"currentSongName"];
}

- (IBAction)editPressed:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:!self.tableView.editing];
}

@end
