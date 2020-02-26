<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.engine.kq.enums.KqSplitFlowTypeEnum,com.engine.kq.wfset.attendance.domain.WorkflowBase,com.engine.kq.wfset.attendance.manager.WorkflowBaseManager,com.engine.kq.wfset.util.KQAttFlowCheckUtil" %>
<%@ page import="java.util.Map"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="attProcSetManager" class="com.engine.kq.wfset.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="KQBalanceOfLeaveBiz" class="com.engine.kq.biz.KQBalanceOfLeaveBiz" scope="page" />
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
    Map<String,Object> result = attProcSetManager.getFieldList(0,workflowid, formid);
    String[] fieldList = (String[])result.get("fields");
    String usedetail = Util.null2String(result.get("usedetail"));
    String detailtablename = Util.null2String(result.get("detailtablename"));
    String attid = Util.null2String(result.get("attid"));

    String isAttOk = "1";
    String msgAttError = "";
    Map<String,String> check = KQAttFlowCheckUtil.checkAttFlow(result, KqSplitFlowTypeEnum.LEAVE);
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
  var detail_dt = "<%=detail_dt%>";
  var _customAddFun = "<%=_customAddFun%>";
  var formid = "<%=formid%>";
  var workflowid = "<%=workflowid%>";
  var nodeid = "<%=nodeid%>";
  var _field_resourceId = "<%=fieldList[0]%>";
  var _field_newLeaveType = "<%=fieldList[2]%>";
  var _field_fromDate = "<%=fieldList[3]%>";
  var _field_fromTime = "<%=fieldList[4]%>";
  var _field_toDate = "<%=fieldList[5]%>";
  var _field_toTime = "<%=fieldList[6]%>";
  var _field_duration = "<%=fieldList[7]%>";
  var _field_vacationInfo = "<%=fieldList[8]%>";
  var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
  var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";
  var msgAttError = "<%=msgAttError%>";
  var min_duration = "";

  jQuery(document).ready(function(){
    try{

      if(usedetail != "1"){
        if(_field_resourceId != "") {
          try{
            getVacationInfo();
            WfForm.changeFieldAttr(_field_vacationInfo, 1);
          }catch(e){}
        }
        if(_field_duration != "") {
          try{
            WfForm.changeFieldAttr(_field_duration, 1);
          }catch(e){}
        }
      }else{
        var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
        if (detailAllRowIndexStr != "") {
          var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
          for (var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++) {
            var idx = detailAllRowIndexStr_array[rowIdx];
            getVacationInfo("","",idx);
            WfForm.changeFieldAttr(_field_duration+"_"+idx, 1);
            WfForm.changeFieldAttr(_field_vacationInfo+"_"+idx, 1);
          }
        }
      }
      var changeFields =_field_resourceId+","+_field_newLeaveType+","+_field_fromDate+","+_field_fromTime
          +","+_field_toDate+","+_field_toTime;

      if(usedetail == "1"){
        WfForm.bindDetailFieldChangeEvent(changeFields, function(id,rowIndex,value){
          _wfbrowvalue_onchange_detail(id,rowIndex,value);
        });
      }else{
        WfForm.bindFieldChangeEvent(changeFields, function(obj,id,value){
          _wfbrowvalue_onchange(obj,id,value);
        });
      }

      //绑定提交前事件
      WfForm.registerCheckEvent(WfForm.OPER_SUBMIT,function(callback){
        doBeforeSubmit_hrm(callback);
      });

      if(usedetail == "1"){
        var f = "_customAddFun"+_customAddFun;
        window[f] = function (addIndexStr) {
          if(addIndexStr !=undefined && addIndexStr != null){
            WfForm.changeFieldAttr(_field_duration+"_"+addIndexStr, 1);
            WfForm.changeFieldAttr(_field_vacationInfo+"_"+addIndexStr, 1);
          }
        }

      }
    }catch (e) {
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
    if(id == _field_newLeaveType || id == _field_vacationInfo){
      getVacationInfo(id,value,rowIndex);
    }else if(id == _field_fromDate || id == _field_fromTime || id == _field_toDate || id == _field_toTime){
      getWorkDuration(id,value,rowIndex);
      if(id == _field_fromDate){
        getVacationInfo(id,value,rowIndex);
      }
    }else if(id == _field_resourceId){
      getVacationInfo(id,value,rowIndex);
    }
  }
  /**
   * 字段变化触发事件
   * @param obj
   * @param fieldid
   * @param rowindex
   * @private
   */
  function _wfbrowvalue_onchange(obj,id,value) {
    if(id == _field_newLeaveType || id == _field_vacationInfo){
      getVacationInfo("",value,"");
    }else if(id == _field_fromDate || id == _field_fromTime || id == _field_toDate || id == _field_toTime){
      getWorkDuration("",value,"");
      if(id == _field_fromDate){
        getVacationInfo("",value,"");
      }
    }else if(id == _field_resourceId){
      getVacationInfo("",value,"");
    }
  }

  function getVacationInfo(id,value,rowIndex){
    var _field_field_resourceId = _field_resourceId;
    var _field_field_newLeaveType = _field_newLeaveType;
    var _field_field_vacationInfo = _field_vacationInfo;
    var _field_field_field_fromDate = _field_fromDate;
    if(rowIndex !=undefined && rowIndex != null && rowIndex != ""){
      _field_field_resourceId += "_"+rowIndex;
      _field_field_newLeaveType += "_"+rowIndex;
      _field_field_vacationInfo += "_"+rowIndex;
      _field_field_field_fromDate += "_"+rowIndex;
    }
    var _newLeaveTypeVal = null2String(WfForm.getFieldValue(_field_field_newLeaveType));
    var _resourceIdVal = null2String(WfForm.getFieldValue(_field_field_resourceId));
    var _fromDateVal = null2String(WfForm.getFieldValue(_field_field_field_fromDate));
    var _data = "newLeaveType="+_newLeaveTypeVal+"&resourceId="+_resourceIdVal+"&fromDate="+_fromDateVal;

    jQuery.ajax({
      url : "/api/hrm/kq/attendanceEvent/getVacationInfo",
      type : "post",
      processData : false,
      data : _data,
      dataType : "json",
      success: function do4Success(data){
        if(data != null && data.status == "1"){
          var _key = _field_field_vacationInfo;
          var _val_json = {};
          var _viewAttr_json = {};
          _val_json[_key] = {value:data.vacationInfo};
          _viewAttr_json[_key] = {viewAttr:1};
          WfForm.changeMoreField(_val_json,_viewAttr_json);
          getWorkDuration(id,value,rowIndex);
        }else if(data.status == "2"){
          var _key = _field_field_vacationInfo;
          var _val_json = {};
          var _viewAttr_json = {};
          _val_json[_key] = {value:''};
          _viewAttr_json[_key] = {viewAttr:1};
          WfForm.changeMoreField(_val_json,_viewAttr_json);
          getWorkDuration(id,value,rowIndex);
        }
      }
    });
  }

  function getWorkDuration(id,value,rowIndex){

    var _field_field_newLeaveType = _field_newLeaveType;
    var _field_field_resourceId = _field_resourceId;
    var _field_field_fromDate = _field_fromDate;
    var _field_field_fromTime = _field_fromTime;
    var _field_field_toDate = _field_toDate;
    var _field_field_toTime = _field_toTime;
    var _field_field_duration = _field_duration;
    if(rowIndex !=undefined && rowIndex != null && rowIndex != ""){
      _field_field_newLeaveType += "_"+rowIndex;
      _field_field_resourceId += "_"+rowIndex;
      _field_field_fromDate += "_"+rowIndex;
      _field_field_fromTime += "_"+rowIndex;
      _field_field_toDate += "_"+rowIndex;
      _field_field_toTime += "_"+rowIndex;
      _field_field_duration += "_"+rowIndex;
    }
    var _newLeaveTypeVal = null2String(WfForm.getFieldValue(_field_field_newLeaveType));
    var _field_resourceIdVal = null2String(WfForm.getFieldValue(_field_field_resourceId));
    var _field_fromDateVal = null2String(WfForm.getFieldValue(_field_field_fromDate));
    var _field_fromTimeVal = null2String(WfForm.getFieldValue(_field_field_fromTime));
    var _field_toDateVal = null2String(WfForm.getFieldValue(_field_field_toDate));
    var _field_toTimeVal = null2String(WfForm.getFieldValue(_field_field_toTime));
    var _data = "newLeaveType="+_newLeaveTypeVal+"&resourceId="+_field_resourceIdVal+"&fromDate="+_field_fromDateVal
        +"&fromTime="+_field_fromTimeVal+"&toDate="+_field_toDateVal+"&toTime="+_field_toTimeVal;
	
	if(!_field_resourceIdVal || !_field_fromDateVal) return ;
		
    jQuery.ajax({
      url : "/api/hrm/kq/attendanceEvent/getLeaveWorkDuration",
      type : "post",
      processData : false,
      data : _data,
      dataType : "json",
      success: function do4Success(data){
        if(data != null && data.status == "1"){
          var _key = _field_field_duration;
          var _val_json = {};
          var _viewAttr_json = {};
          _val_json[_key] = {value:data.duration};
          _viewAttr_json[_key] = {viewAttr:1};
          WfForm.changeMoreField(_val_json,_viewAttr_json);
          min_duration = data.min_duration;
        }else{
          if(data.message){
            WfForm.showMessage(data.message);
          }
        }
      }
    });
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

      var resMap = {};
      var daysMap = {};
      var otherMap = {};

      if(usedetail == "1"){
        var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
        if(detailAllRowIndexStr != ""){
          var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
          for(var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++){
            var idx = detailAllRowIndexStr_array[rowIdx];
            var _field_resourceId_val = WfForm.getFieldValue(_field_resourceId+"_"+idx);
            var _field_newLeaveType_val = WfForm.getFieldValue(_field_newLeaveType+"_"+idx);
            var _field_fromDate_val = WfForm.getFieldValue(_field_fromDate+"_"+idx);
            var _field_fromTime_val = WfForm.getFieldValue(_field_fromTime+"_"+idx);
            var _field_toDate_val = WfForm.getFieldValue(_field_toDate+"_"+idx);
            var _field_toTime_val = WfForm.getFieldValue(_field_toTime+"_"+idx);
            var _field_duration_val = WfForm.getFieldValue(_field_duration+"_"+idx);
            if(!DateCheck(_field_fromDate_val,_field_fromTime_val,_field_toDate_val,_field_toTime_val,"<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>")){
              WfForm.controlBtnDisabled(false);
              return;
            }
            var leavetype_key = _field_fromDate_val+"_"+_field_newLeaveType_val;
            if(resMap[_field_resourceId_val]){
              var tmpResMap = resMap[_field_resourceId_val];
              if(tmpResMap[leavetype_key]){
                var tmpDay = tmpResMap[leavetype_key];
                tmpResMap[leavetype_key] = parseFloat(tmpDay)+parseFloat(_field_duration_val);
              }else{
                tmpResMap[leavetype_key] = parseFloat(_field_duration_val);
              }
            }else{
              daysMap = {};
              daysMap[leavetype_key] = parseFloat(_field_duration_val);
              resMap[_field_resourceId_val] = daysMap;
            }
          }
        }
      }else{
        var _field_resourceId_val = WfForm.getFieldValue(_field_resourceId);
        var _field_newLeaveType_val = WfForm.getFieldValue(_field_newLeaveType);
        var _field_fromDate_val = WfForm.getFieldValue(_field_fromDate);
        var _field_fromTime_val = WfForm.getFieldValue(_field_fromTime);
        var _field_toDate_val = WfForm.getFieldValue(_field_toDate);
        var _field_toTime_val = WfForm.getFieldValue(_field_toTime);
        var _field_duration_val = WfForm.getFieldValue(_field_duration);
        if(!DateCheck(_field_fromDate_val,_field_fromTime_val,_field_toDate_val,_field_toTime_val,"<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>")){
          WfForm.controlBtnDisabled(false);
          return;
        }
        var leavetype_key = _field_fromDate_val+"_"+_field_newLeaveType_val;
        daysMap[leavetype_key] = parseFloat(_field_duration_val);
        resMap[_field_resourceId_val] = daysMap;
      }
      var resMap2json=JSON.stringify(resMap);
      var _data = "resMap="+resMap2json+"&workflowid="+workflowid+"&nodeid="+nodeid+"&min_duration="+min_duration;

      jQuery.ajax({
        url : "/api/hrm/kq/attendanceEvent/checkLeave",
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
