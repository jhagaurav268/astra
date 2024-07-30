({
    doInit : function(component, event, helper) {
        var contactId='';
        var url = (window.location != window.parent.location)  ? document.referrer : document.location.href;
        console.log( url );
        if(url.includes('?')){
            contactId = url.split('?')[1];
            console.log(contactId);
        }
        
        
        if(contactId !=''){
            component.set('v.recordId',contactId);
            component.set('v.fromSignupPage',true);
            helper.getContactDetailsById(component);
        }
        else{
            component.set('v.showMain',true);
        }
        var device = $A.get("$Browser.formFactor");
        component.set('v.device',device);
        console.log(device);
    },
    
    showUploadTab : function(component, event, helper) {
        component.find("tabs").set("v.selectedTabId", 'uploads');
    },
    
    handleProceed : function(component, event, helper) {
        var email= component.get('v.email');
        var DOB= component.get('v.DOB');
        var emailField= component.find('email');
        var DOBField= component.find('DOB');
        
        if(email ==undefined || email=='' || email==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Email is required.",
                "type": 'error'
            });
            toastEvent.fire();
            
        }else if(!emailField.checkValidity()){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Invalid Email.",
                "type": 'error'
            });
            toastEvent.fire();
            
        }else if(DOB ==undefined || DOB=='' || DOB==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Date of Birth is required.",
                "type": 'error'
            });
            toastEvent.fire();
            
        }else if(!DOBField.isValid){
            //checkValidity
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Invalid Date of Birth.",
                "type": 'error'
            });
            toastEvent.fire();
            
        }else{
            var device = $A.get("$Browser.formFactor");
            if(device!='DESKTOP'){
                var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/;
                if (!(date_regex.test(DOB))) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Invalid Date of Birth.",
                        "type": 'error'
                    });
                    toastEvent.fire();
                    
                }else{
                    helper.getContactDetail(component);
                }
                
            }
            else{
                helper.getContactDetail(component);
            }
            
            
            
            
        }
    },
    
    handleDOBOnMobile : function(component, event, helper) {
        var DOB= component.find('DOB');
        if(DOB!=undefined){
            var DOBVal= DOB.get('v.value');
            if(DOBVal!=undefined){
                var pattern=/^\d+$/;
                for(var i=0;i<DOBVal.length;i++ ){
                    console.log(DOBVal[i]);
                    if(!pattern.test(DOBVal[i]) && DOBVal[i]!='/'){
                        DOBVal= DOBVal.replace(DOBVal[i],'');
                    }
                    
                }
                component.set('v.DOB',DOBVal);
            }
            
        }         
        
    },
    
    handleUploadFile1: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        uploadedFiles.forEach(file => console.log(file.name));
        
        var fileName= uploadedFiles[0].name;
        if(fileName!=undefined){
            var ext = fileName.split('.')[1];
            ext=ext.toLowerCase();
            ext= '.'+ext;
            var fileTypes= component.get('v.fileTypes');
            if(!fileTypes.includes(ext)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Invalid File type.",
                    "type": 'error'
                });
                toastEvent.fire();
                helper.deleteFilesById(component, uploadedFiles[0].documentId);
                
                
            }else{
                component.set("v.file1Name" , uploadedFiles[0].name)  ;
                component.set("v.file1Id" , uploadedFiles[0].documentId)  ;
            }
        }
        
        
        
    } ,
    
    handleUploadFile2: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        uploadedFiles.forEach(file => console.log(file.name));
        
        var fileName= uploadedFiles[0].name;
        if(fileName!=undefined){
            var ext = fileName.split('.')[1];
            ext=ext.toLowerCase();
            ext= '.'+ext;
            var fileTypes= component.get('v.fileTypes');
            if(!fileTypes.includes(ext)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Invalid File type.",
                    "type": 'error'
                });
                toastEvent.fire();
                helper.deleteFilesById(component, uploadedFiles[0].documentId);
                
                
            }else{
                component.set("v.file2Name" , uploadedFiles[0].name)  ;
                component.set("v.file2Id" , uploadedFiles[0].documentId)  ;
            }
        }
        
    } ,
    
    handleUploadFile3: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        uploadedFiles.forEach(file => console.log(file.name));
        
        var fileName= uploadedFiles[0].name;
        if(fileName!=undefined){
            var ext = fileName.split('.')[1];
            ext=ext.toLowerCase();
            ext= '.'+ext;
            var fileTypes= component.get('v.fileTypes');
            if(!fileTypes.includes(ext)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Invalid File type.",
                    "type": 'error'
                });
                toastEvent.fire();
                helper.deleteFilesById(component, uploadedFiles[0].documentId);
                
                
            }else{
                component.set("v.file3Name" , uploadedFiles[0].name)  ;
                component.set("v.file3Id" , uploadedFiles[0].documentId)  ;
            }
        }
        
    } ,
    
    handleUploadFile4: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        uploadedFiles.forEach(file => console.log(file.name));
        
        var fileName= uploadedFiles[0].name;
        if(fileName!=undefined){
            var ext = fileName.split('.')[1];
            ext=ext.toLowerCase();
            ext= '.'+ext;
            var fileTypes= component.get('v.fileTypes');
            if(!fileTypes.includes(ext)){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Invalid File type.",
                    "type": 'error'
                });
                toastEvent.fire();
                helper.deleteFilesById(component, uploadedFiles[0].documentId);
                
                
            }else{
                component.set("v.file4Name" , uploadedFiles[0].name)  ;
                component.set("v.file4Id" , uploadedFiles[0].documentId)  ;
            }
        }
        
    } ,
    
    deleteFiles : function(component,event,helper){
        component.set("v.showSpinner", true); 
        var documentId = event.currentTarget.id;
        var fieldName = event.currentTarget.name;
        
        
        var action = component.get("c.deleteFile");           
        action.setParams({
            documentId:documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            
            if(state=='SUCCESS'){  
                component.set("v.showSpinner", false);
                if(fieldName=='file1Delete'){
                    component.set('v.file1Name',null);
                    component.set('v.file1Id',null);
                    
                }else if(fieldName=='file2Delete'){
                    component.set('v.file2Name',null);
                    component.set('v.file2Id',null);
                    
                }else if(fieldName=='file3Delete'){
                    component.set('v.file3Name',null);
                    component.set('v.file3Id',null);
                    
                }else if(fieldName=='file4Delete'){
                    component.set('v.file4Name',null);
                    component.set('v.file4Id',null);
                    
                }
            }  
        });  
        $A.enqueueAction(action);
        
    },
    
    hideUpload : function (component, event, helper) {
        component.set('v.showUpload',false);
    },
    
    showCancelUploadConfirm : function (component, event, helper) {
        component.set('v.showCancelUploadConfirm',true);
    },
    
    hideCancelUploadConfirm : function (component, event, helper) {
        component.set('v.showCancelUploadConfirm',false);
    },
    
    processCancelUpload : function (component, event, helper) {
        component.set('v.showCancelUploadConfirm',false);
        var fromSignupPage = component.get('v.fromSignupPage');
        var file1Id= component.get('v.file1Id');
        var file2Id= component.get('v.file2Id');
        var file3Id= component.get('v.file3Id');
        var file4Id= component.get('v.file4Id');
        
        //Delete and uploaded files exists.
        if(file1Id!=null || file2Id!=null || file3Id!=null || file4Id!=null){
            helper.deleteUploadedFiles(component);
            
        }else{
            if(fromSignupPage){
                component.set('v.showUpload',true);
                
            }else{
                component.set('v.showMain',true);
                component.set('v.showUpload',false);
            }
        }
        
    },
    
    showUploadConfirm: function (component, event, helper) {
        var file1Id= component.get('v.file1Id');
        var file2Id= component.get('v.file2Id');
        var file3Id= component.get('v.file3Id');
        var file4Id= component.get('v.file4Id');
        
        if(file1Id!=null || file2Id!=null || file3Id!=null || file4Id!=null){
            component.set('v.showUploadConfirm',true);
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please upload at least One file.",
                "type": 'error'
            });
            toastEvent.fire();
        }
        
    },
    
    hideUploadConfirm: function (component, event, helper) {
        component.set('v.showUploadConfirm',false);
    },
    
    processSubmitUpload: function (component, event, helper) {
        component.set('v.showUploadConfirm',false);
        helper.processSubmit(component);
    },
    
})