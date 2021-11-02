({
	initTable : function(component, event, helper) {
		helper.setColumns(component);
        helper.getTeams(component, event, helper);
	},
    
    reloadTable : function(component, event, helper) {
        helper.getTeams(component, event, helper);
	}
})