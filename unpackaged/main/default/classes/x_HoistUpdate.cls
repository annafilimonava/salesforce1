public class x_HoistUpdate {

    public static final String PROPOSAL_SIGNED = 'Contract Signed';
    
    public static void processData(String strBatch)
    {
        
        
        //List of opportunities to update
        List<Opportunity> opportunities = new List<Opportunity>();
        //List of accounts to update
        List<Account> accounts = new List<Account>();
        //List of hoist_update__c to update
        List<Hoist_Update__c> hoistUpdates = new List<Hoist_Update__c>();
        
        Boolean hoistRecFound = false;

        //get the hoist update - new custom object where admin loads the weekly data
        List<Hoist_Update__c> lstHoistUpdateObjs = new List<Hoist_Update__c>();    
        
        lstHoistUpdateObjs = [SELECT Id, Batch__c, UpsalesAccId__c, UpsalesOppId__c, Stage__c,  Current_Payments_provider_used__c, current_Payments_contract_expiry__c,
                              Current_POS_provider_used__c, current_POS_contract_expiry__c, Reason_on_Hold__c, Reason_Lost__c
                            FROM Hoist_Update__c
                            WHERE Batch__c = :strBatch
                            ];
        
        //get list of UpsalesAccIds from the hoist updates
        List<String> lstHoistUpSalesAccIds = new List<String>();   
        for(Hoist_Update__c hoistId :lstHoistUpdateObjs){
        	lstHoistUpSalesAccIds.add(hoistId.UpsalesAccId__c);
        }
        
        //use the hoist accountids to find the account records
        List <Account> lstAccs = [SELECT Id, POS_System__c,Current_POS_Contract_End_Date__c,Hotel_Current_Payment_Provider__c, 
                                          Residual_Payments_Contract_End_Date__c,Reason_Account_On_Hold__c, Upsales_AccID__c 
                                      FROM Account 
                                      WHERE Upsales_AccID__c = :lstHoistUpSalesAccIds 
                                      ];        
        
        //get list of Account Ids from the hoist updates using the hoist account id
        List<String> lstHoistAccountIds = new List<String>();   
        for(Account acc :lstAccs){
        	lstHoistAccountIds.add(acc.Id);
        }
        
        //use the Account Ids to find the Opportunity records
        List <Opportunity> lstOpps = [SELECT Id, StageName, Upsales_OppID__c, Reason_for_Loss__c, AccountId 
                                      FROM Opportunity 
                                      WHERE AccountId = :lstHoistAccountIds 
                                      ];
        
    
		//loop through updates        
        for(Hoist_Update__c hoistUpdate :lstHoistUpdateObjs){
            
            hoistRecFound = false;
            
            //may not have a hoist opp id, so need to find the account
            for(Account hoistAcc :lstAccs){
                if(hoistAcc.Upsales_AccID__c == hoistUpdate.UpsalesAccId__c){
                    
                    hoistRecFound = true;
                    
                    //update Account fields
                            
                    //picklist
                    hoistAcc.POS_System__c = hoistUpdate.Current_POS_provider_used__c;
                    //date
                    hoistAcc.Current_POS_Contract_End_Date__c = hoistUpdate.current_POS_contract_expiry__c;
                    //text
                    hoistAcc.Hotel_Current_Payment_Provider__c = hoistUpdate.Current_Payments_provider_used__c;
                    //date
                    hoistAcc.Residual_Payments_Contract_End_Date__c = hoistUpdate.current_Payments_contract_expiry__c;
                    //text
                    hoistAcc.Reason_Account_On_Hold__c = hoistUpdate.Reason_on_Hold__c;
                            
                    accounts.add(hoistAcc);                    
                    
                    for(Opportunity hoistOpp :lstOpps){
                        //only update opportunity if stage is not already Proposal Signed
                    	if((hoistOpp.AccountId == hoistAcc.Id) && (hoistOpp.StageName != PROPOSAL_SIGNED)){
                            //update the related opp
                            
                        	//convert the stage - picklist
                        	String sfStage = convertStage(hoistUpdate.Stage__c);
                        	if(sfStage != null){
                            	hoistOpp.StageName = sfStage;                            
                            	//update the hoist status so that final finance approval fires
                            	if (sfStage == PROPOSAL_SIGNED){
                                	//also set the status
                                	hoistOpp.Approval_Status__c = 'Approved';
                            	}  
                                
                                if (hoistUpdate.UpsalesOppId__c != null){
                                    //update the opportunity upsalesoppid
                                	hoistOpp.Upsales_OppID__c = hoistUpdate.UpsalesOppId__c;
                                }
                                
                                //update Reason Lost - picklist
                    			hoistOpp.Reason_for_Loss__c = hoistUpdate.Reason_Lost__c;
                        	} 

                            //** update upsales opp id
                    	    opportunities.add(hoistOpp);
                        }                                     

                    }   //opp 
              
                }	//if
            
            }//acc
            
            if(hoistRecFound == false){
                hoistUpdate.Notes__c = 'UpsalesID Not Found';
            }else
            {
                hoistUpdate.Notes__c = 'UpsalesID Found';
            }
            hoistUpdates.add(hoistUpdate);
            
        }
            
        update opportunities;
        update accounts;
        update hoistUpdates;
    }   
    
    //converts the stage
   	public static String convertStage(String hoistStage) {
    	String strStage = null;
        
        //updated 22/6/22 for stage renames
        switch on hoistStage{
            when 'Prospect Research'{
                strStage = 'Opportunity Recorded'; 
            }
            when 'Qualification'{
                strStage = 'Prospect Qualified'; 
            }
            when 'Needs Analysis'{
                strStage = 'Value Proposition Presented';  
            }
            when 'Quotation'{
                strStage = 'Proposal Submitted'; 
            }
            when 'Closing'{
                strStage = 'Proposal Submitted'; 
            }
            when 'Won'{
                strStage = 'Contract Signed'; 
            }
            when 'Lost'{
                strStage = 'Proposal Lost'; 
            }
            when 'On Hold'{
                strStage = 'Proposal Lost'; 
            }
            when else{
                
            }
        }
        
        return strStage;


    }

}