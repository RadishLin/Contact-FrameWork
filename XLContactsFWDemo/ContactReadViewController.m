//
//  ContactReadViewController.m
//  XLContactsFWDemo
//
//  Created by Mac020 on 15/10/26.
//  Copyright © 2015年 徐林. All rights reserved.
//

#import "ContactReadViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ContactReadViewController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    CNContactPickerDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *mainTV;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellContact;
@property (weak, nonatomic) IBOutlet UITextField *txtContactName;
@property (weak, nonatomic) IBOutlet UITextField *txtContactPhone;
@property (nonatomic, strong) CNContact * contact;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFormatName;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@end

@implementation ContactReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTV.delegate = self;
    self.mainTV.dataSource = self;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return self.cellContact;
        }
            break;
        case 1:{
            return self.cellFormatName;
        }
            break;
        case 2:{
            return self.cellSearch;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - CNContactPickerDelegate
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
     self.txtContactName.text  = contact.givenName;
     CNLabeledValue * value = [contact.phoneNumbers firstObject];
     CNPhoneNumber * phone = value.value;
     self.txtContactPhone.text = phone.stringValue;
     self.contact = contact;
}

#pragma mark - private

/* 获取某个联系人姓名和联系电话 */
- (IBAction)didPressedReadContact:(id)sender {
    CNContactPickerViewController * contactVC= [[CNContactPickerViewController alloc] init];
    contactVC.delegate = self;
    [self presentViewController:contactVC animated:YES completion:nil];
}

/* 格式化姓名 */
- (IBAction)didPressedName:(id)sender {
    self.txtName.text  =  [CNContactFormatter stringFromContact:self.contact style:CNContactFormatterStyleFullName];
}
/* 检索事件 */
- (IBAction)didPressedSearch:(id)sender {
    CNContactStore * store = [[CNContactStore alloc] init];
    //检索条件 检索所有名字中含有柯的联系人
    NSPredicate * predicate = [CNContact predicateForContactsMatchingName:@"柯"];
    //提取数据
    NSArray * contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactGivenNameKey] error:nil];
    //展示
    NSMutableString * searchName = [[NSMutableString alloc] init];
    [contacts enumerateObjectsUsingBlock:^(CNContact * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [searchName  appendString: obj.givenName];
    }];
    self.txtSearch.text = searchName;
    
//    CNContactStore * stroe = [[CNContactStore alloc]init];
//    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactPhoneticFamilyNameKey]];
//    [stroe enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//        NSLog(@"%@",contact);
//    }];
    
}
@end
