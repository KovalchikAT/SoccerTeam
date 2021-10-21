trigger MatchTrigger on Match__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
        MatchTriggerHendler.updatePreviousMatchDateTime(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        MatchTriggerHendler.updatePreviousMatchDateTime(Trigger.new);
    }
}