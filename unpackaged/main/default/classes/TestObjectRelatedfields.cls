@isTest
private class TestObjectRelatedfields
{
    static testMethod void ObjectRelatedfields()
    {
       MttlObjectRelatedfieldscontroller ofc= new MttlObjectRelatedfieldscontroller(); 
       ofc.searchrecords(); 
       ofc.getObjectNames();
       ofc.getObjectFields();
    }  
}