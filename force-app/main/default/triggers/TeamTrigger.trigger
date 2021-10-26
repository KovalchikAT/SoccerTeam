trigger TeamTrigger on Team__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
   /* if (Trigger.isBefore && Trigger.isInsert) {
        for (Team__c tmp : Trigger.new) {
            tmp.Total_Wins__c= SoccerDAO.getWonMatchesCountByTeamId(tmp.id);
        }
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Team__c tmp : Trigger.new) {
            tmp.Total_Wins__c= SoccerDAO.getWonMatchesCountByTeamId(tmp.id);
        }
    }*/
}