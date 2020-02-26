<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.User"%>
<%@page import="com.engine.kq.wfset.attendance.manager.WorkflowBaseManager"%>
<%@ page import="com.engine.kq.wfset.attendance.domain.WorkflowBase" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.engine.kq.cmd.hrmAttProcSet.KqSplitActionEnum" %>
<%@ page import="com.engine.kq.enums.KqSplitFlowTypeEnum" %>
<%@ page import="com.engine.kq.wfset.util.KQAttFlowCheckUtil" %>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="attProcSetManager" class="com.engine.kq.wfset.attendance.manager.HrmAttProcSetManager" scope="page" />
<%
    User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
    int nodetype = Util.getIntValue(request.getParameter("nodetype"), 0);
    int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
    int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
    int formid = Util.getIntValue(request.getParameter("formid"));
    int userid = Util.getIntValue(request.getParameter("userid"));
    String creater = Util.null2s(request.getParameter("creater"), String.valueOf(userid));
    WorkflowBaseManager workflowBaseManager = new WorkflowBaseManager();
    if(formid == -1) {
        WorkflowBase bean = workflowBaseManager.get(workflowid);
        formid = bean == null ? -1 : bean.getFormid();
    }
    Map<String,Object> result = attProcSetManager.getFieldList(4,workflowid, formid);
    String[] fieldList = (String[])result.get("fields");
    String usedetail = Util.null2String(result.get("usedetail"));
    String detailtablename = Util.null2String(result.get("detailtablename"));

    String attid = Util.null2String(result.get("attid"));

    String isAttOk = "1";
    String msgAttError = "";
    Map<String,String> check = KQAttFlowCheckUtil.checkAttFlow(result, KqSplitFlowTypeEnum.OTHER);
    isAttOk = Util.null2s(check.get("isAttOk"),"0");
    msgAttError = Util.null2s(check.get("msgAttError"),"考勤流程设置有误");

    String currentdate = Util.null2s(request.getParameter("currentdate"), dateUtil.getCurrentDate());
    String f_weaver_belongto_userid = Util.null2s(request.getParameter("f_weaver_belongto_userid"),"");
    String f_weaver_belongto_usertype = Util.null2s(request.getParameter("f_weaver_belongto_usertype"),"");
%>
<script  src="/workflow/request/ext4e9/common.js"></script>
<script >
  var isAttOk = "<%=isAttOk%>";
  var usedetail = "<%=usedetail%>";
  var formid = "<%=formid%>";
  var _field_resourceId = "<%=fieldList[0]%>";
  var _field_fromDate = "<%=fieldList[2]%>";
  var _field_fromTime = "<%=fieldList[3]%>";
  var _field_toDate = "<%=fieldList[4]%>";
  var _field_toTime = "<%=fieldList[5]%>";
  var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
  var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";
  var msgAttError = "<%=msgAttError%>";

  jQuery(document).ready(function(){

    //绑定提交前事件
    WfForm.registerCheckEvent(WfForm.OPER_SUBMIT,function(callback){
      doBeforeSubmit_hrm(callback);
    });

  });

  //提交事件前出发函数
  function doBeforeSubmit_hrm(callback){
    try{
      WfForm.controlBtnDisabled(true);//把流程中的按钮置灰
      if("0" == isAttOk){
        WfForm.showMessage(msgAttError);
        WfForm.controlBtnDisabled(false);
        return;
      }

      if(usedetail == "1"){
        var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_1");
        if(detailAllRowIndexStr != ""){
          var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
          for(var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++){
            var idx = detailAllRowIndexStr_array[rowIdx];
            var _field_fromDate_val = WfForm.getFieldValue(_field_fromDate+"_"+idx);
            var _field_fromTime_val = WfForm.getFieldValue(_field_fromTime+"_"+idx);
            var _field_toDate_val = WfForm.getFieldValue(_field_toDate+"_"+idx);
            var _field_toTime_val = WfForm.getFieldValue(_field_toTime+"_"+idx);
            if(!DateCheck(_field_fromDate_val,_field_fromTime_val,_field_toDate_val,_field_toTime_val,"<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>")){
              WfForm.controlBtnDisabled(false);
              return;
            }
          }
        }
      }else{
        var _field_fromDate_val = WfForm.getFieldValue(_field_fromDate);
        var _field_fromTime_val = WfForm.getFieldValue(_field_fromTime);
        var _field_toDate_val = WfForm.getFieldValue(_field_toDate);
        var _field_toTime_val = WfForm.getFieldValue(_field_toTime);
        if(!DateCheck(_field_fromDate_val,_field_fromTime_val,_field_toDate_val,_field_toTime_val,"<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>")){
          WfForm.controlBtnDisabled(false);
          return;
        }
      }
      WfForm.controlBtnDisabled(false);
      callback();
      return;
    }catch(ex1){
      WfForm.controlBtnDisabled(false);//取消流程中的按钮置灰
      return;
    }
  }
</script>
