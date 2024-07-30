public class QBMap {
    
    public static String mapAccountData(Account acc){
        try{
            QBAccountJSON.Account qba = new QBAccountJSON.Account();
            qba.Id = acc.QBO_Id__c;
            qba.SyncToken = acc.QBO_SyncToken__c;
            qba.Name = acc.Name;
            qba.AccountType = 'Accounts Receivable';
            return JSON.serialize(qba, True);
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
    
    public static String mapContactData(Contact con){
        try{
            QBCustomerJSON.Customer customer = new QBCustomerJSON.Customer();
            customer.FullyQualifiedName = con.Name;
            if(con.FirstName == null){
                customer.GivenName = '';
            }else{
                customer.GivenName = con.FirstName;
            }
            
            customer.FamilyName = con.LastName;
            customer.CompanyName = con.account.Name;
            if(con.FirstName == null){
                customer.DisplayName = con.LastName;
            }else{
                customer.DisplayName = con.FirstName + ' ' + con.LastName;
            }
            
            customer.Taxable = True;
            customer.SyncToken = con.QBO_SyncToken__c;
            customer.sparse = True;
            customer.PrintOnCheckName = con.Account.Name;
            
            QBCustomerJSON.PrimaryPhone phone = new QBCustomerJSON.PrimaryPhone();
            phone.FreeFormNumber = con.Phone;
            customer.PrimaryPhone = phone;
            
            QBCustomerJSON.PrimaryEmailAddr email = new QBCustomerJSON.PrimaryEmailAddr();
            email.Address = con.Email;
            customer.PrimaryEmailAddr = email; 
            
            customer.BillWithParent = True;
            customer.Job = false;
            customer.IsProject = False;
            customer.Id = con.QBO_ID__c;
            
            QBCustomerJSON.BillAddr billAddy = new QBCustomerJSON.BillAddr();
            billAddy.City = con.Account.BillingCity;
            billAddy.Line1 = con.Account.BillingStreet;
            billAddy.CountrySubDivisionCode = con.Account.BillingState;
            billAddy.PostalCode = con.Account.BillingPostalCode;
            billAddy.Country = con.Account.BillingCountry;
            billAddy.Lat = String.valueOf(con.Account.BillingLatitude);
            billAddy.Long_x = String.valueOf(con.Account.BillingLongitude);
            customer.BillAddr = billAddy;
            
            QBCustomerJSON.BillAddr shipAddy = new QBCustomerJSON.BillAddr();
            shipAddy.City = con.Account.ShippingCity;
            shipAddy.Line1 = con.Account.ShippingStreet;
            shipAddy.CountrySubDivisionCode = con.Account.ShippingState;
            shipAddy.PostalCode = con.Account.ShippingPostalCode;
            shipAddy.Country = con.Account.ShippingCountry;
            customer.ShipAddr = shipAddy;
            
            
            customer.Active = True;
            return JSON.serialize(customer, True);
            
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
    
    public static String mapProductData(Product2 scooter, Decimal quantity){
        try{
            QBProductJSON.Item js = new QBProductJSON.Item();
            System.debug('Name ' + scooter.Name);
            js.Name = scooter.Name.replaceAll('\\s+', ' ');
            js.Id = scooter.QBO_Id__c;
            js.SyncToken = scooter.QBO_SyncToken__c;
            js.Sku = scooter.Vin_Number__c;
            if(scooter.Model__c != null){
                js.Description = 'Model: ' + scooter.Model__c;
            }
            if(quantity == null){
                js.QtyOnHand = 0;
            }else{
                js.QtyOnHand = Integer.valueOf(quantity); 
            }
            if(scooter.Type__c == 'Rent' || scooter.service__c == true){
                js.Type = 'Service';
            }else{
                js.Type = 'Inventory';
                js.TrackQtyOnHand = true;
            }
            
            js.InvStartDate = String.valueOf(System.today());
            
            QBProductJSON.ExpenseAccountRef eaf = new QBProductJSON.ExpenseAccountRef();
            eaf.name = 'Cost of Goods Sold';
            eaf.value = label.Cost_of_Goods_Sold;
            js.ExpenseAccountRef = eaf;
            
            QBProductJSON.AssetAccountRef aaf = new QBProductJSON.AssetAccountRef();
            aaf.name = 'Inventory Asset';
            aaf.value = label.Inventory_Asset;
            js.AssetAccountRef = aaf;
            
            QBProductJSON.IncomeAccountRef iar = new QBProductJSON.IncomeAccountRef();
            iar.name = 'Sales of Product Income';
            iar.value = label.Sales_of_Product_Income;
            js.IncomeAccountRef = iar;
            
            js.PurchaseCost = scooter.Price__c;
            return JSON.serialize(js, True);
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
    
    public static String mapProductAssignmentData(Scooter__c scooter, Scooter_Assignment__c assignment){
        try{
            QBProductJSON.Item js = new QBProductJSON.Item();
            js.Name = scooter.Name + ' (' + assignment.Name + ')';
            js.Sku = scooter.Scooter_Full_VIN__c + ' (' + scooter.Type__c + ')';
            js.Id = assignment.QBO_Id__c;
            js.SyncToken = assignment.QBO_SyncToken__c;
            
            js.QtyOnHand = 0; 
            if(scooter.Type__c == 'Rent'){
                js.Type = 'Service';
            }else{
                js.Type = 'Inventory';
                js.TrackQtyOnHand = true;
            }
            
            js.InvStartDate = String.valueOf(System.today());
            
            QBProductJSON.ExpenseAccountRef eaf = new QBProductJSON.ExpenseAccountRef();
            eaf.name = 'Cost of Goods Sold';
            eaf.value = label.Cost_of_Goods_Sold;
            js.ExpenseAccountRef = eaf;
            
            QBProductJSON.AssetAccountRef aaf = new QBProductJSON.AssetAccountRef();
            aaf.name = 'Inventory Asset';
            aaf.value = label.Inventory_Asset;
            js.AssetAccountRef = aaf;
            
            QBProductJSON.IncomeAccountRef iar = new QBProductJSON.IncomeAccountRef();
            iar.name = 'Sales of Product Income';
            iar.value = label.Sales_of_Product_Income;
            js.IncomeAccountRef = iar;
            
            js.PurchaseCost = scooter.Price__c;
            return JSON.serialize(js, True);
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
    
    public static String mapScooterMaintenanceData(Scooter__c scooter, Scooter_Maintenance__c maintenance){
        try{
            QBProductJSON.Item js = new QBProductJSON.Item();
            js.Name = maintenance.Name + ' (Maintenance)';
            js.Sku =  scooter.Scooter_Full_VIN__c;
            js.Id = maintenance.QBO_Id__c;
            js.SyncToken = maintenance.QBO_SyncToken__c;
            js.Description = 'Rider Name: ' + maintenance.Rider__c + '\n' + 'Scooter Name: ' + scooter.Name;
            js.Type = 'Service';
            
            js.InvStartDate = String.valueOf(System.today());
            
            QBProductJSON.ExpenseAccountRef eaf = new QBProductJSON.ExpenseAccountRef();
            eaf.name = 'Cost of Goods Sold';
            eaf.value = label.Cost_of_Goods_Sold;
            js.ExpenseAccountRef = eaf;
            
            QBProductJSON.AssetAccountRef aaf = new QBProductJSON.AssetAccountRef();
            aaf.name = 'Inventory Asset';
            aaf.value = label.Inventory_Asset;
            js.AssetAccountRef = aaf;
            
            QBProductJSON.IncomeAccountRef iar = new QBProductJSON.IncomeAccountRef();
            iar.name = 'Sales of Product Income';
            iar.value = label.Sales_of_Product_Income;
            js.IncomeAccountRef = iar;
            
            if(maintenance.Price__c != null){
                js.PurchaseCost = maintenance.Price__c;
            }else{
                js.PurchaseCost = 0;
            }
            
            //js.Description = maintenance.Description__c;
            return JSON.serialize(js, True);
            
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
    
    public static String mapInvoice(mPOS__Transaction__c trans, List<mPOS__EPOS_Item__c> eposItemList){
        try{
            QBInvoiceJSON invoiceObj = new QBInvoiceJSON();
            
            /*QBInvoiceJSON.CustomField cf = new QBInvoiceJSON.CustomField();   
cf.Name = 'SalesId';
cf.DefinitionId = '1'; 
cf.Type = 'StringType'; 
cf.StringValue = 'Gaurav';

invoiceObj.CustomField = new List<QBInvoiceJSON.CustomField>();
invoiceObj.CustomField.add(cf);*/
            
            
            invoiceObj.Id = trans.QBO_Id__c;
            invoiceObj.SyncToken = trans.QBO_SyncToken__c;
            invoiceObj.DueDate = Date.today()+10;
            invoiceObj.AllowOnlineACHPayment = True;
            invoiceObj.AllowOnlineCreditCardPayment = True;
            String invNumber = trans.mPOS__Order_Number__c;
            invoiceObj.DocNumber  = invNumber;
            invoiceObj.EmailStatus = 'NotSet';
            QBInvoiceJSON.EmailAddress email = new QBInvoiceJSON.EmailAddress();
            email.Address = trans.mPOS__Order__r.mPOS__Contact__r.Email;
            invoiceObj.BillEmail = email;
            
            QBInvoiceJSON.CustomerRef customerRef = new QBInvoiceJSON.CustomerRef();
            customerRef.value = trans.mPOS__Order__r.mPOS__Contact__r.QBO_Id__c;
            invoiceObj.CustomerRef = customerRef;
            
            QBInvoiceJSON.MemoRef memoRef = new QBInvoiceJSON.MemoRef();
            memoRef.value = trans.mPOS__Headline__c;
            invoiceObj.CustomerMemo = memoRef;
            
            QBInvoiceJSON.SalesTermRef sales = new QBInvoiceJSON.SalesTermRef();
            sales.value = label.SalesTermRef;
            invoiceObj.SalesTermRef = sales;
            
            QBInvoiceJSON.BillAddr billAddy = new QBInvoiceJSON.BillAddr();
            billAddy.City = trans.mPOS__Order__r.mPOS__Billing_City__c;
            billAddy.Line1 = trans.mPOS__Order__r.mPOS__Billing_Street__c;
            billAddy.CountrySubDivisionCode = trans.mPOS__Order__r.mPOS__Billing_State__c;
            billAddy.PostalCode = trans.mPOS__Order__r.mPOS__Billing_PostalCode__c;
            billAddy.Country = trans.mPOS__Order__r.mPOS__Billing_Country__c;
            invoiceObj.BillAddr = billAddy;
            
            
            invoiceObj.Line = new List<QBInvoiceJSON.Line>();
            
            for(integer i = 0; i < eposItemList.Size(); i++){
                QBInvoiceJSON.Line line = new QBInvoiceJSON.Line();
                QBInvoiceJSON.SalesItemLineDetail detail = new QBInvoiceJSON.SalesItemLineDetail();
                QBInvoiceJSON.ItemRef itemRef = new QBInvoiceJSON.ItemRef();
                itemRef.name = 'Sales';
                itemRef.value = eposItemList[i].mPOS__Product__r.QBO_Id__c; 
                detail.ItemRef = itemRef;
                detail.TaxCodeRef = new QBInvoiceJSON.ItemRef();
                detail.TaxCodeRef.value = 'TAX';
                detail.Qty = Integer.valueOf(eposItemList[i].mPOS__Quantity__c);
                
                line.Amount = eposItemList[i].mPOS__Total_Price_With_Tax__c;
                line.DetailType = 'SalesItemLineDetail';
                line.SalesItemLineDetail = detail;
                invoiceObj.Line.add(line);
            }
            
            
            return JSON.serialize(invoiceObj, True).replace('"Long_x":', '"Long":');
            
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
    
    public static String mapPayment(mPOS__Transaction__c trans, String qboId){
        try{
            QBPaymentJSON paymentObj = new QBPaymentJSON();
            paymentObj.TotalAmt = Math.abs(trans.mPOS__Total_Amount__c);
            
            paymentObj.CustomerRef = new QBPaymentJSON.CustomerRef();
            paymentObj.CustomerRef.value = trans.mPOS__Order__r.mPOS__Contact__r.QBO_Id__c;
            
            paymentObj.PaymentMethodRef = new QBPaymentJSON.PaymentMethodRef();
            if(trans.mPOS__Payment_Type__c == label.CashRef){
                paymentObj.PaymentMethodRef.value = label.CashRefValue;
            }else if(trans.mPOS__Payment_Type__c == label.CheckRef){
                paymentObj.PaymentMethodRef.value = label.CheckRefValue;
            }else if(trans.mPOS__Payment_Type__c == label.CardRefExt || trans.mPOS__Payment_Type__c == label.CardRef){
                paymentObj.PaymentMethodRef.value = label.CardRefValue;
            }
            
            paymentObj.Line = new List<QBPaymentJSON.Line>();
            
            
            QBPaymentJSON.Line lines = new QBPaymentJSON.Line();
            lines.Amount = Math.abs(trans.mPOS__Total_Amount__c);
            
            lines.LinkedTxn = new List<QBPaymentJSON.LinkedTxn>();  
            
            QBPaymentJSON.LinkedTxn linkedTxn = new QBPaymentJSON.LinkedTxn();
            linkedTxn.TxnId = qboId;
            linkedTxn.TxnType = 'Invoice';
            
            paymentObj.Line.add(lines);
            lines.LinkedTxn.add(linkedTxn);
            System.debug(JSON.serialize(paymentObj, True));
            return JSON.serialize(paymentObj, True);
        }Catch(Exception ex){
            HandleCustomException.LogException(ex);
            return ex.getMessage();
        }
    }
}