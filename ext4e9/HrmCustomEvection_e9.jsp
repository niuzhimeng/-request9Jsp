<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.engine.kq.biz.KQTravelRulesBiz,com.engine.kq.enums.KqSplitFlowTypeEnum,com.engine.kq.wfset.attendance.domain.WorkflowBase,com.engine.kq.wfset.attendance.manager.WorkflowBaseManager" %>
<%@ page import="com.engine.kq.wfset.util.KQAttFlowCheckUtil"%>
<%@page import="com.engine.kq.wfset.util.SplitSelectSet"%>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

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
    Map<String,Object> result = attProcSetManager.getFieldList(1,workflowid, formid);
    String[] fieldList = (String[])result.get("fields");
    String usedetail = Util.null2String(result.get("usedetail"));
    String detailtablename = Util.null2String(result.get("detailtablename"));
    String attid = Util.null2String(result.get("attid"));

    String isAttOk = "1";
    String msgAttError = "";
    Map<String,String> check = KQAttFlowCheckUtil.checkAttFlow(result, KqSplitFlowTypeEnum.EVECTION);
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

    boolean isHalf = false;
    boolean isWhole = false;

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


    String minimumUnit = KQTravelRulesBiz.getMinimumUnit();
    if("2".equalsIgnoreCase(minimumUnit)){
        isHalf = true;
    }
    if("4".equalsIgnoreCase(minimumUnit)){
        isWhole = true;
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
  var _field_fromDate = "<%=fieldList[2]%>";
  var _field_fromTime = "<%=fieldList[3]%>";
  var _field_toDate = "<%=fieldList[4]%>";
  var _field_toTime = "<%=fieldList[5]%>";
  var _field_duration = "<%=fieldList[6]%>";
  var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
  var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";

  var useHalf = "<%=isHalf?"1":"0"%>";
  var useWhole = "<%=isWhole?"1":"0"%>";
  var halfFromSel = <%=halfFromSel%>;
  var halfToSel = <%=halfToSel%>;
  var wholeFromSel = <%=wholeFromSel%>;
  var wholeToSel = <%=wholeToSel%>;
  var msgAttError = "<%=msgAttError%>";

  jQuery(document).ready(function(){
    try{

        if(usedetail != "1"){
          if(_field_duration != "") {
            WfForm.changeFieldAttr(_field_duration, 1);
          }
          if(_field_fromTime != "") {
            var _val_json = {};
            if(useHalf == "1"){
              _val_json[_field_fromTime] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
              WfForm.changeMoreField({}, _val_json);
            }else if(useWhole == "1"){
              _val_json[_field_fromTime] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
              WfForm.changeMoreField({}, _val_json);
            }
          }
          if(_field_toTime != "") {
            var _val_json = {};
            if(useHalf == "1"){
              _val_json[_field_toTime] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
              WfForm.changeMoreField({}, _val_json);
            }else if(useWhole == "1"){
              _val_json[_field_toTime] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
              WfForm.changeMoreField({}, _val_json);
            }
          }
          getWorkDuration('','','');
        }else{
          var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
          if (detailAllRowIndexStr != "") {
            var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
            for (var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++) {
              var idx = detailAllRowIndexStr_array[rowIdx];
              var _key = _field_fromTime+"_"+idx;
              var _key1 = _field_toTime+"_"+idx;
              var _key2 = _field_duration+"_"+idx;
              var _val_json = {};
              if(useHalf == "1"){
                _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
                _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
                WfForm.changeMoreField({}, _val_json);
              }else if(useWhole == "1"){
                _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
                _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
                WfForm.changeMoreField({}, _val_json);
              }
              WfForm.changeFieldAttr(_key2, 1);
              getWorkDuration('','',idx);
            }
          }
        }
        var changeFields =_field_resourceId+","+_field_fromDate+","+_field_fromTime
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
            var _key = _field_fromTime+"_"+addIndexStr;
            var _key1 = _field_toTime+"_"+addIndexStr;
            var _key2 = _field_duration+"_"+addIndexStr;
            var _val_json = {};
            if(useHalf == "1"){
              _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfFromSel};
              _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:halfToSel};
              WfForm.changeMoreField({}, _val_json);
            }else if(useWhole == "1"){
              _val_json[_key] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeFromSel};
              _val_json[_key1] = {changeFieldType:"5-1",changeFieldTypeSelectOption:wholeToSel};
              WfForm.changeMoreField({}, _val_json);
            }
            var _val_json = {};
            var _viewAttr_json = {};
            _viewAttr_json[_key2] = {viewAttr:1};
            WfForm.changeMoreField(_val_json,_viewAttr_json);
          }
        }
      }
    }catch(e){
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
    getWorkDuration(id,value,rowIndex);
  }
  /**
   * 字段变化触发事件
   * @param obj
   * @param fieldid
   * @param rowindex
   * @private
   */
  function _wfbrowvalue_onchange(obj,id,value) {
    getWorkDuration("",value,"");
  }

  function getWorkDuration(id,value,rowIndex){

    var _field_field_resourceId = _field_resourceId;
    var _field_field_fromDate = _field_fromDate;
    var _field_field_fromTime = _field_fromTime;
    var _field_field_toDate = _field_toDate;
    var _field_field_toTime = _field_toTime;
    var _field_field_duration = _field_duration;
    if(rowIndex !=undefined && rowIndex != null && rowIndex != ""){
      _field_field_resourceId += "_"+rowIndex;
      _field_field_fromDate += "_"+rowIndex;
      _field_field_fromTime += "_"+rowIndex;
      _field_field_toDate += "_"+rowIndex;
      _field_field_toTime += "_"+rowIndex;
      _field_field_duration += "_"+rowIndex;
    }
    var _field_resourceIdVal = null2String(WfForm.getFieldValue(_field_field_resourceId));
    var _field_fromDateVal = null2String(WfForm.getFieldValue(_field_field_fromDate));
    var _field_fromTimeVal = null2String(WfForm.getFieldValue(_field_field_fromTime));
    var _field_toDateVal = null2String(WfForm.getFieldValue(_field_field_toDate));
    var _field_toTimeVal = null2String(WfForm.getFieldValue(_field_field_toTime));
    var _data = "resourceId="+_field_resourceIdVal+"&fromDate="+_field_fromDateVal
        +"&fromTime="+_field_fromTimeVal+"&toDate="+_field_toDateVal+"&toTime="+_field_toTimeVal;
	
	if(!_field_resourceIdVal || !_field_fromDateVal) return;
	
    jQuery.ajax({
      url : "/api/hrm/kq/attendanceEvent/getEvectionWorkDuration",
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

      if(usedetail == "1"){
        var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
        if(detailAllRowIndexStr != ""){
          var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
          for(var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++){
            var idx = detailAllRowIndexStr_array[rowIdx];
            var _field_fromDate_val = WfForm.getFieldValue(_field_fromDate+"_"+idx);
            var _field_fromTime_val = WfForm.getFieldValue(_field_fromTime+"_"+idx);
            var _field_toDate_val = WfForm.getFieldValue(_field_toDate+"_"+idx);
            var _field_toTime_val = WfForm.getFieldValue(_field_toTime+"_"+idx);
			
			//移动端增加半天和全天时间校验byzqb
              if(useHalf == "1"){
                  if(_field_fromTime_val != "08:00" && _field_fromTime_val != "13:00"){
                      WfForm.showMessage("开始时间不符合半天规则,请重新选择");  //开始时间不符合半天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }

                  if(_field_toTime_val != "13:00" && _field_toTime_val != "18:00"){
                      WfForm.showMessage("结束时间不符合半天规则,请重新选择");  //结束时间不符合半天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }
              }else if(useWhole == "1"){
                  if(_field_fromTime_val != "08:00"){
                      WfForm.showMessage("开始时间不符合全天规则,请重新选择");  //开始时间不符合全天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }

                  if(_field_toTime_val != "18:00"){
                      WfForm.showMessage("结束时间不符合全天规则,请重新选择");  //结束时间不符合全天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }

              }
			
			
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
		
		//移动端增加半天和全天时间校验byzqb
              if(useHalf == "1"){
                  if(_field_fromTime_val != "08:00" && _field_fromTime_val != "13:00"){
                      WfForm.showMessage("开始时间不符合半天规则,请重新选择");  //开始时间不符合半天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }

                  if(_field_toTime_val != "13:00" && _field_toTime_val != "18:00"){
                      WfForm.showMessage("结束时间不符合半天规则,请重新选择");  //结束时间不符合半天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }
              }else if(useWhole == "1"){
                  if(_field_fromTime_val != "08:00"){
                      WfForm.showMessage("开始时间不符合全天规则,请重新选择");  //开始时间不符合全天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }

                  if(_field_toTime_val != "18:00"){
                      WfForm.showMessage("结束时间不符合全天规则,请重新选择");  //结束时间不符合全天规则,请重新选择！
                      WfForm.controlBtnDisabled(false);
                      return;
                  }

              }
		
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
