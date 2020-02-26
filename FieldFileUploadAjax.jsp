<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestBaseUtil" class="weaver.workflow.request.RequestBaseUtil" scope="page" />
<jsp:useBean id="FieldFileUploadUtil" class="weaver.workflow.request.FieldFileUploadUtil" scope="page" />
<%
	String src = Util.null2String(request.getParameter("src"));
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	if("getMaxsize".equals(src)){
		String result = "{\"category\":\"%s\",\"maxsize\":\"%s\"}";
		String fieldvalue = Util.null2String(request.getParameter("fieldvalue"));
		String maxsize = "5";
		String doccategory = "";
		String isbill = WorkflowComInfo.getIsBill(wfid);
		rs.execute("select doccategory from workflow_selectitem where fieldid = " + fieldid + " and isbill = " + isbill + " and selectvalue = " + fieldvalue);
		if(rs.next()){
			doccategory = Util.null2String(rs.getString(1));
			if(!"".equals(doccategory)){
				String[] array = doccategory.split(",");
				String secid = "";
				if(array.length == 3){
					secid = array[2];
				}else{
					secid = doccategory;
				}
				maxsize = ""+Util.getIntValue(SecCategoryComInfo.getMaxUploadFileSize(secid),5);
				if("0".equals(maxsize))
					maxsize = "5";
			}
		}
		result = String.format(result,doccategory,maxsize);
		out.print(result);
	}else if("getFieldlabel".equals(src)){
		int language = Util.getIntValue(request.getParameter("language"),7);
		String result = RequestBaseUtil.getFieldLabel(fieldid,wfid,language);
		out.print(result);
	}else if("getSelectField".equals(src)){
		String result = "";
		if(fieldid != null && !"".equals(fieldid)){
			if(fieldid.indexOf("field") > -1)
				fieldid = fieldid.replaceAll("field","");
			if(fieldid.indexOf("_") > -1){
				fieldid = fieldid.split("_")[0];
			}
			weaver.workflow.request.FileUploadDTO dto =  FieldFileUploadUtil.getFileUploadInfo(fieldid,wfid,requestid);
				result = dto.getSelectedCateLog();
		}
		out.print(result);
	}

%>