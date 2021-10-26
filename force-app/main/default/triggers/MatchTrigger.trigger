trigger MatchTrigger on Match__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if (Trigger.isBefore && Trigger.isInsert){
        MatchTriggerHendler.updatePreviousMatchDateTime(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate){
        MatchTriggerHendler.updatePreviousMatchDateTime(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isInsert){
        MatchTriggerHendler.teamWinsUpdate(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate){
        List<Match__c> tmpMatchList = new List<Match__c>();
        for (Match__c newMatch : Trigger.new) {
            for (Match__c oldMatch : Trigger.old) {
                if (newMatch.Winner__c<>oldMatch.Winner__c) {
                    tmpMatchList.add(newMatch);
                }
            } 
        }
        MatchTriggerHendler.teamWinsUpdate(tmpMatchList);
    }
}