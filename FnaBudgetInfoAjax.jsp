<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@page import="org.json.JSONObject"%><jsp:useBean id="budgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" />
<%
User user = HrmUserVarify.getUser(request, response) ;
if(user==null){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String returnStr = "";
boolean getFnaInfoDataBatch = Util.getIntValue(request.getParameter("getFnaInfoDataBatch"),0)==1;//是否批量获取预算信息
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);
String fromRequestTypeBudgetKPI = Util.null2String(request.getParameter("fromRequestTypeBudgetKPI")).trim();//本次请求是否来自预算变更流程
if(getFnaInfoDataBatch){
	String[] indexnoArray = request.getParameterValues("indexno");
	if(indexnoArray!=null && indexnoArray.length > 0){
		boolean requestIsFromMobile = Util.getIntValue(request.getParameter("requestIsFromMobile"),0)==1;//请求是否来自移动端
		ResourceComInfo rci = null;
		DepartmentComInfo dci = null;
		SubCompanyComInfo cci = null;
		HashMap<String, String> fcc_hm = null;
		if(requestIsFromMobile){
			rci = new ResourceComInfo();
			dci = new DepartmentComInfo();
			cci = new SubCompanyComInfo();
			fcc_hm = new HashMap<String, String>();
			RecordSet rs = new RecordSet();
			rs.executeQuery("select id, name from FnaCostCenter");
			while(rs.next()){
				fcc_hm.put(Util.null2String(rs.getString("id")).trim(), Util.null2String(rs.getString("name")).trim());
			}
		}
		
		StringBuffer orgNameStr = new StringBuffer();
		
		returnStr = "{\"fnaBudgetInfoArray\":[";
		if(requestIsFromMobile){
			orgNameStr.append(",\"fnaOrgNameArray\":[");
		}
		int indexnoArrayLen = indexnoArray.length;
		for(int i=0;i<indexnoArrayLen;i++){
			int indexno = Util.getIntValue(indexnoArray[i]);
			
			int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype_"+indexno),0);//科目
			int orgtype = Util.getIntValue(request.getParameter("orgtype_"+indexno),0);//报销类型 人员0/部门1/分部2   3/2/1
			int orgid  = Util.getIntValue(request.getParameter("orgid_"+indexno),0);//报销单位
			String applydate  = request.getParameter("applydate_"+indexno);//报销日期
			int dtl_id  = Util.getIntValue(request.getParameter("dtl_id_"+indexno),0);//该明细对应数据库明细表PkId，0表示新增的明细行，无对应数据库记录PkId
			
			int _orgtype = -1;
			if(orgtype==0){//个人
				_orgtype=3;
			}else if(orgtype==1){//部门
				_orgtype=2;
			}else if(orgtype==2){//分部
				_orgtype=1;
			}else if(orgtype==3){//成本中心
				_orgtype=FnaCostCenter.ORGANIZATION_TYPE;
			}
			
			budgetHandler.setFromRequestType_budgetKPI(fromRequestTypeBudgetKPI);
			String infos = budgetHandler.getBudgetKPI4DWR(applydate,_orgtype,orgid,budgetfeetype, true, true, dtl_id, requestid);

			if(i > 0){
				returnStr += ",";
				if(requestIsFromMobile){
					orgNameStr.append(",");
				}
			}
			returnStr += "{\"indexno\":"+indexno+",\"fnainfos\":"+JSONObject.quote(infos)+"}";

			if(requestIsFromMobile){
				String _orgName = "";
				if(orgtype==0){//hrmresource
					_orgName = rci.getLastname(String.valueOf(orgid));
				}else if(orgtype==1){//hrmdepartment
					_orgName = dci.getDepartmentName(String.valueOf(orgid));
				}else if(orgtype==2){//hrmsubcompany
					_orgName = cci.getSubCompanyname(String.valueOf(orgid));
				}else if(orgtype==3){//FnaCostCenter
					_orgName = fcc_hm.get(String.valueOf(orgid));
				}
				orgNameStr.append("{\"fnaOrgName\":"+JSONObject.quote(_orgName)+"}");
			}
		}
		returnStr += "]";
		if(requestIsFromMobile){
			orgNameStr.append("]");
			returnStr += orgNameStr.toString();
		}
		returnStr += "}";
	}else{
		returnStr = "{\"fnaBudgetInfoArray\":[],\"fnaOrgNameArray\":[]}";
	}
}else{
	int budgetfeetype  = Util.getIntValue(request.getParameter("budgetfeetype"),0);//科目
	int orgtype = Util.getIntValue(request.getParameter("orgtype"),0);//报销类型 人员0/部门1/分部2   3/2/1
	int orgid  = Util.getIntValue(request.getParameter("orgid"),0);//报销单位
	String applydate  = request.getParameter("applydate");//报销日期
	int dtl_id  = Util.getIntValue(request.getParameter("dtl_id"),0);//该明细对应数据库明细表PkId，0表示新增的明细行，无对应数据库记录PkId
	if(orgtype==0){//个人
		orgtype=3;
	}else if(orgtype==1){//部门
		orgtype=2;
	}else if(orgtype==2){//分部
		orgtype=1;
	}else if(orgtype==3){//成本中心
		orgtype=FnaCostCenter.ORGANIZATION_TYPE;
	}

	budgetHandler.setFromRequestType_budgetKPI(fromRequestTypeBudgetKPI);
	String infos = budgetHandler.getBudgetKPI4DWR(applydate,orgtype,orgid,budgetfeetype, true, true, dtl_id, requestid);
	returnStr = infos;
}
%>   
<%=returnStr%>