({
	getTeams : function(component, event, helper) {
        var action = component.get("c.getSoccerTeamStatisticsTable ");
		
        action.setParams({
            "limitNumber": component.get("v.limitNumber")
        });
        action.setCallback(this, function(response) {
            component.set("v.teams", response.getReturnValue());
        });
        
        $A.enqueueAction(action);
	},
    
    setColumns : function(component) {
        component.set('v.columns', [
            {label: 'Team', fieldName: 'Name', type: 'text'},
            {label: 'Wins', fieldName: 'Total_Wins__c', type: 'Integer'},
            {label: 'Active Players', fieldName: 'Total_Active_Players__c', type: 'Integer'},
            {label: 'Played Home Matches', fieldName: 'Played_Home_Matches_Count__c', type: 'Integer'}
        ]);
    }
})