<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.User"%>
<%@page import="com.engine.kq.wfset.attendance.manager.WorkflowBaseManager"%>
<%@ page import="com.engine.kq.wfset.attendance.domain.WorkflowBase" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.engine.kq.cmd.hrmAttProcSet.KqSplitActionEnum" %>
<%@ page import="com.engine.kq.wfset.util.KQAttFlowCheckUtil" %>
<%@ page import="com.engine.kq.enums.KqSplitFlowTypeEnum" %>
<%@ page import="com.engine.kq.wfset.util.SplitSelectSet" %>
<%@ page import="com.engine.kq.biz.KQLeaveRulesComInfo" %>
<%@ page import="weaver.general.StaticObj" %>
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
    Map<String,Object> result = attProcSetManager.getFieldList(6,workflowid, formid);
    String[] fieldList = (String[])result.get("fields");
    String usedetail = Util.null2String(result.get("usedetail"));
    String detailtablename = Util.null2String(result.get("detailtablename"));
    String attid = Util.null2String(result.get("attid"));

    String isAttOk = "1";
    String msgAttError = "";
    Map<String,String> check = KQAttFlowCheckUtil.checkAttFlow(result, KqSplitFlowTypeEnum.LEAVEBACK);

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
    KQLeaveRulesComInfo kqLeaveRulesComInfo = new KQLeaveRulesComInfo();

    String forenoon_start = SplitSelectSet.forenoon_start;
    String forenoon_end = SplitSelectSet.forenoon_end;
    String afternoon_start = SplitSelectSet.afternoon_start;
    String afternoon_end = SplitSelectSet.afternoon_end;
    String daylong_start = SplitSelectSet.daylong_start;
    String daylong_end = SplitSelectSet.daylong_end;

    String halfFromSel = "[{key:'"+forenoon_start+"',showname:'"+SystemEnv.getHtmlLabelName(16689, user.getLanguage())+"'},{key:'"+forenoon_end+"',showname:'"+SystemEnv.getHtmlLabelName(16690, user.getLanguage())+"'}]";
    String halfToSel = "[{key:'"+afternoon_start+"',showname:'"+SystemEnv.getHtmlLabelName(16689, user.getLanguage())+"'},{key:'"+afternoon_end+"',showname:'"+SystemEnv.getHtmlLabelName(16690, user.getLanguage())+"'}]";
    String wholeFromSel = "[{key:'"+daylong_start+"',showname:'"+SystemEnv.getHtmlLabelName(390728, user.getLanguage())+"'}]";
    String wholeToSel = "[{key:'"+daylong_end+"',showname:'"+SystemEnv.getHtmlLabelName(390728, user.getLanguage())+"'}]";
    StaticObj staticobj = StaticObj.getInstance();
    String half_leave_ruleid = Util.null2String(staticobj.getObject("half_leave_ruleid"));
    String whole_leave_ruleid = Util.null2String(staticobj.getObject("whole_leave_ruleid"));
