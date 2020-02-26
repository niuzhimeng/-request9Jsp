<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />

<%

	String userId = "" + user.getUID();
	String Showoperator = Util.null2String(request.getParameter("Showoperator"));
	String commonuse = Util.null2String(request.getParameter("commonuse"));
	String signlisttype = Util.null2String(request.getParameter("signlisttype"));
	
	String multisubmitnotinputsign = Util.null2String(request.getParameter("multisubmitnotinputsign"));
	int wfspaopenwindow = Util.getIntValue(request.getParameter("wfspaopenwindow"),0);
	String where = " where userId=" + userId;
	RecordSet.executeSql("select * from workflow_RequestUserDefault" + where); 
	
	if(RecordSet.next()){
	    RecordSet.executeSql("update workflow_RequestUserDefault set Showoperator=" + Showoperator+",commonuse="+commonuse+",signlisttype="+signlisttype + ", multisubmitnotinputsign='" + multisubmitnotinputsign + "',wfspaopenwindow='"+wfspaopenwindow+"' " + where);
	    //RecordSet.executeSql("update workflow_RequestUserDefault set commonuse=" + commonuse + where);
	    //更新缓存
   		RequestDefaultComInfo.updateRequestDefaultComInfoCache(userId);
	}
	else{
	    RecordSet.executeSql("insert into workflow_RequestUserDefault(userId,Showoperator,commonuse,signlisttype, multisubmitnotinputsign,wfspaopenwindow) "
	    +"values("+userId+","+Showoperator+","+commonuse+","+signlisttype+", '" + multisubmitnotinputsign + "','"+wfspaopenwindow+"')");
	    //新增缓存
   	 	RequestDefaultComInfo.addRequestDefaultComInfoCache(userId);
	}
	
	//modify by xhheng @20050206 for TD 1541
	response.sendRedirect("/workflow/request/RequestUserDefault.jsp?saved=true");
%>
