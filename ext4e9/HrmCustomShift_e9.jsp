<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.engine.kq.enums.KqSplitFlowTypeEnum,com.engine.kq.wfset.attendance.domain.WorkflowBase,com.engine.kq.wfset.attendance.manager.WorkflowBaseManager,com.engine.kq.wfset.util.KQAttFlowCheckUtil" %>
<%@ page import="java.util.Map"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User" %>
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
    Map<String,Object> result = attProcSetManager.getFieldList(5,workflowid, formid);
    String[] fieldList = (String[])result.get("fields");
    String usedetail = Util.null2String(result.get("usedetail"));
    String detailtablename = Util.null2String(result.get("detailtablename"));
    String attid = Util.null2String(result.get("attid"));

    String isAttOk = "1";
    String msgAttError = "";
    Map<String,String> check = KQAttFlowCheckUtil.checkAttFlow(result, KqSplitFlowTypeEnum.SHIFT);
    isAttOk = Util.null2s(check.get("isAttOk"),"0");
    msgAttError = Util.null2s(check.get("msgAttError"),"考勤流程设置有误");

    int _customAddFun = 0;
    String detail_dt = "1";
    int detailLen = detailtablename.lastIndexOf("_");
    //+3表示_dt
    if(detailtablename.length() > (detailLen+3)){
        detail_dt = detailtablename.substring(detailLen+3);
        _customAddFun = Util.getIntValue(detail_dt)-1;
    }

    String currentdate = Util.null2s(request.getParameter("currentdate"), dateUtil.getCurrentDate());
    String f_weaver_belongto_userid = Util.null2s(request.getParameter("f_weaver_belongto_userid"),"");
    String f_weaver_belongto_usertype = Util.null2s(request.getParameter("f_weaver_belongto_usertype"),"");

%>
<script  src="/workflow/request/ext4e9/common.js"></script>
<script >
  var isAttOk = "<%=isAttOk%>";
  var usedetail = "<%=usedetail%>";
  var formid = "<%=formid%>";
  var detail_dt = "<%=detail_dt%>";
  var _customAddFun = "<%=_customAddFun%>";
  var _field_resourceId = "<%=fieldList[0]%>";
  var _field_fromDate = "<%=fieldList[1]%>";
  var _field_toDate = "<%=fieldList[2]%>";
  var _field_shift = "<%=fieldList[3]%>";
  var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
  var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";
  var msgAttError = "<%=msgAttError%>";

  jQuery(document).ready(function(){
    try{
      var changeFields = _field_resourceId+","+_field_shift+","+_field_fromDate;

      WfForm.bindDetailFieldChangeEvent(changeFields, function(id,rowIndex,value){
        _wfbrowvalue_onchange_detail(id,rowIndex,value);
      });
      //绑定提交前事件
      WfForm.registerCheckEvent(WfForm.OPER_SUBMIT,function(callback){
        doBeforeSubmit_hrm(callback);
      });
      var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
      if (detailAllRowIndexStr != "") {
        var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
        for (var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++) {
          var idx = detailAllRowIndexStr_array[rowIdx];
          var _key = _field_resourceId+"_"+idx;
          var _key1 = _field_fromDate+"_"+idx;
          var _field_resourceId_val = WfForm.getFieldValue(_key);
          var _field_fromDate_val = WfForm.getFieldValue(_key1);
          WfForm.appendBrowserDataUrlParam(_field_shift+"_"+idx,{"resourceId":_field_resourceId_val,"fromDate":_field_fromDate_val});
        }
      }

      var f = "_customAddFun"+_customAddFun;
      window[f] = function (addIndexStr) {
        if(addIndexStr !=undefined && addIndexStr != null){
          var _key = _field_resourceId+"_"+addIndexStr;
          var _key1 = _field_fromDate+"_"+addIndexStr;
          var _field_resourceId_val = WfForm.getFieldValue(_key);
          var _field_fromDate_val = WfForm.getFieldValue(_key1);
          WfForm.appendBrowserDataUrlParam(_field_shift+"_"+addIndexStr,{"resourceId":_field_resourceId_val,"fromDate":_field_fromDate_val});
        }
      }
    }catch(e){
      // console.log(e);
    }

  });
  /**
   * 明细字段变化触发事件
   * @param obj
   * @param fieldid
   * @param rowindex
   * @private
   */
  function _wfbrowvalue_onchange_detail(id, rowIndex, value) {
    try{
      if(id == _field_resourceId || id == _field_fromDate){
        var _key = _field_resourceId+"_"+rowIndex;
        var _key1 = _field_fromDate+"_"+rowIndex;
        var _field_resourceId_val = WfForm.getFieldValue(_key);
        var _field_fromDate_val = WfForm.getFieldValue(_key1);
        WfForm.appendBrowserDataUrlParam(_field_shift+"_"+rowIndex,{"resourceId":_field_resourceId_val,"fromDate":_field_fromDate_val});
      }
    }catch(ex1){
      return;
    }
  }

  //提交事件前出发函数
  function doBeforeSubmit_hrm(callback){
    try{
      WfForm.controlBtnDisabled(true);//把流程中的按钮置灰
      if("0" == isAttOk){
        WfForm.showMessage(msgAttError);
        WfForm.controlBtnDisabled(false);
        return;
      }
      var dataArray = new Array();
      var dataMap = {};
      var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
      if(detailAllRowIndexStr != ""){
        var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
        for(var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++){
          var idx = detailAllRowIndexStr_array[rowIdx];
          var _field_resourceId_val = WfForm.getFieldValue(_field_resourceId+"_"+idx);
          var _field_fromDate_val = WfForm.getFieldValue(_field_fromDate+"_"+idx);
          var _field_toDate_val = WfForm.getFieldValue(_field_toDate+"_"+idx);
          var _field_shift_val = WfForm.getFieldValue(_field_shift+"_"+idx);
          dataMap = {};
          dataMap["resourceId"] = _field_resourceId_val;
          dataMap["fromDate"] = _field_fromDate_val;
          dataMap["toDate"] = _field_toDate_val;
          dataMap["shift"] = _field_shift_val;
          dataArray[rowIdx] = dataMap;
        }
      }
      var data2json=JSON.stringify(dataArray);
      var _data = "data="+data2json;

      jQuery.ajax({
        url : "/api/hrm/kq/attendanceEvent/checkShift",
        type : "post",
        processData : false,
        data : _data,
        dataType : "json",
        success: function do4Success(data){
          if(data != null && data.status == "1"){
            WfForm.controlBtnDisabled(false);
            callback(); //继续提交需调用callback，不调用代表阻断
            return;
          }else{
            var errorInfo = data.message;
            WfForm.controlBtnDisabled(false);
            WfForm.showMessage(errorInfo);
            return;
          }
        }
      });
    }catch(ex1){
      WfForm.controlBtnDisabled(false);//取消流程中的按钮置灰
      return;
    }
  }
</script>
