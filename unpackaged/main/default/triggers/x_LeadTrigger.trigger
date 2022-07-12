trigger x_LeadTrigger on Lead (before insert, after insert) {
	if (Trigger.isBefore & Trigger.isInsert) {
    	x_TriggerHandlerLead.onLeadBeforeInsert(Trigger.new);
	}

	if (Trigger.isAfter & Trigger.isInsert) {
    	x_TriggerHandlerLead.onLeadAfterInsert(Trigger.new);
	}

}