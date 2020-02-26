<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<!-- Added by wcd 2015-09-10[加班流程] -->
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
	int nodetype = strUtil.parseToInt(request.getParameter("nodetype"), 0);
	int workflowid = strUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = strUtil.parseToInt(request.getParameter("formid"));
	int userid = strUtil.parseToInt(request.getParameter("userid"));
	String creater = strUtil.vString(request.getParameter("creater"), String.valueOf(userid));
	String[] fieldList = attProcSetManager.getFieldList(3, workflowid, formid);
	String currentdate = strUtil.vString(request.getParameter("currentdate"), dateUtil.getCurrentDate());
	String f_weaver_belongto_userid = strUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = strUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
	if(fieldList.length == 0) return;
%>
<script language="javascript">
	var formid = "<%=formid%>";
	var creater = "<%=creater%>";
	var _field_resourceId = "<%=fieldList[0]%>";
	var _field_fromdate = "<%=fieldList[1]%>";
	var _field_fromtime = "<%=fieldList[2]%>";
	var _field_tilldate = "<%=fieldList[3]%>";
	var _field_tilltime = "<%=fieldList[4]%>";
	var _field_overtimeDays = "<%=fieldList[5]%>";
	var _field_departmentId = "<%=fieldList[6]%>";
	var _field_otype = "<%=fieldList[7]%>";
	var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
	var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";
	
    jQuery(document).ready(function(){
      if(_field_overtimeDays != "") {
        try{
          WfForm.changeFieldAttr(_field_overtimeDays, 1);
        }catch(e){}
      }
      var changeFields =_field_resourceId+","+_field_fromdate+","+_field_fromtime+","+_field_tilldate+","+_field_tilltime;
      WfForm.bindFieldChangeEvent(changeFields, function(obj,id,value){
        // console.log("WfForm.bindFieldChangeEvent--",obj,id,value);
        wfbrowvaluechange_fna(obj, id, null);
      });
    });
	
	function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
      if(_field_fromdate==fieldid || _field_fromtime==fieldid || _field_tilldate==fieldid || _field_tilltime==fieldid){
        setOverDays();
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

	function setOverDays(){
      var resourceId = WfForm.getFieldValue(_field_resourceId);
      var fromdate = WfForm.getFieldValue(_field_fromdate);
      var fromtime = WfForm.getFieldValue(_field_fromtime);
      var tilldate = WfForm.getFieldValue(_field_tilldate);
      var tilltime = WfForm.getFieldValue(_field_tilltime);
		if(fromdate != '' && fromtime!='' && tilldate!='' && tilltime!=''){
			var ajax=ajaxInit();
			ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("operation=getLeaveDays&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&worktime=false&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromDate="+fromdate+"&fromTime="+fromtime+"&toDate="+tilldate+"&toTime="+tilltime+"&resourceId="+resourceId);
			ajax.onreadystatechange = function() {
				if (ajax.readyState == 4 && ajax.status == 200) {
					try {
						var result = jQuery.trim(ajax.responseText);
						WfForm.changeSingleField(_field_overtimeDays, {value:result}, {viewAttr:1}); 
					} catch(e) {
						WfForm.changeSingleField(_field_overtimeDays, {value:"0.0"}, {viewAttr:1}); 
					}
				}
			}
		}
	}
	
	
	checkCustomize = function() {
			
		var aa = WfForm.getFieldValue(_field_fromdate);
		var bb = WfForm.getFieldValue(_field_fromtime);
		var cc = WfForm.getFieldValue(_field_tilldate);
		var dd = WfForm.getFieldValue(_field_tilltime);
		var begin = new Date(aa.replace(/\-/g, "\/"));
		var end = new Date(cc.replace(/\-/g, "\/"));
		if(bb != "" && dd != ""){
			begin = new Date(aa.replace(/\-/g, "\/")+" "+bb+":00");  
			end = new Date(cc.replace(/\-/g, "\/")+" "+dd+":00");
			if(aa!=""&&cc!=""&&begin >end)  
			{  
                window.antd.message.warning("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
				return false;  
			}
		}else{
			if(aa!=""&&cc!=""&&begin >end)  
			{  
                window.antd.message.warning("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
				return false;  
			}
		}
		return true;
	};
</script>