/**
 * @description       : 
 * @author            : Florin Galea
 * @group             : 
 * @last modified on  : 03-03-2022
 * @last modified by  : Florin Galea
**/
public with sharing class POS_Solution_GetFlowRecords {
    //this invocable method takes a collection of ids from Flow from a record variable
    //and returns a list of lists of POS Solutions.
    //the list of lists is stored as a collection variable in the Flow.
    @InvocableMethod (label = 'Fetch Selected POS Solutions' description = 'returns lis of POS Solutions from collection of IDs.')
    
    //this method returns a List of Lists of POS Solutions to the flow and receives a List of Lists of Ids
    public static List<List<POS_Solution__c>> getPOSSolutions (List<List<String>> listOfIds) {
        List<String> theStringList = listOfIds.get(0);
        //Fetch all fields from 
        List<POS_Solution__c> posSolutions = [SELECT Account_Name__c,
                                                Account__c,
                                                //Associated_Owner__c,
                                                Comments__c,
                                                Comms_Type__c,
                                                //Deployment_Date__c,
                                                //EMV_Online_Keys__c,
                                                Elavon_TID__c,
                                                Firmware_Version__c,
                                                HDW_Version__c,
                                                IP_Address__c,
                                                Id,
                                                Name,
                                                OwnerId,
                                                Owning_Country__c,
                                                PCI_PTS_Approval_number__c,
                                                PCI_PTS_POI_Product_Type__c,
                                                PCI_PTS_Standard_version__c,
                                                PO_Number__c,
                                                PTS_Application_Version__c,
                                                Passport_Scanner__c,
                                                Password__c,
                                                Phone__c,
                                                Pinpad__c,
                                                Planned_Install_Date__c,
                                                Planned_Rollout_Date__c,
                                                Position__c,
                                                Post_Code__c,
                                                Primary_DNS__c,
                                                Print_Return_Label__c,
                                                Printer__c,
                                                Printing_Format__c,
                                                Product__c,
                                                Proposed_Solution_Store__c,
                                                Proposed_Solution__c,
                                                Province__c,
                                                Purchase_Date__c,
                                                //RecordTypeId,
                                                Reference_ID__c,
                                                Reference_or_Account_ID__c,
                                                Refund_Method_Obligatory__c,
                                                Return_Description__c,
                                                Return_Type__c,
                                                Rolled_Out__c,
                                                Rollout_Complete__c,
                                                SIM_Number__c,
                                                SS_DS_TRS_only__c,
                                                Secondary_DNS__c,
                                                Send_Fallback_Online_Email__c,
                                                Service_Type__c,
                                                Shipment_Type__c,
                                                Shop_Name__c,
                                                Shop_Owner__c,
                                                Software_Version__c,
                                                Solution_Delivery_Date__c,
                                                Solution_Rolled_Out__c,
                                                Solution__c,
                                                Static_IP__c,
                                                Status__c,
                                                TMS_TID__c,
                                                Tracking_Number__c,
                                                //Unit_Status__c,
                                                Unit__c,
                                                X3C_Instance_TID__c
                                FROM POS_Solution__c
                                WHERE Id 
                                IN :theStringList]; 
        //declare a new list of lists of POS Solutions
        List<List<POS_Solution__c>> itemListList = new List<List<POS_Solution__c>>();
        System.debug(posSolutions.size());
        //add the list of POS Solutions to the list of lists
        itemListList.add(posSolutions);
        System.debug(itemListList.size());
        // send list of lists to the Flow	
        return itemListList;        
    }  
}