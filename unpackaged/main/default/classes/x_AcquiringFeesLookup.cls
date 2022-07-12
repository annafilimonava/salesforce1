/**
 * @description       : 
 * @author            : Mickey
 * @group             : 
 * @last modified on  : 7-7-2022
 * @last modified by  : Mickey (updated fee approval check)
**/

public class x_AcquiringFeesLookup {

    public static final String AMEX = 'Amex';
    public static final String PARKING = 'Parking';
    public static final String HOSPITALITY = 'Hospitality';
    public static final String RETAIL = 'Retail';
    public static final String NO_FEES_FOUND = 'No Fees found that match criteria entered.  No Profit calculated.';
    public static final String NO_FEES_PARKING = 'No minimum fees relevant to Parking.';
    
    @InvocableMethod(label='Acquiring Fees Lookup' description='Acquiring Fees Lookup')
    public static void setFees(list<id> listofaFeesId)
    {

        // Get acquiring fees
        //get Acquiring_Fees__c record using id from process
        List<Acquiring_Fees__c> afees = [SELECT Name, Id, Platform__c, Scheme__c, Setup__c, Vertical__c, Acquiring_Volume__c, Fees__c, 
                                                Actual_Fees__c, Profit__c, Opportunity__c, Actual_Fee_Per_Click__c, No_of_Transactions__c, CurrencyIsoCode
                                        FROM Acquiring_Fees__c 
                                        WHERE Id In:listofaFeesId];

        //lookup acquiring fees from the custom metadata type 'Acquiring Fees Lookup'
        List<Acquiring_Fees_Lookup__mdt> lstLookup = [SELECT Id, Platform__c, Scheme__c, Setup__c, Vertical__c, Scheme_Fees__c, Min_Vol__c, Max_Vol__c, 
                                                             Minumum_Fees__c, Min_Fees__c, Transaction_Fee__c
                                                      FROM Acquiring_Fees_Lookup__mdt];

        //get the currecy conversion rate from user entered currency
        Decimal cts = [SELECT Id, IsoCode, ConversionRate FROM CurrencyType WHERE IsoCode = :afees[0].CurrencyIsoCode LIMIT 1].ConversionRate;
        
        Boolean bFeeFound = false;
        Boolean bClickPerFee = false;
        Boolean bApprovalRequired = false;
        Decimal dFee = 0.0;
        Decimal margin = 0.0;
        
        // New Opp object
        Opportunity varOpp = new Opportunity();

        for(Acquiring_Fees__c afee :afees)
        {
            //user for currency conversion to EUR
            Decimal convertedVolume;
            
            //set Opportunity
            varOpp.Id = afee.Opportunity__c;
    
            for(Acquiring_Fees_Lookup__mdt curLookup : lstLookup) 
            {
                    
				//do currency conversion here
                if (afee.CurrencyIsoCode != 'EUR'){
                	convertedVolume = afee.Acquiring_Volume__c / cts;
                }else{
                    //EUR (*1)
                    convertedVolume = afee.Acquiring_Volume__c; 
                }
                    
                //convert to euro before doing lookup
                        
                if(curLookup.Platform__c == afee.Platform__c & 
                   curLookup.Scheme__c == afee.Scheme__c & 
                   curLookup.Setup__c == afee.Setup__c & 
                   curLookup.Vertical__c == afee.Vertical__c & 
                   curLookup.Min_Vol__c <= convertedVolume &
                   curLookup.Max_Vol__c >= convertedVolume)
                {
                	//lookup found
                    bFeeFound = true;
                        
                    //do check for click per fee here (non parking)
		            if (((afee.Vertical__c == HOSPITALITY) || (afee.Vertical__c == RETAIL)) && (afee.Actual_Fees__c == null)){
						bClickPerFee = true;
                            
                        //calcluate margin for the fee lookup check
                        //calculate the profit
                        margin = calculateMargin(afee);
                            
					}else{
                            
                    	dFee = afee.Actual_Fees__c;
                        if(curLookup.Scheme_Fees__c != null){
                        	//blended
                            dFee = dFee/100;
                        }else{
                       		if(afee.Scheme__c != AMEX){
                            	//IC++
                                dFee = dFee/10000;
                            }
                        }
						margin = dfee; //used in check later
                    }
                        
					//catch here if users entered a volume bigger than 1000 million.  They could have entered '5000000' instead of '5'
                    //when trying to enter 5 million.  They can then edit and avoid approvals
                    if (convertedVolume > 1000){
	                	afee.Fees__c = curLookup.Minumum_Fees__c + '. Since your Acquired Volume exceeds 1000 Million, approval is required. ' +
                                    			'Check that you entered the volume correctly i.e. 1 million should be entered as 1 and not 1000000';
                        afee.Fees_Require_Approval__c = true; 
                        //varOpp.Fees_Require_Approval__c = true;                            
                    }else{
                            
						//this actual fees need divided by 10000
                        if (curLookup.Min_Fees__c <= margin){
                        	//fees found and above the minimum
                            afee.Fees__c = curLookup.Minumum_Fees__c;
                            afee.Fees_Require_Approval__c = false;
                                                
						} else{
                        	//fees found and below the minimum
                            afee.Fees__c = curLookup.Minumum_Fees__c;
                            afee.Fees_Require_Approval__c = true; 
                                            
                        }
                            
					}
                        
                    if (bClickPerFee){
						afee.Profit__c = afee.Actual_Fee_Per_Click__c * afee.No_of_Transactions__c;
                        afee.Margin__c = margin;
					}else{
                        afee.Margin__c = null;    //only for click per fee
						//calculate the profit
                        Decimal profit = calculateProfit(bFeeFound, afee, curLookup);
                        afee.Profit__c = profit;
            
                        Decimal txfees = calculateTransactionFees(bFeeFound, afee, curLookup);
                        afee.Transaction_Fees__c = txfees;
                            
                    }
				} 
            }

            if (!bFeeFound){
				//no fees found in custom metadata matrix
                //reset
                bFeeFound = false;
                afee.Transaction_Fees__c = 0.00;
                    
                //new parking reqmt - 9/9/21
                if (afee.Vertical__c == PARKING) {
                	if (afee.Actual_Fees__c != null){
                    	//calculate based on volume and actual fees
                     	afee.Profit__c = ((afee.Acquiring_Volume__c * 1000000) * (afee.Actual_Fees__c/100)) ;   
                    }    
                    else if(afee.Actual_Fee_Per_Click__c != null){
                        //calculate based on actual fee per click and no of transactions
	                  	afee.Profit__c = (afee.No_of_Transactions__c * afee.Actual_Fee_Per_Click__c);
                    }
                     
                    afee.Fees__c = NO_FEES_PARKING;
                    afee.Fees_Require_Approval__c = false;
                     
                }
               	else{
	                afee.Profit__c = 0.00;                    
                   	afee.Fees__c = NO_FEES_FOUND;
                   	afee.Fees_Require_Approval__c = true;
               	}
                    
       		}

        }

        //update acquring fees
        update afees;
        
        //update parent opportunity - check if any child cquiring Fee record needs approval
        bApprovalRequired = checkIfApprovalNeeded(varOpp);
        if (bApprovalRequired){
            varOpp.Fees_Require_Approval__c = true;
        }else{
            varOpp.Fees_Require_Approval__c = false;
        }
        update varOpp;    
            
        
    }
    