%>
<script  src="/workflow/request/ext4e9/common.js"></script>
<script >
  var isMobile = WfForm.isMobile();
  var isAttOk = "<%=isAttOk%>";
  var formid = "<%=formid%>";
  var detail_dt = "<%=detail_dt%>";
  var _customAddFun = "<%=_customAddFun%>";
  var workflowid = "<%=workflowid%>";
  var nodeid = "<%=nodeid%>";
  var _field_resourceId = "<%=fieldList[0]%>";
  var _field_requestid = "<%=fieldList[1]%>";
  var _field_detail_leavefromDate = "<%=fieldList[2]%>";
  var _field_detail_leavefromTime = "<%=fieldList[3]%>";
  var _field_detail_leavetoDate = "<%=fieldList[4]%>";
  var _field_detail_leavetoTime = "<%=fieldList[5]%>";
  var _field_detail_newLeaveType = "<%=fieldList[6]%>";
  var _field_detail_leaveduration = "<%=fieldList[7]%>";

  var _field_detail_fromDate = "<%=fieldList[8]%>";
  var _field_detail_fromTime = "<%=fieldList[9]%>";
  var _field_detail_toDate = "<%=fieldList[10]%>";
  var _field_detail_toTime = "<%=fieldList[11]%>";
  var _field_detail_duration = "<%=fieldList[12]%>";
  var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
  var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";

  var halfFromSel = <%=halfFromSel%>;
  var halfToSel = <%=halfToSel%>;
  var wholeFromSel = <%=wholeFromSel%>;
  var wholeToSel = <%=wholeToSel%>;
  var half_leave_ruleid = "<%=half_leave_ruleid%>";
  var whole_leave_ruleid = "<%=whole_leave_ruleid%>";
  var msgAttError = "<%=msgAttError%>";

  jQuery(document).ready(function(){
    try{
      //不允许新增
      jQuery(".detailButtonDiv").find("#addbutton0").hide();

      var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
      if (detailAllRowIndexStr != "") {
        var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
        for (var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++) {
          var idx = detailAllRowIndexStr_array[rowIdx];
          var _key = _field_detail_leavefromTime+"_"+idx;
          var _key1 = _field_detail_leavetoTime+"_"+idx;
          var _key2 = _field_detail_fromTime+"_"+idx;
          var _key3 = _field_detail_toTime+"_"+idx;
          WfForm.changeFieldAttr(_field_detail_leavefromDate+"_"+idx, 1);
          WfForm.changeFieldAttr(_key, 1);
          WfForm.changeFieldAttr(_field_detail_leavetoDate+"_"+idx, 1);
          WfForm.changeFieldAttr(_key1, 1);
          WfForm.changeFieldAttr(_field_detail_newLeaveType+"_"+idx, 1);
          WfForm.changeFieldAttr(_field_detail_leaveduration+"_"+idx, 1);
          WfForm.changeFieldAttr(_field_detail_duration+"_"+idx, 1);
          var _newLeaveTypeVal = null2String(WfForm.getFieldValue(_field_detail_newLeaveType+"_"+idx));
          var _val_json = {};
          if(_newLeaveTypeVal != '' && half_leave_ruleid.indexOf(","+_newLeaveTypeVal+",") > -1){
            _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
            _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
            _val_json[_key2] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
            _val_json[_key3] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
            WfForm.changeMoreField({}, _val_json);
          }
          if(_newLeaveTypeVal != '' && whole_leave_ruleid.indexOf(","+_newLeaveTypeVal+",") > -1){
            _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
            _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
            _val_json[_key2] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
            _val_json[_key3] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
            WfForm.changeMoreField({}, _val_json);
          }
        }
      }

      var changeFields =_field_resourceId+","+_field_requestid;

      WfForm.bindFieldChangeEvent(changeFields, function(obj,id,value){
        _wfbrowvalue_onchange(obj,id,value);
      });

      var detailChangeFields =_field_detail_fromDate+","+_field_detail_fromTime
          +","+_field_detail_toDate+","+_field_detail_toTime;

      WfForm.bindDetailFieldChangeEvent(detailChangeFields, function(id,rowIndex,value){
        _wfbrowvalue_onchange_detail(id,rowIndex,value);
      });

      //绑定提交前事件
      WfForm.registerCheckEvent(WfForm.OPER_SUBMIT,function(callback){
        doBeforeSubmit_hrm(callback);
      });

      var f = "_customAddFun"+_customAddFun;
      window[f] = function (addIndexStr) {
        if(addIndexStr !=undefined && addIndexStr != null){
          WfForm.changeFieldAttr(_field_detail_leavefromDate+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_leavefromTime+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_leavetoDate+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_leavetoTime+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_newLeaveType+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_leaveduration+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_duration+"_"+addIndexStr, 1);
        }
      }

    }catch (e) {
    }
  });

  /**
   * 字段变化触发事件
   * @param obj
   * @param fieldid
   * @param rowindex
   * @private
   */
  function _wfbrowvalue_onchange(obj,id,value) {
    try {
      if (id == _field_requestid) {
        var _field_resourceIdVal = null2String(WfForm.getFieldValue(_field_resourceId));
        var _field_requestidVal = null2String(WfForm.getFieldValue(_field_requestid));
        if (null2String(_field_resourceIdVal) != "" && null2String(_field_requestidVal) != "") {
          var hasDetail = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
          if(hasDetail){
            if(isMobile){
              var confirm_msg=confirm("<%=SystemEnv.getHtmlLabelName(390798,user.getLanguage()) %>");
              if(confirm_msg){
                WfForm.delDetailRow("detail_"+detail_dt, "all");
                getRequestInfo(obj, id, value);
              }
            }else{
              window.antd.Modal.confirm({
                title: "<%=SystemEnv.getHtmlLabelName(15172,user.getLanguage()) %>",
                content: "<%=SystemEnv.getHtmlLabelName(390798,user.getLanguage()) %>",
                onOk: function(){
                  WfForm.delDetailRow("detail_"+detail_dt, "all");
                  getRequestInfo(obj, id, value);
                }
              });
            }
          }else{
            getRequestInfo(obj, id, value);
          }

        } else {
          WfForm.showMessage("<%=SystemEnv.getHtmlLabelName(506651, user.getLanguage())%>");
          return;
        }
      }
    }catch (e) {
    }
  }

  /**
   * 明细字段变化触发事件
   * @param obj
   * @param fieldid
   * @param rowindex
   * @private
   */
  function _wfbrowvalue_onchange_detail(id, rowIndex, value) {
    getWorkDuration(id,value,rowIndex);
  }

  function getWorkDuration(id,value,rowIndex){

    var _field_field_newLeaveType = _field_detail_newLeaveType;
    var _field_field_resourceId = _field_resourceId;
    var _field_field_fromDate = _field_detail_fromDate;
    var _field_field_fromTime = _field_detail_fromTime;
    var _field_field_toDate = _field_detail_toDate;
    var _field_field_toTime = _field_detail_toTime;
    var _field_field_duration = _field_detail_duration;
    if(rowIndex !=undefined && rowIndex != null && rowIndex != ""){
      _field_field_newLeaveType += "_"+rowIndex;
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
        }
      }
    });
  }

  function getRequestInfo(id,value,rowIndex){

    try {
      var _field_resourceIdVal = null2String(WfForm.getFieldValue(_field_resourceId));
      var _field_requestidVal = null2String(WfForm.getFieldValue(_field_requestid));
      var _data = "resourceId=" + _field_resourceIdVal + "&requestid=" + _field_requestidVal;
      jQuery.ajax({
        url: "/api/hrm/kq/attendanceEvent/getLeaveBackInfo",
        type: "post",
        processData: false,
        data: _data,
        dataType: "json",
        success: function do4Success(data) {
          if (data != null && data.status == "1") {
            var backs = data.backList;
            for (var i = 0; i < backs.length; i++) {
              var addDetailRow_paramObj = {};
              half_changeType = ","+backs[i].half_changeType+",";
              whole_changeType = ","+backs[i].whole_changeType+",";
              var cur_newleavetype = backs[i].newleavetype;
              var useHalf = "0";
              var useWhole = "0";
              if(cur_newleavetype != '' && half_changeType.indexOf(","+cur_newleavetype+",") > -1){
                useHalf = "1";
              }
              if(cur_newleavetype != '' && whole_changeType.indexOf(","+cur_newleavetype+",") > -1){
                useWhole = "1";
              }
              addDetailRow_paramObj[_field_detail_leavefromDate] = {value: backs[i].fromdatedb};
              addDetailRow_paramObj[_field_detail_leavefromTime] = {value: backs[i].fromtimedb};
              addDetailRow_paramObj[_field_detail_leavetoDate] = {value: backs[i].todatedb};
              addDetailRow_paramObj[_field_detail_leavetoTime] = {value: backs[i].totimedb};
              addDetailRow_paramObj[_field_detail_newLeaveType] = {value: cur_newleavetype};
              addDetailRow_paramObj[_field_detail_leaveduration] = {value: backs[i].durationdb};

              addDetailRow_paramObj[_field_detail_fromDate] = {value: backs[i].fromdatedb};
              addDetailRow_paramObj[_field_detail_fromTime] = {value: backs[i].fromtimedb};
              addDetailRow_paramObj[_field_detail_toDate] = {value: backs[i].todatedb};
              addDetailRow_paramObj[_field_detail_toTime] = {value: backs[i].totimedb};
              addDetailRow_paramObj[_field_detail_duration] = {value: backs[i].durationdb};
              WfForm.addDetailRow("detail_"+detail_dt, addDetailRow_paramObj);
              var allIndex = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
              var index = allIndex = allIndex.substring(allIndex.lastIndexOf(',')+1);
              var _key = _field_detail_leavefromTime+"_"+index;
              var _key1 = _field_detail_leavetoTime+"_"+index;
              var _key2 = _field_detail_fromTime+"_"+index;
              var _key3 = _field_detail_toTime+"_"+index;
              var _val_json = {};
              if(useHalf == "1"){
                _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
                _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
                _val_json[_key2] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
                _val_json[_key3] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
                WfForm.changeMoreField({}, _val_json);
              }else if(useWhole == "1"){
                _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
                _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
                var _val_json_val = {};
                _val_json[_key2] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
                _val_json[_key3] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
                WfForm.changeMoreField(_val_json_val, _val_json);
              }
            }
          } else if (data != null && data.status == "2") {
            var errorInfo = data.message;
            WfForm.showMessage(errorInfo);
            return;
          }
        }
      });
    }catch (e) {
      console.log(e);
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

      var resMap = [];
      var daysMap = {};
      var _field_resourceIdVal = null2String(WfForm.getFieldValue(_field_resourceId));
      var _field_requestidVal = null2String(WfForm.getFieldValue(_field_requestid));
      if((_field_resourceIdVal == null || _field_resourceIdVal == "")){
        WfForm.showMessage("销假人不能为空");
        return;
      }
      if((_field_requestidVal == null || _field_requestidVal == "")){
        WfForm.showMessage("请假流程不能为空");
        return;
      }

      var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
      if(detailAllRowIndexStr != ""){
        var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
        for(var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++){
          var idx = detailAllRowIndexStr_array[rowIdx];
          var _field_leavefromDate_val = WfForm.getFieldValue(_field_detail_leavefromDate+"_"+idx);
          var _field_leavefromTime_val = WfForm.getFieldValue(_field_detail_leavefromTime+"_"+idx);
          var _field_leavetoDate_val = WfForm.getFieldValue(_field_detail_leavetoDate+"_"+idx);
          var _field_leavetoTime_val = WfForm.getFieldValue(_field_detail_leavetoTime+"_"+idx);
          var _field_leaveduration_val = WfForm.getFieldValue(_field_detail_leaveduration+"_"+idx);

          var _field_newLeaveType_val = WfForm.getFieldValue(_field_detail_newLeaveType+"_"+idx);
          var _field_fromDate_val = WfForm.getFieldValue(_field_detail_fromDate+"_"+idx);
          var _field_fromTime_val = WfForm.getFieldValue(_field_detail_fromTime+"_"+idx);
          var _field_toDate_val = WfForm.getFieldValue(_field_detail_toDate+"_"+idx);
          var _field_toTime_val = WfForm.getFieldValue(_field_detail_toTime+"_"+idx);
          var _field_duration_val = WfForm.getFieldValue(_field_detail_duration+"_"+idx);

          if(!DateCheck(_field_fromDate_val,_field_fromTime_val,_field_toDate_val,_field_toTime_val,"<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>")){
            WfForm.controlBtnDisabled(false);
            return;
          }
          if(_field_leaveduration_val && _field_duration_val){
            if(parseFloat(_field_duration_val) > parseFloat(_field_leaveduration_val)){
              WfForm.showMessage("销假时长不能大于请假时长");
              WfForm.controlBtnDisabled(false);
              return;
            }
          }
          if((_field_newLeaveType_val == null || _field_newLeaveType_val == "") ){
            WfForm.showMessage("请根据请假流程选择正确的销假信息");
            WfForm.controlBtnDisabled(false);
            return;
          }
          if(!durationCheck(_field_duration_val,"<%=SystemEnv.getHtmlLabelName(391103,user.getLanguage())%>")){
            WfForm.controlBtnDisabled(false);
            return;
          }
          daysMap = {};
          daysMap["leavefromDate"] = _field_leavefromDate_val;
          daysMap["leavefromTime"] = _field_leavefromTime_val;
          daysMap["leavetoDate"] = _field_leavetoDate_val;
          daysMap["leavetoTime"] = _field_leavetoTime_val;
          daysMap["fromDate"] = _field_fromDate_val;
          daysMap["fromTime"] = _field_fromTime_val;
          daysMap["toDate"] = _field_toDate_val;
          daysMap["toTime"] = _field_toTime_val;
          resMap.push(daysMap);
        }
      }
      var resMap2json=JSON.stringify(resMap);
      var _data = "resMap="+resMap2json+"&workflowid="+workflowid+"&nodeid="+nodeid+"&leaverequestid="+_field_requestidVal;
      jQuery.ajax({
        url : "/api/hrm/kq/attendanceEvent/checkLeaveBack",
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
