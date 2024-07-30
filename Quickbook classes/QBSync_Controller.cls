public class QBSync_Controller {
    
    private static QB_Metadata__mdt QBData;
    
    public QBSync_Controller() {
        try{
            QBData = [SELECT Id, Base_Url__c, Company_Id__c, Minor_Version__c FROM QB_Metadata__mdt];
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    public void synchronizeAccount(Set<Id> accountIds) {
        try{
            List<Account> accountsToSync = [SELECT Id, Name, QBO_Id__c, QBO_SyncToken__c FROM Account WHERE Id In :accountIds];
            Map<Id, Account> accountMapToUpdate = new Map<Id, Account>();
            QBCallouts callout = new QBCallouts();
            for (Account acc : accountsToSync) {
                QBAccountResponseJSON response = callout.createAccountCall(acc, QBData);
                
                if (response.Account.Id != null || response.Account.SyncToken != null) {
                    acc.QBO_Id__c = response.Account.Id;
                    acc.QBO_SyncToken__c = response.Account.SyncToken;
                    accountMapToUpdate.put(acc.Id, acc);
                }
            }
            
            callout.updateRefreshToken();
            
            if (!accountMapToUpdate.isEmpty()) {
                update accountMapToUpdate.values();
            }
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    public void synchronizeContact(Set<Id> contactIds) {
        try{
            List<Contact> contactsToSync = [SELECT Id, Name, AccountId, Phone, Email, QBO_SyncToken__c, LastName, FirstName, QBO_Id__c, Account.BillingCity, Account.Name,
                                            Account.BillingStreet, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,
                                            Account.BillingLatitude, Account.BillingLongitude, Account.ShippingCity, Account.ShippingStreet,
                                            Account.ShippingState, Account.ShippingPostalCode, Account.ShippingCountry
                                            FROM Contact WHERE Id IN :contactIds];
            Map<Id, Contact> contactMapToUpdate = new Map<Id, Contact>();
            QBCallouts callout = new QBCallouts();
            for (Contact con : contactsToSync) {
                QBCustomerResponseJSON response = callout.createCustomerCall(con, QBData);
                if (response.Customer.Id != null || response.Customer.SyncToken != null) {
                    con.QBO_Id__c = response.Customer.Id;
                    con.QBO_SyncToken__c = response.Customer.SyncToken;
                    contactMapToUpdate.put(con.Id, con);
                }
            }
            callout.updateRefreshToken();
            
            if (!contactMapToUpdate.isEmpty()) {
                update contactMapToUpdate.values();
            }
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    public void synchronizeProduct(Set<Id> productIds) {
        try{
            
            List<Product2> productsToSync = [SELECT Id, Name, QBO_SyncToken__c, QBO_Id__c, Vin_Number__c, service__c, mPOS__Stock_Level__c, Type__c, Price__c, Model__c
                                             From Product2 Where Id IN :productIds];
            
            if(!productsToSync.isEmpty()){
                Map<Id, Product2> productMapToUpdate = new Map<Id, Product2>();
                
                QBCallouts callout = new QBCallouts();
                
                for (Product2 prod : productsToSync) {
                    QBProductResponseJSON itemPushData = callout.createProductCall(prod, QBData, prod.mPOS__Stock_Level__c);
                    if (itemPushData.Item != null){
                        if(itemPushData.Item.Id != null || itemPushData.Item.SyncToken != null){
                            prod.QBO_ID__c = itemPushData.Item.Id;
                            prod.QBO_SyncToken__c = itemPushData.Item.SyncToken;
                            productMapToUpdate.put(prod.Id, prod);
                        }
                    }
                }
                
                
                callout.updateRefreshToken();
                
                if (!productMapToUpdate.isEmpty()) {
                    update productMapToUpdate.values();
                }
            }
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    public void synchronizeAssignment(Set<Id> scooterAssignmentIds) {
        try{
            List<Scooter_Assignment__c> scooterAssignment = [SELECT Id, Name, QBO_SyncToken__c, QBO_Id__c, Scooter__c FROM Scooter_Assignment__c where Id IN :scooterAssignmentIds];
            Map<Id, Scooter_Assignment__c> assignmentMapToUpdate = new Map<Id, Scooter_Assignment__c>();
            
            Set<Id> scooterIds = new Set<Id>();
            
            for (Scooter_Assignment__c assignment : scooterAssignment) {
                scooterIds.add(assignment.Scooter__c);
            }
            
            Map<Id, Scooter__c> scootersMap = new Map<Id, Scooter__c>([SELECT Id, Name, QBO_SyncToken__c, QBO_Id__c, Scooter_Full_VIN__c, Scooter_Model__c, Type__c, Price__c FROM Scooter__c WHERE Id IN :scooterIds]);
            
            QBCallouts callout = new QBCallouts();
            
            for (Scooter_Assignment__c assignment : scooterAssignment) {
                Scooter__c scoot = scootersMap.get(assignment.Scooter__c);
                if (scoot != null && scoot.Type__c == 'Sold') {
                    QBProductResponseJSON itemPushData = callout.createProductAssignmentCall(scoot, assignment, QBData);
                    if (itemPushData.Item.Id != null || itemPushData.Item.SyncToken != null) {
                        assignment.QBO_ID__c = itemPushData.Item.Id;
                        assignment.QBO_SyncToken__c = itemPushData.Item.SyncToken;
                        assignmentMapToUpdate.put(assignment.Id, assignment);
                    }
                }
            }
            callout.updateRefreshToken();
            if (!assignmentMapToUpdate.isEmpty()) {
                update assignmentMapToUpdate.values();
            }
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    public void synchronizeTransaction(Set<Id> transactionIds) {
        try{
            Map<Id, mPOS__Transaction__c> transactionMapToUpdate = new Map<Id, mPOS__Transaction__c>();
            
            Map<Id, mPOS__Transaction__c> transactionMap = new Map<Id, mPOS__Transaction__c>(
                [SELECT Id, Name, QBO_Id__c, QBO_SyncToken__c, mPOS__Total_Amount__c, mPOS__Order_Number__c, 
                 mPOS__Order__r.mPOS__Billing_City__c, mPOS__Order__r.mPOS__Billing_Country__c, 
                 mPOS__Order__r.mPOS__Billing_PostalCode__c, mPOS__Order__r.mPOS__Billing_State__c, 
                 mPOS__Order__r.mPOS__Billing_Street__c, mPOS__Order__r.mPOS__Contact__r.Email,
                 mPOS__Order__r.mPOS__Contact__r.QBO_Id__c, mPOS__Payment_Type__c,
                 mPOS__Amount_Tendered__c, mPOS__Headline__c
                 FROM mPOS__Transaction__c WHERE Id IN :transactionIds]
            );
            
            Set<Id> orderIds = new Set<Id>();
            Map<Id, List<mPOS__EPOS_Item__c>> eposItemMap = new Map<Id, List<mPOS__EPOS_Item__c>>();
            
            for (mPOS__Transaction__c transactions : transactionMap.values()) {
                orderIds.add(transactions.mPOS__Order__c);
            }
            
            for (mPOS__EPOS_Item__c eposItem : [SELECT Id, Name, mPOS__Total_Price_With_Tax__c, mPOS__Unit_Price_Paid_With_Tax__c, mPOS__EPOS_Order__c, mPOS__Product__r.QBO_Id__c, mPOS__Product__r.QBO_SyncToken__c, mPOS__Quantity__c FROM mPOS__EPOS_Item__c WHERE mPOS__EPOS_Order__c IN :orderIds]) {
                if (!eposItemMap.containsKey(eposItem.mPOS__EPOS_Order__c)) {
                    eposItemMap.put(eposItem.mPOS__EPOS_Order__c, new List<mPOS__EPOS_Item__c>());
                }
                eposItemMap.get(eposItem.mPOS__EPOS_Order__c).add(eposItem);
            }
            
            
            Map<Id, mPOS__Transaction__c> earliestTransactionMap = new Map<Id, mPOS__Transaction__c>();
            for (Id orderId : orderIds) {
                earliestTransactionMap.put(orderId, [SELECT Id, Name, CreatedDate, QBO_Id__c, QBO_SyncToken__c, mPOS__Order__c 
                                                     FROM mPOS__Transaction__c 
                                                     WHERE mPOS__Order__c = :orderId 
                                                     ORDER BY CreatedDate ASC 
                                                     LIMIT 1]);
            }
            
            QBCallouts callout = new QBCallouts();
            for (mPOS__Transaction__c trans : transactionMap.Values()) {
                mPOS__Transaction__c earliestTransactions = earliestTransactionMap.get(trans.mPOS__Order__c);
                if(!String.isEmpty(earliestTransactions.QBO_Id__c)){
                    QBPaymentResponseJSON pay = callout.createPaymentCall(trans, earliestTransactions.QBO_Id__c, QBData);
                    trans.QBO_Payment_Id__c = pay.Payment.Id;
                    trans.QBO_Payment_Sync_Token__c = pay.Payment.SyncToken;
                    transactionMapToUpdate.put(trans.Id, trans);
                }else{
                    List<mPOS__EPOS_Item__c> eposItemList = eposItemMap.get(trans.mPOS__Order__c);
                    QBInvoiceResponseJSON res = callout.createInvoiceCall(trans, eposItemList, QBData);
                    QBPaymentResponseJSON pay = callout.createPaymentCall(trans, res.Invoice.Id, QBData);
                    trans.QBO_Id__c = res.Invoice.Id;
                    trans.QBO_SyncToken__c = res.Invoice.SyncToken;
                    trans.QBO_Payment_Id__c = pay.Payment.Id;
                    trans.QBO_Payment_Sync_Token__c = pay.Payment.SyncToken;
                    transactionMapToUpdate.put(trans.Id, trans);
                }
                
            }
            
            callout.updateRefreshToken();
            if (!transactionMapToUpdate.isEmpty()) {
                update transactionMapToUpdate.values();
            }
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
    public void synchronizeMaintenance(Set<Id> maintenanceIds) {
        try{
            List<Scooter_Maintenance__c> maintenanceToSync = [SELECT Id, Name, QBO_Id__c, QBO_SyncToken__c, Rider__c, Scooter__c, Price__c
                                                              FROM Scooter_Maintenance__c WHERE ID IN :maintenanceIds];
            
            Map<Id, Scooter_Maintenance__c> maintenanceMapToUpdate = new Map<Id, Scooter_Maintenance__c>();
            
            Set<Id> scooterIds = new Set<Id>();
            
            for (Scooter_Maintenance__c maintenance : maintenanceToSync) {
                scooterIds.add(maintenance.Scooter__c);
            }
            
            Map<Id, Scooter__c> scootersMap = new Map<Id, Scooter__c>([SELECT Id, Name, QBO_SyncToken__c, QBO_Id__c, Scooter_Full_VIN__c, 
                                                                       Scooter_Model__c, Type__c, Price__c
                                                                       FROM Scooter__c WHERE Id IN :scooterIds]);
            
            QBCallouts callout = new QBCallouts();
            
            for (Scooter_Maintenance__c maintenance : maintenanceToSync) {
                Scooter__c scoot = scootersMap.get(maintenance.Scooter__c);
                QBProductResponseJSON itemPushData = callout.createMaintenanceCall(scoot, maintenance, QBData);
                if (itemPushData.Item.Id != null || itemPushData.Item.SyncToken != null) {
                    maintenance.QBO_ID__c = itemPushData.Item.Id;
                    maintenance.QBO_SyncToken__c = itemPushData.Item.SyncToken;
                    maintenanceMapToUpdate.put(maintenance.Id, maintenance);
                }
            }
            callout.updateRefreshToken();
            if (!maintenanceMapToUpdate.isEmpty()) {
                update maintenanceMapToUpdate.values();
            }
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
        }
    }
    
}