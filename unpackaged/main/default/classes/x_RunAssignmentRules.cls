public class x_RunAssignmentRules {
    
    @InvocableMethod(label='Run Lead Assignment' description='Run Lead Assignment')
    public static void assignLeads(List<Id> leadIds){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = TRUE;
        dmo.EmailHeader.triggerUserEmail = TRUE;
        List<Lead> toAssign = [SELECT Id FROM Lead WHERE Id = :leadIds];
        Database.update(toAssign,dmo);
    }
    
}