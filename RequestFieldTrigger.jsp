
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.google.common.base.Strings" %>
<%@ page import="weaver.workflow.request.RequestFieldTriggerCheck" %>
<%@ page import="weaver.workflow.request.RequestFieldTrigger" %>

<!DOCTYPE>
<html>
  <head>
	<%@ include file="/systeminfo/init_wev8.jsp" %>

	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script  src='/js/ecology8/request/freeWorkflowShow_wev8.js'></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	
	<link rel="stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css">
	<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
	<script language="javascript" src="/js/jquery/ui/ui.droppable_wev8.js"></script>

	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
	
	<link href="/css/ecology8/request/freeWorkflowShow_wev8.css" type=text/css rel=STYLESHEET>

	<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
	<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

  </head>
  
  <body >
  	<div style="border:1px double #e7e7e7; width: 800px;height: 900px;overflow-y: auto;margin:20px auto;padding:10px 10px; ">
	  <%
		  int workflowId = Util.getIntValue(Util.null2String(request.getParameter("workflowId")),-1);
		  if(workflowId == -1){
	  %>
		<form id='queryForm' name="queryForm" method="post" action="RequestFieldTrigger.jsp">
				  <div id="querytable" style="width: 50%;margin: auto;background-color: cornsilk;">
					  <table style="width: 100%">
						  <tr><td>路径ID：</td><td><input type=text id="workflowId" name="workflowId" placeholder="例：108"/></td></tr>
						  <tr><td>开始时间：</td><td><input type=text id="startDate" name="startDate" placeholder="例：2019-04-12 12:01:22"/></td></tr>
						  <tr><td>结束时间：</td><td><input type=text id="endDate" name="endDate" placeholder="例：2019-04-12 16:01:22"/></td></tr>
					  </table>
				  </div>
			      <div id="submit" style="width: 50%;margin: auto;background-color: cornsilk;">
					  <input type="submit" value="确定">
				  </div>
			  </form>
	  <%
		  }

		  /**
		   * 1、根据流程ID获取表单基本信息：
		   * workflowId
		   * formId
		   * isBill
		   * mainTable 主表名称
		   * detailTables 明细表集合
		   */
		  RecordSet rs = new RecordSet();
		  String startDate = Util.null2String(request.getParameter("startDate"));
		  String endDate = Util.null2String(request.getParameter("endDate"));

		  String colName = "createdate";
		  if(rs.getDBType().equals("oracle")){
			  colName += "||' '||createtime";
		  }else if(rs.getDBType().equals("mysql")){
			  colName = "concat("+colName+",' ',createtime)";
		  }else if(rs.getDBType().equals("sqlserver")){
			  colName += "+' '+createtime";
		  }

		  String conditon = "";
		  if(!Strings.isNullOrEmpty(startDate)){
			  conditon = " and "+colName+" >= '"+startDate+"'";
		  }
		  if(!Strings.isNullOrEmpty(endDate)){
			  conditon += " and "+colName+" <= '"+endDate+"'";
		  }

		  RequestFieldTrigger rft = new RequestFieldTrigger();
		  RequestFieldTriggerCheck fieldTriggerCheck = new RequestFieldTriggerCheck(workflowId);
		  //主表规则
		  List<List<String>> mainSortList = rft.getSortDataInputIds(workflowId,0);
		  //明细表规则
		  List<List<String>> detailSortList = rft.getSortDataInputIds(workflowId,1);

		  RecordSet recordSet = new RecordSet();
		  recordSet.executeQuery("select requestid,requestnamenew from workflow_requestbase where workflowid = ? "+conditon+" order by requestid desc",workflowId);
		  while(recordSet.next()){

			  List<String> allTriggers = new ArrayList<String>(); //已启用联动规则
			  List<String> execTriggers = new ArrayList<String>(); //执行过的规则
              List<String> allTriggers2 = new ArrayList<String>(); //已启用联动规则
              List<String> execTriggers2 = new ArrayList<String>(); //执行过的规则

			  Map<String,List<Map<String,Map<String,String>>>> mainInfos = new HashMap<String,List<Map<String,Map<String,String>>>>();
			  Map<String,Map<String,List<Map<String,Map<String,String>>>>> detailInfos = new HashMap<String,Map<String,List<Map<String,Map<String,String>>>>>();


			  int requestId = Util.getIntValue(Util.null2String(recordSet.getString("requestid")));
			  String requestname = Util.null2String(recordSet.getString("requestnamenew"));
			  //1、主表
			  fieldTriggerCheck.execMainCheck(requestId,mainSortList,allTriggers2,execTriggers2,mainInfos);
			  //2、模拟字段联动过程
			  fieldTriggerCheck.execDetailCheck(requestId,detailSortList,allTriggers,execTriggers,detailInfos);

	  %>
	  <div style="margin: 0px 10px;">
		  <h3 style="margin: 10px 0px;color: #0D9BF2">[<a style="color: #0D9BF2" href="/workflow/request/ViewRequestForwardSPA.jsp?requestid=<%=requestId%>&ismonitor=1" target="_blank"><%=requestname%></a>]字段联动规则执行过程及值更新情况</h3>
          <span style="color: red;">主表已启用联动规则：共计(<%=allTriggers2.size()%>条)</span>
          <p><%=String.join("、",allTriggers)%></p>
          <span>主表已执行联动规则：共计(<%=execTriggers2.size()%>条)</span>
		  <p><%=String.join("、",execTriggers2)%></p>
		  <table >
			  <%
				  for(String triggerName : mainInfos.keySet()){
					  List<Map<String,Map<String,String>>> tempRowInfos = mainInfos.get(triggerName);
					  if(tempRowInfos.isEmpty()) continue;
			  %>
			  <tr><td style="text-align: center;color: red;">触发规则[<%=triggerName%>]更新值情况</td></tr>
			  <%

				  for(Map tempRowInfo : tempRowInfos){

					  Map<String,String> tempOldValue = (Map)tempRowInfo.get("oldValue");
					  Map<String,String> tempNewValue = (Map)tempRowInfo.get("newValue");
			  %>
			  <tr>
				  <td style="color: red;">表单字段>></td>
				  <%
					  for(String tempKey : tempNewValue.keySet()){
				  %>
				  <td><%=tempKey%></td>
				  <%
					  }
				  %>
			  </tr>
			  <tr>
				  <td>原值>></td>
				  <%
					  for(String tempKey : tempOldValue.keySet()){
				  %>
				  <td><%=tempOldValue.get(tempKey)%></td>
				  <%
					  }
				  %>
			  </tr>
			  <tr>
				  <td>新值>></td>
				  <%
					  for(String tempKey : tempNewValue.keySet()){
				  %>
				  <td><%=tempNewValue.get(tempKey)%></td>
				  <%
					  }
				  %>
			  </tr>
			  <%
						  }

					  }
			  %>
		  </table>

		  <span style="color: red;">明细表已启用联动规则：共计(<%=allTriggers.size()%>条)</span>
		  <p><%=String.join("、",allTriggers)%></p>
		  <span>明细表已执行联动规则：共计(<%=execTriggers.size()%>条)</span>
		  <p><%=String.join("、",execTriggers)%></p>

		  <%
			  int index = 0;
			  for(String key : detailInfos.keySet()){
				  index ++;
		  %>
		  <table >
			  <%
				  Map<String,List<Map<String,Map<String,String>>>> tempDetailInfo = detailInfos.get(key);

				  for(String triggerName : tempDetailInfo.keySet()){
					  List<Map<String,Map<String,String>>> tempRowInfos = tempDetailInfo.get(triggerName);
					  if(tempRowInfos.isEmpty()) continue;
			  %>
			  <tr><td style="text-align: center;color: red;">明细表<%=index%>：<%=key%>触发规则[<%=triggerName%>]更新值情况</td></tr>
			  <%

				  	for(Map tempRowInfo : tempRowInfos){

				  	    Map<String,String> tempOldValue = (Map)tempRowInfo.get("oldValue");
				  	    Map<String,String> tempNewValue = (Map)tempRowInfo.get("newValue");
			  %>
			  <tr>
				  <td style="color: red;">表单字段>></td>
				  <%
					   for(String tempKey : tempNewValue.keySet()){
				  %>
				  			<td><%=tempKey%></td>
				  <%
					   }
				  %>
			  </tr>
			  <tr>
				  <td>原值>></td>
				  <%
					  for(String tempKey : tempOldValue.keySet()){
				  %>
				  		<td><%=tempOldValue.get(tempKey)%></td>
				  <%
					  }
				  %>
			  </tr>
			  <tr>
				  <td>新值>></td>
				  <%
					  for(String tempKey : tempNewValue.keySet()){
				  %>
				  		<td><%=tempNewValue.get(tempKey)%></td>
				  <%
					  }
				  %>
			  </tr>
			  <%
				  }

			  }
		  }
			  %>
		  </table>

	  </div>

	  <%
		  }

	  %>
		<div>
			<a href="javascript:window.history.go(-1);">返回</a>
		</div>
	</div>
  </body>
</html>
