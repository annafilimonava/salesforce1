/**
 * @description       : 
 * @author            : Florin Galea
 * @group             : 
 * @last modified on  : 04-20-2022
 * @last modified by  : Florin Galea
**/
public with sharing class AddHardwareFlowRouter {

    public AddHardwareFlowRouter(ApexPages.StandardController controller) {
        System.debug('AddHardwareFlowRouter Initialized');
    }

    public PageReference routeToFlow() {

        // get the parameters from this page
        Map<String, String> pageParams = ApexPages.CurrentPage().getParameters();
        system.debug(pageParams);
        system.debug(pageParams.get('CF00N5J000002hvTr_lkid'));

        // create a new URL to the flow and append our params to it    
        return new PageReference('/flow/Opportunity_Add_Hardware_List_View?recordId=' + pageParams.get('CF00N5J000002hvTr_lkid') + '&retURL=' + pageParams.get('CF00N5J000002hvTr_lkid'));
    }

}