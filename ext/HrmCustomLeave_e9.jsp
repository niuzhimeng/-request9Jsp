<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.attendance.domain.*,weaver.hrm.User"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%@page import="weaver.hrm.attendance.manager.WorkflowBaseManager"%>
<!-- Added by wcd 2015-06-25[自定义请假单] -->
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page" />
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
	int nodetype = strUtil.parseToInt(request.getParameter("nodetype"), 0);
	int workflowid = strUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = strUtil.parseToInt(request.getParameter("formid"));
	int userid = strUtil.parseToInt(request.getParameter("userid"));
	int nodeid = strUtil.parseToInt(request.getParameter("nodeid"), 0);
	String creater = strUtil.vString(request.getParameter("creater"), String.valueOf(userid));
	WorkflowBaseManager workflowBaseManager = new WorkflowBaseManager();
	if(formid == -1) {
		WorkflowBase bean = workflowBaseManager.get(workflowid);
		formid = bean == null ? -1 : bean.getFormid();
	}
	String[] fieldList = attProcSetManager.getFieldList(workflowid, formid);
	if(fieldList == null || fieldList.length == 0 || strUtil.isNull(fieldList[0])) return;
	String currentdate = strUtil.vString(request.getParameter("currentdate"), dateUtil.getCurrentDate());
	String f_weaver_belongto_userid = strUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = strUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
	String userannualinfo = HrmAnnualManagement.getUserAannualInfo(creater,currentdate);
	String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
	String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
	String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
	String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(creater, currentdate);
	String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
	String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
	String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
	String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(creater));
	String allannualValue = allannual;
	String allpsldaysValue = allpsldays;
	String paidLeaveDaysValue = paidLeaveDays;
	float[] freezeDays = attVacationManager.getFreezeDays(creater);
	if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];
	if(freezeDays[1] > 0) allpsldays += " - "+freezeDays[1];
	if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];

	float realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
	float realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
	float realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);
	if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
		realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
		realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays[1]);
		realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
	}
	String strleaveTypes = colorManager.getPaidleaveStr();
