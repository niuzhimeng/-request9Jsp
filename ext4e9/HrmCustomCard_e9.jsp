<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.User"%>
<%@page import="com.engine.kq.wfset.attendance.manager.WorkflowBaseManager"%>
<%@ page import="com.engine.kq.wfset.attendance.domain.WorkflowBase" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="com.engine.kq.cmd.hrmAttProcSet.KqSplitActionEnum" %>
<%@ page import="com.engine.kq.wfset.util.KQAttFlowCheckUtil" %>
<%@ page import="com.engine.kq.enums.KqSplitFlowTypeEnum" %>
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
    Map<String,Object> result = attProcSetManager.getFieldList(7,workflowid, formid);
    String[] fieldList = (String[])result.get("fields");
    String detailtablename = Util.null2String(result.get("detailtablename"));
    String attid = Util.null2String(result.get("attid"));

    String isAttOk = "1";
    String msgAttError = "";
    Map<String,String> check = KQAttFlowCheckUtil.checkAttFlow(result, KqSplitFlowTypeEnum.CARD);
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
  var isMobile = WfForm.isMobile();
  var isAttOk = "<%=isAttOk%>";
  var formid = "<%=formid%>";
  var detail_dt = "<%=detail_dt%>";
  var _customAddFun = "<%=_customAddFun%>";
  var _field_resourceId = "<%=fieldList[0]%>";
  var _field_fromDate = "<%=fieldList[1]%>";
  var _field_toDate = "<%=fieldList[2]%>";
  var _field_detail_scheduletime = "<%=fieldList[3]%>";
  var _field_detail_atteStatus = "<%=fieldList[4]%>";
  var _field_detail_signtype = "<%=fieldList[5]%>";
  var _field_detail_signdate = "<%=fieldList[6]%>";
  var _field_detail_signtime = "<%=fieldList[7]%>";
  var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
  var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";
  var msgAttError = "<%=msgAttError%>";

  jQuery(document).ready(function(){
    try{

      var detailAllRowIndexStr = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
      if (detailAllRowIndexStr != "") {
        var detailAllRowIndexStr_array = detailAllRowIndexStr.split(",");
        for (var rowIdx = 0; rowIdx < detailAllRowIndexStr_array.length; rowIdx++) {
          var idx = detailAllRowIndexStr_array[rowIdx];
          WfForm.changeFieldAttr(_field_detail_scheduletime+"_"+idx, 1);
          WfForm.changeFieldAttr(_field_detail_atteStatus+"_"+idx, 1);
        }
      }
      var tempDate1="";
      var tempDate2="";
      var changeFields =_field_resourceId+","+_field_fromDate+","+_field_toDate;
      WfForm.bindFieldChangeEvent(changeFields, function(obj,id,value){
          if(tempDate1!=""&&tempDate2!=""){
              if(tempDate1 == tempDate2&&tempDate2==_field_fromDate&&_field_fromDate==_field_toDate){
                  tempDate1 = "";
                  tempDate2 = "";
                  return;
              }
          }else{
              tempDate1 = _field_fromDate;
              tempDate2 = _field_toDate;
          }
        _wfbrowvalue_onchange(obj,id,value);
      });
      //绑定提交前事件
      WfForm.registerCheckEvent(WfForm.OPER_SUBMIT,function(callback){
        doBeforeSubmit_hrm(callback);
      });

      var f = "_customAddFun"+_customAddFun;
      window[f] = function (addIndexStr) {
        //明细1新增成功后触发事件，addIndexStr即刚新增的行标示，
        if(addIndexStr !=undefined && addIndexStr != null){
          WfForm.changeFieldAttr(_field_detail_scheduletime+"_"+addIndexStr, 1);
          WfForm.changeFieldAttr(_field_detail_atteStatus+"_"+addIndexStr, 1);
        }
      }
    }catch (e) {
    }
  });

  function _wfbrowvalue_onchange(obj,id,value) {
    try{
      var hasDetail = WfForm.getDetailAllRowIndexStr("detail_"+detail_dt);
      if(hasDetail){
        //将根据考勤时间区间重新生成补卡明细数据，确认删除现有补卡明细数据吗?
		if(isMobile){
			var confirm_msg=confirm("<%=SystemEnv.getHtmlLabelName(390731,user.getLanguage()) %>");
			if(confirm_msg){				
				WfForm.delDetailRow("detail_"+detail_dt, "all");
				getAttendanceCard();
			}
		}else{			
			window.antd.Modal.confirm({
			  title: "<%=SystemEnv.getHtmlLabelName(15172,user.getLanguage()) %>",
			  content: "<%=SystemEnv.getHtmlLabelName(390731,user.getLanguage()) %>",
			  onOk: function(){
				WfForm.delDetailRow("detail_"+detail_dt, "all");
				getAttendanceCard();
			  }
			});
		}
      }else{
        getAttendanceCard();
      }
    }catch(ex1){
    }
  }

  function getAttendanceCard(){
    var _field_resourceIdVal = null2String(WfForm.getFieldValue(_field_resourceId));
    var _field_fromDateVal = null2String(WfForm.getFieldValue(_field_fromDate));
    var _field_toDateVal = null2String(WfForm.getFieldValue(_field_toDate));
    var _data = "resourceId="+_field_resourceIdVal+"&fromDate="+_field_fromDateVal+"&toDate="+_field_toDateVal;
    jQuery.ajax({
      url : "/api/hrm/kq/attendanceEvent/getAttendanceCard",
      type : "post",
      processData : false,
      data : _data,
      dataType : "json",
      success: function do4Success(data){
        if(data != null && data.status == "1"){
          var cards = data.cardlist;
          for(var i = 0; i < cards.length; i++){
            var addDetailRow_paramObj = {};
            addDetailRow_paramObj[_field_detail_scheduletime] = {value:cards[i].scheduletime};
            addDetailRow_paramObj[_field_detail_atteStatus] = {value:cards[i].atteStatus};
            addDetailRow_paramObj[_field_detail_signtype] = {value:cards[i].signtype};
            addDetailRow_paramObj[_field_detail_signdate] = {value:cards[i].signdate};
            addDetailRow_paramObj[_field_detail_signtime] = {value:cards[i].signtime};
            WfForm.addDetailRow("detail_"+detail_dt,addDetailRow_paramObj);
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
      WfForm.controlBtnDisabled(false);
      callback();
      return;
    }catch(ex1){
      WfForm.controlBtnDisabled(false);//取消流程中的按钮置灰
      return;
    }
  }

</script>
