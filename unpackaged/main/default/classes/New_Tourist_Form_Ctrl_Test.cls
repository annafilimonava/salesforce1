@isTest
public class New_Tourist_Form_Ctrl_Test {
    static testMethod void New_Tourist_Form_Ctrl_Test_Mtd(){
        Test.startTest();
        
        Id touristRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tourist').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'Test Record';
        acc.LastName = 'Test Record';
        acc.RecordTypeId = touristRecordTypeId;
        acc.Owning_Country__c = 'Poland';
        acc.Company_Sector__c = 'Retail';
        insert acc; 
        
        Tax_Free_Form__c tff = new Tax_Free_Form__c();
        tff.Name = '132464178521';
        insert tff;

        Test.setCurrentPageReference(new PageReference('Page.New_Tourist_Form')); 
        System.currentPageReference().getParameters().put('ttfId', tff.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(tff);
        New_Tourist_Form_Ctrl ntf = new New_Tourist_Form_Ctrl(sc);
        ntf.saveAcc();
        ntf.cancelAcc();
        
        Test.stopTest();
    }
}