//
//  ViewController.m
//  XLContactsFWDemo
//
//  Created by 徐林 on 15/10/25.
//  Copyright (c) 2015年 徐林. All rights reserved.
//

#import "ViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import "ContactReadViewController.h"


@interface ViewController ()<
    UITableViewDataSource,
    UITableViewDelegate
>{
    NSArray * arrData;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTV.delegate = self;
    self.mainTV.dataSource = self;
    [self.mainTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    arrData = @[@"CNContactPickerViewController",@"ContactReadViewController"];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [arrData objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * vcName = [arrData objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:{
            UIViewController * contactVC = [[NSClassFromString(vcName) alloc] init];
            [self addContacts];
            [self presentViewController:contactVC animated:YES completion:nil];
        }
            break;
        case 1:{
            UIViewController * readVC = [[NSClassFromString(vcName) alloc] init];
            [self.navigationController pushViewController:readVC animated:YES];
        }
        default:
            break;
    }
}
#pragma mark - private
-(void)addContacts{
    [self addContactsImage:@"icon-1" givenName:@"海贼王" familyName:@"小" homeEmail:@"865081690@163.com" workEmail:@"865081690@qq.com" phoneNumber:@"182********" homeAddressStreet:@"星湖街" homeAddressCity:@"苏州" homeAddressState:@"中国"];
    [self addContactsImage:@"icon-2" givenName:@"柯南" familyName:@"小" homeEmail:@"865081690@163.com" workEmail:@"865081690@qq.com" phoneNumber:@"182********" homeAddressStreet:@"二七区" homeAddressCity:@"郑州" homeAddressState:@"中国"];
    [self addContactsImage:@"icon-2" givenName:@"柯北" familyName:@"小" homeEmail:@"865081690@163.com" workEmail:@"865081690@qq.com" phoneNumber:@"182********" homeAddressStreet:@"二七区" homeAddressCity:@"郑州" homeAddressState:@"中国"];
}

-(void)addContactsImage:(NSString *)imageName givenName:(NSString *)givenName familyName:(NSString *)familyName  homeEmail:(NSString *)homeEmail workEmail:(NSString *)workEmail phoneNumber:(NSString *)phoneNumber homeAddressStreet:(NSString *)homeAddressStreet homeAddressCity:(NSString *)homeAddressCity homeAddressState:(NSString *)homeAddressState{
    //生成联系人
    CNMutableContact * contact = [[CNMutableContact alloc] init];
    //头像
    contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
    //名字
    contact.givenName = givenName;
    //姓氏
    contact.familyName = familyName;
    //邮箱
    CNLabeledValue * cHomeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeEmail];
    CNLabeledValue * cWorkEmail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:workEmail];
    contact.emailAddresses = @[cHomeEmail,cWorkEmail];
    //电话号码
    contact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]]];
    //家庭住址
    CNMutablePostalAddress * homeAddress = [[CNMutablePostalAddress alloc] init];
    homeAddress.street = homeAddressStreet;
    homeAddress.city = homeAddressCity;
    homeAddress.state = homeAddressState;
    contact.postalAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAddress]];
    //保存请求
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    //上下文
    CNContactStore * store = [[CNContactStore alloc] init];
    [store executeSaveRequest:saveRequest error:nil];
}
@end