    public static Boolean checkIfApprovalNeeded(Opportunity varOpp){
        Boolean bApproval = false;
        
        List<Acquiring_Fees__c> afeeApprovals = [SELECT Id, Fees_Require_Approval__c
                                        		FROM Acquiring_Fees__c 
                                        		WHERE Opportunity__c = :varOpp.Id
                                                AND Fees_Require_Approval__c = true 
                                                ];
        If (afeeApprovals.size() > 0) {
            bApproval = true;
        }
        
        return bApproval;
    }
    
   	public static Decimal calculateProfit(Boolean bFeeFound, Acquiring_Fees__c fees, Acquiring_Fees_Lookup__mdt lookupFees) {
        
        Decimal profit = 0.0;

        if (bFeeFound){
            if(lookupFees.Scheme_Fees__c != null){
                //blended
                    
                Decimal dActualFee = fees.Actual_Fees__c;
                dActualFee = dActualFee/100;
                Decimal dSchemeFee = lookupFees.Scheme_Fees__c;
                Decimal mltply = dActualFee - dSchemeFee;
                Decimal vol = fees.Acquiring_Volume__c;
                    
                profit = (vol * mltply) * 1000000;
            } else {
                if(fees.Scheme__c == AMEX){
                    //Amex
                    profit = (fees.Acquiring_Volume__c * fees.Actual_Fees__c) * 1000000;
                }else{
                    //IC++
                    profit = (fees.Acquiring_Volume__c * fees.Actual_Fees__c) * 100;
                }
            }
        }
        
        return profit;
    }

   	public static Decimal calculateTransactionFees(Boolean bFeeFound, Acquiring_Fees__c fees, Acquiring_Fees_Lookup__mdt lookupFees) {
        
        Decimal transactionFees = 0.0;

        if (bFeeFound){
            if((lookupFees.Transaction_Fee__c != null) && (fees.No_of_Transactions__c != null)){
                //transaction fee included
                transactionFees = fees.No_of_Transactions__c * lookupFees.Transaction_Fee__c;
            }
        }
        
        return transactionFees;
    }
    
   	public static Decimal calculateMargin(Acquiring_Fees__c fees) {
        
        Decimal revenue = 0.0;
        Decimal margin = 0.0;
        
        if((fees.Actual_Fee_Per_Click__c != null) && (fees.No_of_Transactions__c != null)){
            revenue = fees.Actual_Fee_Per_Click__c * fees.No_of_Transactions__c;
	        margin = (revenue / (fees.Acquiring_Volume__c * 1000000))*100;
        }
        
        return margin;
    }    

}