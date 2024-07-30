@isTest
public class riderFileUploadJ1ControllerTest {
    
    public static testmethod void testAll(){
        
        string riderRecTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Rider').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.Name  = 'Test Account';
        objAcc.RecordTypeId = accRecordTypeId;
        insert objAcc;
        
        integer noOfDays= integer.valueOf(label.No_Of_Days_for_SS_registration_reminder_Email);
        date dtFilter= system.today().addDays(noOfDays*(-1));
        date bDate= System.Date.today().addYears(-30);
        string strBDate=   ( bDate.month()>10? string.valueOf(bDate.month()): '0'+string.valueOf(bDate.month())) +'/'+ 
            ( bDate.day()>10? string.valueOf(bDate.day()):'0'+string.valueOf(bDate.day()) ) + '/'+
            (string.valueOf(bDate.year()) );
        
        Contact objContact = new Contact();
        objContact.LastName = 'Contact LastName';
        objContact.AccountId = objAcc.Id;
        objContact.RecordTypeId = riderRecTypeId;
        //objContact.Graduated_Override__c ='Graduated';
        objContact.FirstName='test';
        objContact.LastName='TestLast';
        objContact.Email ='testsam@test.com';
        objContact.Insurance_Verification_Date__c  =system.today();
        objContact.Employment_Verification_Date__c  =system.today();
        objContact.SS_Classroom_Completed__c= dtFilter;
        objContact.Birthdate= bDate;
        //objContact.Funnel_Stage__c='1-IV&EV Complete';
        insert objContact;
        
        riderFileUploadJ1Controller.getContactDetailsById(objContact.Id);
        riderFileUploadJ1Controller.getContactDetails('testsam@test.com',bDate);
        riderFileUploadJ1Controller.getContactDetailsMobile('testsam@test.com',strBDate);
        
        Temp_Files__c objTemp = new Temp_Files__c(Contact__c=objContact.Id);
        insert objTemp;
        
        list<ContentVersion> listCV= new  list<ContentVersion>();
        
        ContentVersion objCV = new ContentVersion(
            Title = 'test1',
            PathOnClient = 'test1.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        listCV.add(objCV);
        
        
        objCV = new ContentVersion(
            Title = 'test2',
            PathOnClient = 'test2.jpg',
            VersionData = Blob.valueOf('Test Contentwww'),
            IsMajorVersion = true
        );
        listCV.add(objCV);
        insert listCV;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];     
        ContentDocumentLink objCDLink = new ContentDocumentLink();
        objCDLink.ContentDocumentId = documents[0].Id;
        objCDLink.LinkedEntityId= objTemp.id;
        objCDLink.ShareType='V';
        insert objCDLink;
        
        riderFileUploadJ1Controller.pocessFileUpload(objContact.Id, objTemp.id);
        riderFileUploadJ1Controller.deleteFile(documents[0].id);
        riderFileUploadJ1Controller.deleteNewFiles(new list<string>{documents[1].Id});
        
    }
    
    
}