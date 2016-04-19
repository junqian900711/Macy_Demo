//
//  ViewController.m
//  MacyDemo
//
//  Created by 钱骏 on 16/4/18.
//  Copyright © 2016年 钱骏. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "DataModels.h"
#import "MBProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)searchPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong,nonatomic)BaseClass *baseClass;

@end

//a flag used to show the state of the tableview
int flag;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self customerUI];
}

//custom the UI conponent
-(void)customerUI{
    [self.tblView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    self.view.backgroundColor = [UIColor clearColor];
    self.searchButton.layer.cornerRadius = 8;
    self.searchTF.layer.cornerRadius = 5;
    self.searchTF.returnKeyType = UIReturnKeySearch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//button press to search the information form customer typing
- (IBAction)searchPress:(id)sender {
    [self.searchTF resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self jsonParse:self.searchTF.text];
}

//method to parse the data form the url
-(void)jsonParse:(NSString *)inputString{
    //filter the string with only letter characters left
    NSString *filterString = [[inputString componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    //AFNetworking to parse data
    //Choose configuration as default 
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //define the url to get the fetch data
    NSString *URLStringFormat = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:URLStringFormat,filterString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //create the urlSessiomDataTask
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if(error){
            //if the error and set flag is 0, updata the UI and shows the network error
            flag = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showAlert:@"Networking error"];
            });
        }
        else{//if have the data, shows the flag as 1 and update UI, reload the data in the tableView
            id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if([jsonData firstObject]){
                flag = 1;
                _baseClass = [[BaseClass alloc] initWithDictionary:jsonData[0]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tblView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            
            else{  //if the network works fine, and no data, update UI here
                flag = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlert:@"No Resault founded on the server"];
                    [_tblView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            
        }
    }];
    
    [dataTask resume];
}


#pragma show alert

-(void)showAlert:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction  *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:^{
    }];
}


#pragma show textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if([textField.text length] == 0){
        _baseClass = nil;
        [_tblView reloadData];
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [self jsonParse:_searchTF.text];
    }
    return true;
}


#pragma for delegate of the TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(flag == 1){
        return _baseClass.lfs.count;
    }
    else{
        return 0;
    }
}

//the information in different cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:identifier];
    
    cell.textLabel.text = [_baseClass.lfs[indexPath.row] valueForKey:@"lf"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"The Frequency: %@",[_baseClass.lfs[indexPath.row] valueForKey:@"freq"]];
    
    cell.layer.cornerRadius = 8;
    cell.contentView.layer.cornerRadius = 8;
    cell.contentView.layer.borderColor = [UIColor purpleColor].CGColor;
    cell.contentView.layer.borderWidth = 2;
    return cell;
}

@end
