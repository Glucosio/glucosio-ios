#import "GLUCIndexedListEditorViewController.h"
#import "UIColor+GLUCAdditions.h"
#import "GLUCLoc.h"
#import "GLUCEditorViewController.h"

static NSString *const kGLUCGLUCIndexedCellIdentifier = @"ItemCell";


@interface GLUCIndexedListEditorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *indexes;
@property (strong, nonatomic) NSMutableDictionary *indexedItems;

@end


@implementation GLUCIndexedListEditorViewController

#pragma mark -
#pragma mark ViewController's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark -
#pragma mark Actions

- (IBAction)save:(UIBarButtonItem *)sender {
    
    if (self.editedObject) {
        if ([self.editedObject propertyIsIndirectLookup:self.editedProperty]) {
            NSString *selectedValue = self.items[self.selectedItemIndex];
            
            if (selectedValue && selectedValue.length) {
                NSNumber *lookupIndex = [self.editedObject lookupIndexFromDisplayValue:selectedValue forKey:self.editedProperty];
                if (lookupIndex) {
                    [self.editedObject setValueFromLookupAtIndex:lookupIndex forKey:self.editedProperty];
                }
                
            }
        }
    } else {
        [self.editedObject setValueFromLookupAtIndex:@(self.selectedItemIndex) forKey:self.editedProperty];
    }
    
    [super save:nil];
}

#pragma mark -
#pragma mark Accessors

- (NSMutableDictionary *)indexedItems {
    if (_indexedItems == nil) {
        _indexedItems = [NSMutableDictionary dictionary];
    }
    
    return _indexedItems;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self indexItems:_items];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *index = self.indexes[section];
    return ((NSArray *) self.indexedItems[index]).count;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexes[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGLUCGLUCIndexedCellIdentifier forIndexPath:indexPath];
    
    //Setup cell to avoid showing checkmark in wrong recycled cell
    NSString *item = [self itemAtIndexPath:indexPath];
    if ([item isEqualToString:[self.items objectAtIndex:self.selectedItemIndex]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = item;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selectedObject = [self itemAtIndexPath:indexPath];
    self.selectedItemIndex = [self.items indexOfObject:selectedObject];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark -
#pragma mark Private methods

- (void)setupUI
{
    self.tableView.tintColor = [UIColor glucosio_pink];
}

- (void)indexItems:(NSArray *)items
{
    NSArray *sortedItems = [items sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
 
    NSMutableSet *firstLetterSet = [NSMutableSet set];
    
    for (NSString *item in sortedItems) {
        NSString *firstLetter = [item substringToIndex:1];
        [firstLetterSet addObject:firstLetter];
        
        NSMutableArray *sameStartingLetterArray =self.indexedItems[firstLetter];
        
        if (sameStartingLetterArray == nil) {
            sameStartingLetterArray = [NSMutableArray array];
            self.indexedItems[firstLetter] = sameStartingLetterArray;
        }
        
        [sameStartingLetterArray addObject:item];
    }
    
    self.indexes = [[firstLetterSet allObjects]
                sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *index = self.indexes[indexPath.section];
    NSArray *subItems = self.indexedItems[index];
    return subItems[indexPath.row];
}


@end
