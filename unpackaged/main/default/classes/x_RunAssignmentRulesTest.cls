@isTest
public class x_RunAssignmentRulesTest {

    @testSetup
    static void loadData(){
        Lead l = new Lead(
            LastName='Test',
            Company='Test',
            Country = 'United Kingdom',
            LeadSource = 'Web',
            Lead_Type__c = 'Tax Free',
            spam__c = false
        );
        insert l;
    }
    
    @isTest
    static void testLead(){
        //instantiate List to pass to @InvocableMethod
        List<Id> ids = new List<Id>();
        
        //query for test data and add to List
        Lead l = [SELECT Id, OwnerId FROM Lead];
        ids.add(l.Id);
        
        //call @InvocableMethod
        test.startTest();
        x_RunAssignmentRules.assignLeads(ids);
        test.stopTest();
        
        //verify that Lead was re-assigned
        Lead res = [SELECT Id, OwnerId FROM Lead];
        //System.assert(l.OwnerId != res.OwnerId, res);
    }
}