%>
<script language="javascript">
    var formid = "<%=formid%>";
    var _field_resourceId = "<%=fieldList[0]%>";
    var _field_newLeaveType = "<%=fieldList[2]%>";
    var _field_fromDate = "<%=fieldList[3]%>";
    var _field_fromTime = "<%=fieldList[4]%>";
    var _field_toDate = "<%=fieldList[5]%>";
    var _field_toTime = "<%=fieldList[6]%>";
    var _field_leaveDays = "<%=fieldList[7]%>";
    var _field_vacationInfo = "<%=fieldList[8]%>";
    var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
    var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";

    var allannualValue="<%=allannualValue%>";
    var allpsldaysValue="<%=allpsldaysValue%>";
    var paidLeaveDaysValue="<%=paidLeaveDaysValue%>";
    var realAllannualValue="<%=realAllannualValue%>";
    var realAllpsldaysValue="<%=realAllpsldaysValue%>";
    var realPaidLeaveDaysValue="<%=realPaidLeaveDaysValue%>";
    var strleaveTypes="<%=strleaveTypes%>";

	jQuery(document).ready(function(){
		if(_field_vacationInfo != "") {
			try{
				//$GetEle(_field_vacationInfo).style.display = "none";
				WfForm.changeFieldAttr(_field_vacationInfo, 4);
				showVacationInfo();

			}catch(e){}
		}
		if(_field_leaveDays != "") {
			try{
				//$GetEle(_field_leaveDays).style.display = "none";
				//jQuery("#"+_field_leaveDays+"span").html(jQuery("input[name='"+_field_leaveDays+"']").val());
				WfForm.changeFieldAttr(_field_leaveDays, 1);
			}catch(e){}
		}
		var changeFields =_field_resourceId+","+_field_newLeaveType+","+_field_fromDate+","+_field_fromTime
			+","+_field_toDate+","+_field_toTime;
		WfForm.bindFieldChangeEvent(changeFields, function(obj,id,value){
			//console.log("WfForm.bindFieldChangeEvent--",obj,id,value);
			wfbrowvaluechange_fna(obj, id, null);
		});
	});

    function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
        //fieldid = "field"+fieldid;
        if(fieldid == _field_newLeaveType || fieldid == _field_vacationInfo){
            showVacationInfo();
        }else if(fieldid == _field_fromDate || fieldid == _field_fromTime || fieldid == _field_toDate || fieldid == _field_toTime){
            setLeaveDays();
            if(fieldid == _field_fromDate) {
                //之前是initInfo，会把实际计算好的用于提交判断的休假信息给重置掉
                showVacationInfo();
            }
        }else if(fieldid == _field_resourceId){
            setLeaveDays();
            initInfo();
        }
    }

    function ajaxInit(){
        var ajax=false;
        try {
            ajax = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                ajax = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (E) {
                ajax = false;
            }
        }
        if (!ajax && typeof XMLHttpRequest!='undefined') {
            ajax = new XMLHttpRequest();
        }
        return ajax;
    }

    function setLeaveDays(){
        if(_field_leaveDays == "") return;
        //var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
        //var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
        //var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
        //var toDate = jQuery("input[name='"+_field_toDate+"']").val();
        //var toTime = jQuery("input[name='"+_field_toTime+"']").val();

        var resourceId = WfForm.getFieldValue(_field_resourceId);
        var fromDate = WfForm.getFieldValue(_field_fromDate);
        var fromTime = WfForm.getFieldValue(_field_fromTime);
        var toDate = WfForm.getFieldValue(_field_toDate);
        var toTime = WfForm.getFieldValue(_field_toTime);
        //var leaveDaysObj = jQuery("input[name='"+_field_leaveDays+"']");
        //var leaveDyasType = leaveDaysObj.attr("type");
        //var newLeaveType = jQuery("#"+_field_newLeaveType).val();
        var newLeaveType = WfForm.getFieldValue(_field_newLeaveType);
        if(resourceId != '' && fromDate!='' && toDate!=''){
            var ajax=ajaxInit();
            ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            ajax.send("operation=getLeaveDays&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromDate="+fromDate+"&fromTime="+fromTime+"&toDate="+toDate+"&toTime="+toTime+"&resourceId="+resourceId+"&newLeaveType="+newLeaveType);
            ajax.onreadystatechange = function() {
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try {
                        var result = jQuery.trim(ajax.responseText);
                        //leaveDaysObj.val(result);
                        //if(leaveDyasType == 'hidden')
                        //jQuery("#"+_field_leaveDays+"span").html(result);
                        WfForm.changeSingleField(_field_leaveDays, {value:result});
                        WfForm.changeFieldAttr(_field_leaveDays, 1);
                    } catch(e) {
                        //leaveDaysObj.val("0.0");
                        //if(leaveDyasType == 'hidden')
                        //jQuery("#"+_field_leaveDays+"span").html('0.0');
                        WfForm.changeSingleField(_field_leaveDays, {value:"0.0"});
                        WfForm.changeFieldAttr(_field_leaveDays, 1);
                    }
                }
            }
        }
        showVacationInfo();
    }
    function initInfo(){

        //var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
        //var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
        var resourceId = WfForm.getFieldValue(_field_resourceId);
        var fromDate = WfForm.getFieldValue(_field_fromDate);
        if(typeof(resourceId) != "undefined" && resourceId != "" && typeof(fromDate) != "undefined" && fromDate != "") {
            var ajax=ajaxInit();
            ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            ajax.send("operation=initInfo&nodetype=<%=nodetype%>&workflowid=<%=workflowid%>&resourceId="+resourceId+"&currentDate="+fromDate+"&leavetype="+ WfForm.getFieldValue(_field_newLeaveType));

            ajax.onreadystatechange = function() {
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try {
                        var result = jQuery.trim(ajax.responseText);
                        allannualValue=result.split("#")[0];
                        allpsldaysValue=result.split("#")[1];
                        paidLeaveDaysValue=result.split("#")[2];
                        realAllannualValue=result.split("#")[3];
                        realAllpsldaysValue=result.split("#")[4];
                        realPaidLeaveDaysValue=result.split("#")[5];
                    } catch(e) {

                    }
                }
            }
        }
    }


    function getAnnualInfo(resourceId) {
        var fromDate = WfForm.getFieldValue(_field_fromDate);
        if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
            var ajax=ajaxInit();
            ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            ajax.send("operation=getAnnualInfo&resourceId="+resourceId+"&nodetype=<%=nodetype%>&nodeid=<%=nodeid%>&workflowid=<%=workflowid%>&currentDate="+fromDate);
            ajax.onreadystatechange = function() {
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try{
                        var annualdaysValue=jQuery.trim(ajax.responseText).split("#")[1];
                        var annualrealdaysValue=jQuery.trim(ajax.responseText).split("#")[2];
                        var annualInfo=jQuery.trim(ajax.responseText).split("#")[3];
                        if(annualInfo == "") {
                            //alert("<%=SystemEnv.getHtmlLabelName(125565, user.getLanguage())%>");
                            return;
                        } else {
                            allannualValue=annualdaysValue;
                            realAllannualValue=annualrealdaysValue;
                            //$GetEle(_field_vacationInfo).style.display = "none";
                            //jQuery("#"+_field_vacationInfo+"span").html(annualInfo);
                            //jQuery("#"+_field_vacationInfo).val(annualInfo);
                            WfForm.changeSingleField(_field_vacationInfo, {value:annualInfo});
                            WfForm.changeFieldAttr(_field_vacationInfo, 1);
                        }
                    }catch(e){
                        //alert("<%=SystemEnv.getHtmlLabelName(125565, user.getLanguage())%>");
                        return;
                    }
                }
            }
        }
    }
    function getPSInfo(resourceId) {
        //alert(resourceId + "===getPSInfo");
        if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
            var ajax=ajaxInit();
            ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            ajax.send("operation=getPSInfo&resourceId="+resourceId+"&nodetype=<%=nodetype%>&workflowid=<%=workflowid%>&currentDate=<%=currentdate%>&leavetype="+ WfForm.getFieldValue(_field_newLeaveType));

            ajax.onreadystatechange = function() {
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try{
                        var PSallpsldaysValue=jQuery.trim(ajax.responseText).split("#")[1];
                        var PSrealAllpsldaysValue=jQuery.trim(ajax.responseText).split("#")[2];
                        var PSInfo=jQuery.trim(ajax.responseText).split("#")[3];
                        if(PSInfo == "") {
                            //alert("<%=SystemEnv.getHtmlLabelName(125566, user.getLanguage())%>");
                            return;
                        } else {
                            //$GetEle(_field_vacationInfo).style.display = "none";
                            //jQuery("#"+_field_vacationInfo+"span").html(PSInfo);
                            //jQuery("#"+_field_vacationInfo).val(PSInfo);
                            allpsldaysValue=PSallpsldaysValue;
                            realAllpsldaysValue=PSrealAllpsldaysValue;
                            WfForm.changeSingleField(_field_vacationInfo, {value:PSInfo});
                            WfForm.changeFieldAttr(_field_vacationInfo, 1);
                        }
                    }catch(e){
                        //alert("<%=SystemEnv.getHtmlLabelName(125566, user.getLanguage())%>");
                        return;
                    }
                }
            }
        }
    }
    function getTXInfo(resourceId) {
        //alert(resourceId + "===getPSInfo");
        if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
            var ajax=ajaxInit();
            ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            //var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
            var fromDate = WfForm.getFieldValue(_field_fromDate);
            ajax.send("operation=getTXInfo&resourceId="+resourceId+"&currentDate="+fromDate);
            ajax.onreadystatechange = function() {
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try{
                        var TXInfo=jQuery.trim(ajax.responseText).split("#")[1];
                        if(TXInfo == "") {
                            //alert("<%=SystemEnv.getHtmlLabelName(125567, user.getLanguage())%>");
                            return;
                        } else {
                            //$GetEle(_field_vacationInfo).style.display = "none";
                            //jQuery("#"+_field_vacationInfo+"span").html(TXInfo);
                            //jQuery("#"+_field_vacationInfo).val(TXInfo);
                            WfForm.changeSingleField(_field_vacationInfo, {value:TXInfo});
                            WfForm.changeFieldAttr(_field_vacationInfo, 1);
                        }
                    }catch(e){
                        //alert("<%=SystemEnv.getHtmlLabelName(125567, user.getLanguage())%>");
                        return;
                    }
                }
            }
        }
    }
    function showVacationInfo(){

        if(_field_vacationInfo == "") return;

        //var newLeaveType = jQuery("#"+_field_newLeaveType).val();
        //var vacationInfoObj = jQuery("input[name='"+_field_vacationInfo+"']");
        //var vacationInfoType = vacationInfoObj.attr("type");
        //var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
        var newLeaveType = WfForm.getFieldValue(_field_newLeaveType);
        var resourceId = WfForm.getFieldValue(_field_resourceId);
        var result = "";
        if(newLeaveType == '<%=HrmAttVacation.L6%>') {
            getAnnualInfo(resourceId);
        } else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
            getPSInfo(resourceId);
        } else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
            getTXInfo(resourceId);
        }else{
            //$GetEle(_field_vacationInfo).innerText = result;
            //jQuery("#"+_field_vacationInfo+"span").html(result);
            //jQuery("#"+_field_vacationInfo).val(result);
            if(newLeaveType != '' && strleaveTypes.indexOf(","+newLeaveType+",") > -1){
                getPSInfo(resourceId);
            }else{
                WfForm.changeSingleField(_field_vacationInfo, {value:result});
                WfForm.changeFieldAttr(_field_vacationInfo, 1);
            }
        }
        //confirmLeaveDays会导致再次调用initInfo把休假信息的值给改掉
        //confirmLeaveDays();
    }

    function confirmLeaveDays(){
        if(_field_leaveDays == "") return;

        //var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
        //var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
        //var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
        //var toDate = jQuery("input[name='"+_field_toDate+"']").val();
        //var toTime = jQuery("input[name='"+_field_toTime+"']").val();
        //var leaveDaysObj = jQuery("input[name='"+_field_leaveDays+"']");
        //var leaveDyasType = leaveDaysObj.attr("type");
        //var newLeaveType = jQuery("#"+_field_newLeaveType).val();

        var resourceId = WfForm.getFieldValue(_field_resourceId);
        var fromDate = WfForm.getFieldValue(_field_fromDate);
        var fromTime = WfForm.getFieldValue(_field_fromTime);
        var toDate = WfForm.getFieldValue(_field_toDate);
        var toTime = WfForm.getFieldValue(_field_toTime);
        var newLeaveType = WfForm.getFieldValue(_field_newLeaveType);

        if(resourceId != '' && fromDate!='' && toDate!=''){
            var ajax=ajaxInit();
            ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
            ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            ajax.send("operation=getLeaveDays&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromDate="+fromDate+"&fromTime="+fromTime+"&toDate="+toDate+"&toTime="+toTime+"&resourceId="+resourceId+"&newLeaveType="+newLeaveType);
            ajax.onreadystatechange = function() {
                if (ajax.readyState == 4 && ajax.status == 200) {
                    try {
                        var result = jQuery.trim(ajax.responseText);
                        WfForm.changeSingleField(_field_leaveDays, {value:result});
                        WfForm.changeFieldAttr(_field_leaveDays, 1);
                        //leaveDaysObj.val(result);
                        //jQuery("#"+_field_leaveDays+"span").html(result);
                    } catch(e) {
                        //leaveDaysObj.val("0.0");
                        //jQuery("#"+_field_leaveDays+"span").html('0.0');
                        WfForm.changeSingleField(_field_leaveDays, {value:"0.0"});
                        WfForm.changeFieldAttr(_field_leaveDays, 1);
                    }
                }
            }
        }
    }

    initInfo();
    checkCustomize = function() {
        var newLeaveType = WfForm.getFieldValue(_field_newLeaveType);
        if(!DateCheck()){
            return false;
        }

        if(newLeaveType == '<%=HrmAttVacation.L6%>') {
            if(allannualValue <= 0){
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(21720,user.getLanguage())%>");
                return false;
            }
            //if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllannualValue)){
            if(WfForm.getFieldValue(_field_leaveDays)!=null && parseFloat(WfForm.getFieldValue(_field_leaveDays)) > parseFloat(realAllannualValue)){
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(21721,user.getLanguage())%>");
                return false;
            }
        } else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
            if(allpsldaysValue <= 0){
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(24044,user.getLanguage())%>");
                return false;
            }

            //if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){
            if(WfForm.getFieldValue(_field_leaveDays)!=null && parseFloat(WfForm.getFieldValue(_field_leaveDays)) > parseFloat(realAllpsldaysValue)){
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(24045,user.getLanguage())%>");
                return false;
            }
        } else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
            if(WfForm.getFieldValue(_field_leaveDays)!=null && parseFloat(WfForm.getFieldValue(_field_leaveDays)) > parseFloat(realPaidLeaveDaysValue)){
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(84604,user.getLanguage())%>");
                return false;
            }
        } else{
            if(newLeaveType != '' && strleaveTypes.indexOf(","+newLeaveType+",") > -1){
                if(allpsldaysValue <= 0){
                    WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(131655,user.getLanguage())%>");
                    return false;
                }
                if(WfForm.getFieldValue(_field_leaveDays)!=null && parseFloat(WfForm.getFieldValue(_field_leaveDays)) > parseFloat(realAllpsldaysValue)){
                    WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(131656,user.getLanguage())%>");
                    return false;
                }
            }
        }

        return true;
    };

    function DateCheck(){
        //var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
        //var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
        //var toDate = jQuery("input[name='"+_field_toDate+"']").val();
        //var toTime = jQuery("input[name='"+_field_toTime+"']").val();
        var fromDate = WfForm.getFieldValue(_field_fromDate);
        var fromTime = WfForm.getFieldValue(_field_fromTime);
        var toDate = WfForm.getFieldValue(_field_toDate);
        var toTime = WfForm.getFieldValue(_field_toTime);

        var begin = new Date(fromDate.replace(/\-/g, "\/"));
        var end = new Date(toDate.replace(/\-/g, "\/"));
        if(fromTime != "" && toTime != ""){
            begin = new Date(fromDate.replace(/\-/g, "\/")+" "+fromTime+":00");
            end = new Date(toDate.replace(/\-/g, "\/")+" "+toTime+":00");
            if(fromDate!=""&&toDate!=""&&begin >end)
            {
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
            }
        }else{
            if(fromDate!=""&&toDate!=""&&begin >end)
            {
                WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                return false;
            }
        }
        return true;
    }
</script>
