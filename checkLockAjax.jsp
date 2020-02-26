<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.workflow.request.LockDTO" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LockUtil" class="weaver.workflow.request.LockUtil" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String requestid = request.getParameter("requestid");
	String userid = request.getParameter("userid");
	String nodeid = request.getParameter("nodeid");
	String timestamp = request.getParameter("timestamp");
	String type = Util.null2String(request.getParameter("type"));
	User user = HrmUserVarify.getUser (request , response) ;
	if("updatelock".equals(type)){
		boolean result = LockUtil.updateLockInfo(requestid,nodeid,userid,timestamp);
		out.print(result);
	}else if("unlockRequest".equals(type)){
		String needclose = Util.null2String(request.getParameter("needclose"));
		if("1".equals(needclose)){//�����������Ҫ�ر�ҳ��
			session.setAttribute("needclose_"+requestid+"_"+userid,"1");
		}
		LockUtil.unlockRequest(requestid,nodeid);
		out.print("");
	}else if("checkEffictive".equals(type)){//У��ҳ���Ƿ���Ч
		boolean result = LockUtil.checkEffictive(requestid,nodeid,userid,timestamp);
		out.print(result);
	}else if("checkisLock".equals(type)){
		nodeid = WFLinkInfo.getCurrentNodeid(Util.getIntValue(requestid),user.getUID(),Util.getIntValue(user.getLogintype(),1)) + "";               
	    
	    //��������У��
	    LockDTO lockdto = LockUtil.isLocked(requestid,nodeid);
	    String msg = "";
	    if(lockdto.isLock()){
	    	if(user.getLanguage() == 7){
	    		msg = "��ǰ�����ѱ�"+ResourceComInfo.getResourcename(lockdto.getUserid())+"ǩ�������޷����д˲�����";
			}else if(user.getLanguage() == 9){
				msg = "��ǰ�����ѱ�"+ResourceComInfo.getResourcename(lockdto.getUserid())+"���������o���M�д˲�����";
			}else{
				msg = "The request has been checked by "+ResourceComInfo.getResourcename(lockdto.getUserid())+",you can not do this operate!";
			}
	    }
	    out.print(msg);
	}
	
%>