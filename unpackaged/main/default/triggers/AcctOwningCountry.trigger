trigger AcctOwningCountry on Account (before insert) {
    for (Account acct : Trigger.new) {
            String myCountry = [Select Country From User Where Id = :UserInfo.getUserId()][0].Country;
            acct.Owning_Country__c = myCountry;
    }
}