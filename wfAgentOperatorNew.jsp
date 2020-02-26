<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.request.wfAgentCondition"%>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.workflow.request.RequestAddShareInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion" %>
<%@ page import="weaver.workflow.agent.AgentManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs6" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs7" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />

<%
/*
* last modified by cyril on 2008-08-25 for td:9236
* 流程代理的优化

*/
int agentId = 0;
boolean flag = true; 
String method=request.getParameter("method");
String beagenterId2=request.getParameter("beagenterId");
String haveAgentAllRight = request.getParameter("haveAgentAllRight");
String sql = "";
String currentDate=TimeUtil.getCurrentDateString();
String currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
String[] value;
String[] value1;
String isCountermandRunning="";
String beaid="";
String aid="";
String wfid="";
char separ = Util.getSeparator();
String Procpara = "";
/*-----------------  流程代理设置 ---[老的代理目前暂时不用]-------------------- */
/*----------- td2551 xwj 20050902 begin ----*/
int isPendThing=Util.getIntValue(request.getParameter("isPendThing"),0);
int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
//e8 新改造后收回代理的逻辑
 if(method.equals("backAgent"))
{
	String agented = Util.null2String(request.getParameter("agented"));
	String agentFlag = Util.null2String(request.getParameter("agentFlag"));
	try{
		//使用E9改造后的代理收回逻辑
		AgentManager agentManager = new AgentManager(user);
		String symbol = Util.null2String(request.getParameter("agenttype"));
		boolean needBackRunning = "y".equals(Util.null2String(request.getParameter("isCountermandRunning")));	//收回流转中数据
		if ("it".equals(symbol) || "mt".equals(symbol)) {	//单个、批量收回代理
			String agentids = Util.null2String(request.getParameter("agentid"));
			List<String> range = new ArrayList<String>();
			for(String keyid : agentids.split(",")){
				if(!"".equals(keyid))
					range.add(keyid);
			}
			agentManager.takeBackAgent(range, needBackRunning);
		}else if ("pt".equals(symbol)) {		// 全部收回逻辑
			int agentid = Util.getIntValue(request.getParameter("agentid"));
			int bagentuid = Util.getIntValue(request.getParameter("beaid"));
			String agentuid = agentManager.getAgentuid(agentid, bagentuid);
			if(Util.getIntValue(agentuid) > 0){
				List<String> range = agentManager.getAgentRangeByUser(Util.getIntValue(agentuid), bagentuid);
				agentManager.takeBackAgent(range, needBackRunning);
			}
		}
	}catch(Exception e){
		flag = false;
		e.printStackTrace();
	}
	if(flag){
		response.sendRedirect("/workflow/request/wfAgentGetBackConfirm.jsp?agented="+agented+"&agentFlage="+agentFlag+"&infoKey=3&isclose=1");
		return;
	}else{
		response.sendRedirect("/workflow/request/wfAgentGetBackConfirm.jsp?agented="+agented+"&agentFlage="+agentFlag+"&infoKey=4&isclose=1");
		return;
	}
}
//e8 改造新增流程代理逻辑
else if(method.equals("addAgent")){
String beagenterIdAll=Util.fromScreen(request.getParameter("beagenterId"),user.getLanguage());
//防篡改
List<String> userRange = new ArrayList<String>();
userRange.add(user.getUID()+"");
rs.executeQuery("select * from HrmUserSetting where resourceId = "+user.getUID());
if(rs.next() && "1".equals(rs.getString("belongtoshow"))){
	String[] arr = Util.null2String(user.getBelongtoids()).split(",");
	for(String userstr : arr){
		userRange.add(userstr);
	}
}
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
if(!"".equals(beagenterIdAll)){
arr2 = beagenterIdAll.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
for(int k=0;k<userlist.size();k++){
	int j=k+1;
	  int beagenterId = Util.getIntValue((String)userlist.get(k),0);
	if(!HrmUserVarify.checkUserRight("WorkflowAgent:All", user) && userRange.indexOf(beagenterId+"") == -1)
		continue;	//防篡改
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    String agentrange = Util.fromScreen(request.getParameter("agentrange"),user.getLanguage());
    String rangetype = Util.fromScreen(request.getParameter("rangetype"),user.getLanguage());
    int isCreateAgenter=Util.getIntValue(request.getParameter("isCreateAgenter"),0);
    int isProxyDeal=Util.getIntValue(request.getParameter("isProxyDeal"),0);
    String overlapAgenttype = Util.fromScreen(request.getParameter("overlapAgenttype"),user.getLanguage());
    String overlapagentstrid = Util.fromScreen(request.getParameter("overlapagentstrid"),user.getLanguage());
    String source=Util.null2String(request.getParameter("source"));//来源【由于目前代理添加业务统一整合到java文件，方便其他地方重用。不同来源返回地址不一样】

    //标示【流程代理时，有重复范围记录特殊处理 1、从新保存的代理设置中去除重复设置内容 2、以新保存的代理设置替换已有重复的代理设置】
	overlapagentstrid = "'"+StringUtils.replace(overlapagentstrid, ",", "','")+"'";
    if(!overlapAgenttype.equals("")){
    	if(overlapAgenttype.equals("1")){//从新保存的代理设置中去除重复设置内容
        String agentretu=wfAgentCondition.agentadd(""+beagenterId,""+agenterId,beginDate,beginTime,endDate,endTime,agentrange,rangetype,""+isCreateAgenter,""+isProxyDeal,""+isPendThing,usertype,user,"1","");  
    	if(agentretu.equals("1")){
    	    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=1");
    	         return;  //xwj for td3218 20051201
    	     }else if(agentretu.equals("2")){//流程不能重复被代理，请收回后再代理！
    	    	 	response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=5");
    	            return;
    	     }else if(agentretu.equals("3")){//代理失败出现异常
    	    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=2");
    		     return;  //xwj for td3218 20051201
    		 }else if(j==userlist.size()){//代理成功
    			// System.out.println("--sucess---------");     
    			 //response.sendRedirect("/workflow/request/wfAgentCDBackConfirm1.jsp?infoKey=1&isclose=1");
    			// return;  //xwj for td3218 20051201
    				%> 
    	    	       <script language=javascript >
    				    try
    				    {
    				    	var dialog =parent.getDialog(window);
    						var parentWin = parent.getParentWindow(window);
    						parentWin.location.href="/workflow/request/wfAgentAdd.jsp?isclose=1";
    						//parentWin.closeDialog();
    						dialog.close();
    					}
    					catch(e)
    					{
    					}
    					</script>
    	    		<% 
    			
    		 }
    	 }else{
    	 
    		 //以新保存的代理设置替换已有重复的代理设置
    		 //首先将重复的代理给收回来，然后再重新代理{指收回重复}
    		 String strSubClause="  and (" + Util.getSubINClause(overlapagentstrid, "agentid", "IN") + ") " ;
    		 rs4.executeSql("select workflowid,agentid,bagentuid from workflow_agentConditionSet where agenttype='1' "+strSubClause);
    		 while(rs4.next()){
    			 String workflowidold=Util.null2String(rs4.getString("workflowid"));
    			 String agentidold=Util.null2String(rs4.getString("agentid"));
    		 	 String bagentuidold=Util.null2String(rs4.getString("bagentuid"));
    		 	 wfAgentCondition.Agent_to_recover(bagentuidold,workflowidold,agentidold,"agentrecoverold",""+agenterId);//收回代理
    		 }	
    		 
    		 //添加代理
			 String agentretu=wfAgentCondition.agentadd(""+beagenterId,""+agenterId,beginDate,beginTime,endDate,endTime,agentrange,rangetype,""+isCreateAgenter,""+isProxyDeal,""+isPendThing,usertype,user,"2","");
			 
			 if(agentretu.equals("1")){
			    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=1");
			         return;  //xwj for td3218 20051201
			  }else if(agentretu.equals("2")){//流程不能重复被代理，请收回后再代理！
			    	 	response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=5");
			            return;
			  }else if(agentretu.equals("3")){//代理失败出现异常
			    	 response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=2");
	    		     return;  //xwj for td3218 20051201
	    	  }else if(j==userlist.size()){
    			 //	response.sendRedirect("/workflow/request/wfAgentCDBackConfirm.jsp?infoKey=1&isclose=1");
    			// return;  //xwj for td3218 20051201
				 
	    			%> 
	     	       <script language=javascript >
	 			    try
	 			    {
	 			    	var dialog =parent.getDialog(window);
	 					var parentWin = parent.getParentWindow(window);
	 					parentWin.location.href="/workflow/request/wfAgentAdd.jsp?isclose=1";
	 					//parentWin.closeDialog();
	 					dialog.close();
	 				}
	 				catch(e)
	 				{
	 				}
	 				</script>
	     			 
	     		<% 
    			
	    	 }
    	 }
    }else{
    	//添加代理设置
    	String agentretu=wfAgentCondition.agentadd(""+beagenterId,""+agenterId,beginDate,beginTime,endDate,endTime,agentrange,rangetype,""+isCreateAgenter,""+isProxyDeal,""+isPendThing,usertype,user,"3","");
			
	     if(agentretu.equals("1")){
	    	 response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=1");
	         return;  //xwj for td3218 20051201
	     }else if(agentretu.equals("2")){//流程不能重复被代理，请收回后再代理！
	    	 	response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=5");
	            return;
	     }else if(agentretu.equals("3")){//代理失败出现异常
	    	 response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=2");
		     return;  //xwj for td3218 20051201
		 }else  if(j==userlist.size()){//代理成功
			 response.sendRedirect("/workflow/request/wfAgentAdd.jsp?infoKey=1&isclose=1");
    			 return;  //xwj for td3218 20051201		 
		 }	 
    }
} 
}else if(method.equals("editAgent")){//编辑代理日期时间
    int agentid = Util.getIntValue(request.getParameter("agentid"),0); 
    int beagenterId = Util.getIntValue(request.getParameter("beagenterId"),0);
    int agenttype = Util.getIntValue(request.getParameter("agenttype"),0);
    int agenterId = Util.getIntValue(request.getParameter("agenterId"),0);
    String beginDate = Util.fromScreen(request.getParameter("beginDate"),user.getLanguage());
    String beginTime = Util.fromScreen(request.getParameter("beginTime"),user.getLanguage());
    String endDate = Util.fromScreen(request.getParameter("endDate"),user.getLanguage());
    String endTime = Util.fromScreen(request.getParameter("endTime"),user.getLanguage());
    String workflowid = Util.fromScreen(request.getParameter("workflowid"),user.getLanguage());
    String overlapAgenttype = Util.fromScreen(request.getParameter("overlapAgenttype"),user.getLanguage());
    String overlapagentstrid = Util.fromScreen(request.getParameter("overlapagentstrid"),user.getLanguage());
    overlapagentstrid = "'"+StringUtils.replace(overlapagentstrid, ",", "','")+"'";
   
    try{
    	  if(!overlapAgenttype.equals("")){
   		  	   if(overlapAgenttype.equals("1")){//从新保存的代理设置中去除重复设置内容
    		          //编辑代理日期 既然之前已经存在，本次修改日期之后过滤掉哪么就可以不用处理。编辑本身就是单条的流程
    		          response.sendRedirect("wfAgentEditCondition.jsp?infoKey=3&agentid="+agentid);
    		          return;  //xwj for td3218 20051201
    		 	}else{
    		 		if(agenttype==0){
    		 			wfAgentCondition.SetUpdateagent(beginDate,beginTime,endDate,endTime,""+agentid,overlapagentstrid,""+beagenterId,workflowid,user);
    		 		    //response.sendRedirect("wfAgentEditCondition.jsp?infoKey=4&agentid="+agentid);
    		 		}else{
	   		    		 //以新保存的代理设置替换已有重复的代理设置
	   		    		 //首先将重复的代理给收回来，然后再重新代理
	   		    		 rs4.executeSql("select workflowid,agentid,bagentuid from workflow_agentConditionSet where agentid in("+overlapagentstrid+") and agenttype='1' ");
	   		    		 while(rs4.next()){
	   		    			 String workflowidold=Util.null2String(rs4.getString("workflowid"));
	   		    			 String agentidold=Util.null2String(rs4.getString("agentid"));
	   		    		 	 String bagentuidold=Util.null2String(rs4.getString("bagentuid"));
	   		    		     wfAgentCondition.Agent_to_recover(bagentuidold,workflowidold,agentidold,"editAgent_cf",""+agenterId);//收回代理
	   		    		 }	
	   		    		 //根据新的代理日期重新代理
	   	    	         wfAgentCondition.again_agent_wf(""+beagenterId,workflowid,beginDate,beginTime,endDate,endTime,user,"editAgent",""+agentid);
		 		    
    		 		}  
    		 	}
    	  } else{
    	    	String retustr=wfAgentCondition.getAgentType(""+agentid);
    	    	if(retustr.equals("1")){//代理中[代理中的流程，需要将代理中的先收回 然后再重新代理一下]
    	    		//收回代理操作	
    	         	wfAgentCondition.Agent_to_recover(""+beagenterId,workflowid,""+agentid,"editrecover",""+agenterId);
    	    		//根据新的代理日期重新代理
    	             wfAgentCondition.again_agent_wf(""+beagenterId,workflowid,beginDate,beginTime,endDate,endTime,user,"editAgentNew",""+agentid);
    	    	
    	    	}else {//2已结束

    	    		 
    	    		wfAgentCondition.SetWorkflowAgent(""+agentid,beginDate,beginTime,endDate,endTime,""+beagenterId,""+workflowid,user);
    	    		//收回代理操作	
    	    	}
    	  }
    }
    catch(Exception e){
        flag = false;
    }
    
    if(flag){
    	if(!overlapAgenttype.equals("")){
    		%>
     	 <script language=javascript >
		 try
		    {
		    	var dialog =parent.getDialog(window);
				var parentWin = parent.getParentWindow(window);
				parentWin.location.href="/workflow/request/wfAgentEditCondition.jsp?infoKey=4";
				//parentWin.closeDialog();
				dialog.close();
			}
			catch(e)
			{
			}
		</script>
    		<%
    	}else{
    		 response.sendRedirect("wfAgentEditCondition.jsp?infoKey=1");
    	     return;  //xwj for td3218 20051201
    	}
     
    }else{
        response.sendRedirect("wfAgentEditCondition.jsp?infoKey=2");
        return;  //xwj for td3218 20051201
    }
}
 
%>


<%! //老数据

public boolean isOldData(String requestid){
RecordSet RecordSetOld = new RecordSet();
boolean isOldWf_ = false;
RecordSetOld.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSetOld.next()){
	if(RecordSetOld.getString("nodeid") == null || "".equals(RecordSetOld.getString("nodeid")) || "-1".equals(RecordSetOld.getString("nodeid"))){
			isOldWf_ = true;
	}
}
return isOldWf_;
}

%>