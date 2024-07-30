({
    getContactDetailsById : function(cmp) {
        cmp.set("v.showError",false);
        cmp.set("v.showSpinner",true);
        var recordId=cmp.get('v.recordId');
        
        var action = cmp.get('c.getContactDetailsById');
        action.setParams({contactId:recordId});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                console.log( response.getReturnValue());
                var objWrapper = response.getReturnValue();
                cmp.set('v.objWrapper',objWrapper);
                
                if(objWrapper.objContact!=undefined){
                    cmp.set('v.showUpload',true);
                    cmp.set('v.tempRecId',objWrapper.tempRecId);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Invalid Contact record.",
                        "type": 'error'
                    });
                    toastEvent.fire();
                }
                cmp.set("v.showSpinner",false);
                
            }else if(state == "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured.",
                    "type": 'error'
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getContactDetail : function(cmp) {
        cmp.set("v.showError",false);
        cmp.set("v.showSpinner",true);
        var email=cmp.get('v.email');
        var DOB=cmp.get('v.DOB');
       
        var device = $A.get("$Browser.formFactor");
        if(device=='DESKTOP'){
            var action = cmp.get('c.getContactDetails');
        }else{
            var action = cmp.get('c.getContactDetailsMobile'); 
        }
       
        action.setParams({
            email:email,
            DOB:DOB
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
             cmp.set("v.showSpinner",false);
            if(state == "SUCCESS") {
                console.log( response.getReturnValue());
                var objWrapper = response.getReturnValue();
                cmp.set('v.objWrapper',objWrapper);
                
                if(objWrapper.objContact!=undefined){
                    cmp.set('v.recordId',objWrapper.objContact.Id);
                    cmp.set('v.tempRecId',objWrapper.tempRecId);
                    cmp.set('v.showUpload',true);
                    cmp.set('v.showMain',false);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "There is no Registration Record for the given Email Address and Date of Birth combination. Please enter the correct information.",
                        "type": 'error'
                    });
                    toastEvent.fire();
                }
                cmp.set("v.showSpinner",false);
                
            }else if(state == "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error Occured.",
                    "type": 'error'
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    processSubmit : function(cmp) {
        cmp.set("v.showError",false);
        cmp.set("v.showSpinner",true);
        var recordId=cmp.get('v.recordId');
        var tempRecId = cmp.get('v.tempRecId');
        var action = cmp.get('c.pocessFileUpload');
        action.setParams({
            contactId:recordId,
            tempRecId:tempRecId
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                console.log( response.getReturnValue());
                var mapMsg = response.getReturnValue();
                
                if(mapMsg.success !=undefined){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Successfully uploaded",
                        "type": 'success'
                    });
                    toastEvent.fire();
                    cmp.set('v.showTabs',false);
                    cmp.set('v.showSummary',true);
                    
                }else if(mapMsg.invalidOfficerEmail !=undefined){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error occured, Please contact MCR Administrator",
                        "type": 'error'
                    });
                    toastEvent.fire();
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error occured, Please contact MCR Administrator",
                        "type": 'error'
                    });
                    toastEvent.fire();
                }
                cmp.set("v.showSpinner",false);
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    deleteUploadedFiles : function(cmp) {
        cmp.set("v.showError",false);
        cmp.set("v.showSpinner",true);
        var recordId=cmp.get('v.recordId');
        var file1Id= cmp.get('v.file1Id');
        var file2Id= cmp.get('v.file2Id');
        var file3Id= cmp.get('v.file3Id');
        var file4Id= cmp.get('v.file4Id');
        
        var fileIds= [];
        fileIds.push(file1Id);
        fileIds.push(file2Id);
        fileIds.push(file3Id);
        fileIds.push(file4Id);
        
        var action = cmp.get('c.deleteNewFiles');
        action.setParams({
            documentIds:fileIds
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                console.log( response.getReturnValue());
                var mapMsg = response.getReturnValue();
                
                if(mapMsg.success !=undefined){
                    cmp.set('v.file1Name',null);
                    cmp.set('v.file1Id',null);
                    cmp.set('v.file2Name',null);
                    cmp.set('v.file2Id',null);
                    cmp.set('v.file3Name',null);
                    cmp.set('v.file3Id',null);
                    cmp.set('v.file4Name',null);
                    cmp.set('v.file4Id',null);
                    
                    var fromSignupPage = cmp.get('v.fromSignupPage');
                    if(fromSignupPage){
                        cmp.set('v.showUpload',true);
                        
                    }else{
                        cmp.set('v.showMain',true);
                        cmp.set('v.showUpload',false);
                    }
                    
                    
                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error occured, Please contact MCR Administrator",
                        "type": 'error'
                    });
                    toastEvent.fire();
                }
                cmp.set("v.showSpinner",false);
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    deleteFilesById : function(component,documentId){
        component.set("v.showSpinner", true); 
        
        var action = component.get("c.deleteFile");           
        action.setParams({
            documentId:documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            component.set("v.showSpinner", false);
            if(state=='SUCCESS'){  
                
            }  
        });  
        $A.enqueueAction(action);   
    },
    
    
})