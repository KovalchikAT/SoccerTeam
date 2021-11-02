trigger TotalWinsCalc on Team__c (before insert, before update) {
   // system.debug(System.LoggingLevel.DEBUG, '1');
    
    for (Team__c tmp : Trigger.new) {
        tmp.Total_Wins__c= SoccerDAO.getWonMatchesCountByTeamId(tmp.id);
    }
}