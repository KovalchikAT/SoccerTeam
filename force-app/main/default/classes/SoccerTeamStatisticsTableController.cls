public class SoccerTeamStatisticsTableController {
	@AuraEnabled
    public static List<Team__c> getSoccerTeamStatisticsTable(Integer limitNumber){
        return [SELECT id, Name, Total_Wins__c, Total_Active_Players__c, Played_Home_Matches_Count__c 
                FROM Team__c 
                ORDER BY Total_Wins__c DESC
                LIMIT :limitNumber];
    }
}