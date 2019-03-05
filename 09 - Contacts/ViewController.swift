//
//  ViewController.swift
//  student
//
//  Created by weizhen on 2019/1/9.
//  Copyright © 2019 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit
import Contacts

/// 当 notDetermined 状态时, requestAccess会令询问框弹出, 用户做出选择后才触发它的回调方法
/// 当 authorized 状态时, requestAccess的回调函数的第一个参数返回true
/// 当 denied 状态时, requestAccess的回调函数的第一个参数返回false
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView : UITableView!
    
    private var contacts = [CNContact]()
    
    private var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kCellReuseIdentifier")
        view.addSubview(tableView)
        
        CNContactStore().requestAccess(for: .contacts, completionHandler: loadContacts)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(contact.familyName) \(contact.givenName)"
        cell.detailTextLabel?.text = contact.phoneNumbers.first?.value.stringValue
        return cell
    }
    
    func loadContacts(granted: Bool, error: Error?) {

        if let error = error {
            print("连接出错: \(error.localizedDescription)")
            return
        }
        
        // 获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        // 判断当前授权状态
        guard status == .authorized else {
            print("没有授权: \(status.rawValue)")
            return
        }
        
        // 获取Fetch,并且指定要获取联系人中的什么属性
        let keys = [CNContactFamilyNameKey,
                    CNContactGivenNameKey,
                    CNContactNicknameKey,
                    CNContactOrganizationNameKey,
                    CNContactJobTitleKey,
                    CNContactDepartmentNameKey,
                    CNContactNoteKey,
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey,
                    CNContactPostalAddressesKey,
                    CNContactDatesKey,
                    CNContactInstantMessageAddressesKey]
        
        // 创建请求对象，需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含'CNKeyDescriptor'类型的数组
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = .familyName
        
        // 遍历所有联系人
        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: loadSomeone)
        } catch {
            print("加载失败: \(error.localizedDescription)")
        }
    }
    
    func loadSomeone(contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) {
        contacts.append(contact)
        
        let familyName = contact.familyName
        let givenName = contact.givenName
        print("姓名: \(familyName) \(givenName)")
        
        let nickname = contact.nickname
        print("昵称: \(nickname)")
        
        let organization = contact.organizationName
        print("公司（组织）: \(organization)")
        
        let jobTitle = contact.jobTitle
        print("职位: \(jobTitle)")
        
        let department = contact.departmentName
        print("部门: \(department)")
        
        let note = contact.note
        print("备注: \(note)")
        
        print("电话: ")
        for labeledValue in contact.phoneNumbers {
            let label = CNLabeledValue<NSString>.localizedString(forLabel: labeledValue.label!)
            let value = labeledValue.value
            print("\t\(label): \(value.stringValue)")
        }
        
        print("Email: ")
        for labeledValue in contact.emailAddresses {
            let label = CNLabeledValue<NSString>.localizedString(forLabel: labeledValue.label!)
            let value = labeledValue.value
            print("\t\(label): \(value as String)")
        }
        
        print("地址: ")
        for labeledValue in contact.postalAddresses {
            let label = CNLabeledValue<NSString>.localizedString(forLabel: labeledValue.label!)
            let value = labeledValue.value
            let contry = value.value(forKey: CNPostalAddressCountryKey) ?? "null"
            let state = value.value(forKey: CNPostalAddressStateKey) ?? "null"
            let city = value.value(forKey: CNPostalAddressCityKey) ?? "null"
            let street = value.value(forKey: CNPostalAddressStreetKey) ?? "null"
            let code = value.value(forKey: CNPostalAddressPostalCodeKey) ?? "null"
            print("\t\(label): 国家:\(contry) - 省:\(state) - 城市:\(city) - 街道:\(street) - 邮编:\(code)")
        }
        
        print("纪念日: ")
        for labeledValue in contact.dates {
            let label = CNLabeledValue<NSString>.localizedString(forLabel: labeledValue.label!)
            let value = labeledValue.value
            let date = Calendar.current.date(from: value as DateComponents)!
            print("\t\(label): \(dateFormatter.string(from: date))")
        }
        
        print("即时通讯(IM): ")
        for labeledValue in contact.instantMessageAddresses {
            let label = CNLabeledValue<NSString>.localizedString(forLabel: labeledValue.label!)
            let value = labeledValue.value
            let username = value.value(forKey: CNInstantMessageAddressUsernameKey) ?? "null"
            let service = value.value(forKey: CNInstantMessageAddressServiceKey) ?? "null"
            print("\t\(label): 账号:\(username) 服务:\(service)")
        }
        
        print("----------------")
    }
}

