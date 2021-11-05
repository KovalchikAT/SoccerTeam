@IsTest
public with sharing class PlayerIntegrateWorkTest {
    @testSetup static void setup() {
        // Create common test Teams
        List<Team__c> testTeam = new List<Team__c>();
        for(Integer i=0;i<2;i++) {
            testTeam.add(new Team__c(Name ='Team_'+i, Total_Active_Players__c =13));
        }
        testTeam.get(0).Total_Wins__c=2;
        insert testTeam;

        // Create common test Players
        List<Player__c> testPlayer = new List<Player__c>();
        Integer k=0;
        for (Integer j=0;j<testTeam.size();j++) {
            for(Integer i=0;i< 13;i++) {
                testPlayer.add(new Player__c(Name ='Player_'+k, Email__c ='Player_'+k+'@ukr.net', IsActive__c =True, Team__c=testTeam.get(j).id));
                k++;
            } 
        }             
        upsert testPlayer;

        // Create common test Match
        List<Match__c> testMatch = new List<Match__c>();
        Integer n=0, m=1;
        for(Integer i=0;i<3;i++) {
            testMatch.add(new Match__c(Name ='TestMatch_'+i, Start_DateTime__c =DateTime.now()+i, Home_Team__c =testTeam.get(n).Id, Visitors__c =testTeam.get(m).Id, Score__c ='00:00'));
            n = n<testTeam.size() ? n++ : 0;
            m = m<testTeam.size() ? m++ : 0;
        }
        testMatch.get(0).Score__c= '00:01';
        testMatch.get(1).Score__c= '02:00';
        upsert testMatch; 
        
        system.debug(System.LoggingLevel.DEBUG, testTeam);
        system.debug(System.LoggingLevel.DEBUG, testPlayer);
        system.debug(System.LoggingLevel.DEBUG, testMatch);            
    }/* */
}
